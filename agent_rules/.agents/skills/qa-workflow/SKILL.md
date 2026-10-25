---
name: qa-workflow
description: >-
  Design, execute, or assess software behavioral QA using requirements, observable
  outcomes, and risk-proportionate evidence. Use for QA scenarios, exploratory
  testing, sandbox/live behavioral checks, async or concurrency QA, and assessing
  whether a QA report supports its claims, even without an explicit QA label.
  Each mode works independently. Not for source/test implementation, code review,
  production incident diagnosis, or tool-operation instructions alone.
---

# Behavioral QA Workflow

Turn requirements into observable checks, run only authorized checks, and state
what the evidence actually supports. Scale effort to consequence and uncertainty,
not to a fixed ceremony.

## Choose the entry point

- **DESIGN:** produce or refine scenarios; no execution is implied.
- **EXECUTE:** run an existing plan or a small set of justified checks within the
  latest authorization. Fill material gaps before the affected action.
- **ASSESS:** evaluate supplied evidence and claims; do not silently rerun checks.

Use the requested entry point independently. Reuse suitable requirements, plans,
fixtures, and reports rather than restarting the whole workflow. If the request
mixes modes, state which actions are in scope. Skill invocation grants no access
or mutation authority, and a design agreement alone does not authorize execution.

For a small task, a response or compact table is enough. Use durable documentation
when requested or when multiple sessions, people, or substantial evidence need it.
Do not require files, hashes, manifests, audit logs, approval gates, or independent
reviewers merely because this skill is active.

## Shared working context

Identify only what is needed for the current entry point:

- The behavior, authoritative requirement or contract, and unresolved questions.
- The target version/environment, user identity or role, and relevant fixtures.
- The permitted actions, affected resources, preserved state, and excluded scope.
- The observation boundary: UI, live API, persisted state, worker, external effect,
  or component test; include which boundaries are inaccessible.
- Stop conditions, observation budget, and authorized recovery or restoration.

Ask a focused question when a missing fact changes safety or the expected result.
Otherwise proceed with labeled assumptions and bounded conclusions. Do not make
environment access a prerequisite for useful design or evidence-only assessment.

Before CLI use, inspect applicable project instructions and environment setup,
review configuration before activation, use command-scoped setup where possible,
and verify tool paths/versions. Do not install tools, grant trust, change persistent
configuration, or expose credentials to overcome a blocker without authorization;
redact secrets and unnecessary personal data in commands, artifacts, and reports.

## DESIGN: build a useful scenario set

1. Extract behavior and expected outcomes from authoritative requirements or
   contracts. Separate reported test results from directly observed evidence.
2. Prioritize by user impact, likelihood, change surface, and uncertainty. Select
   representative normal, boundary, rejection, permission, persistence, and
   state-transition cases where relevant; do not generate a Cartesian checklist.
3. Give each scenario a short identifier, purpose, fixture/preconditions, action,
   observable expected result, and evidence source. Add timing and recovery only
   where meaningful. A compact table may combine these fields.
4. Check fixture access and observation access separately. State what the chosen
   method can prove, what it cannot, and which blocked checks remain unexecuted.
5. Define stop/recovery criteria before proposing consequential actions. Reuse an
   existing suitable baseline; collect a new baseline only when comparison,
   attribution, or restoration needs it.

Distinguish contractual checks from exploratory questions. For example, without
a rule for repeated spaces, ask “How are internal spaces preserved?” rather than
inventing an expected normalization policy and marking divergence as failure.
Unknown length units, normalization order, role semantics, or timing guarantees
should remain questions until an authoritative source resolves them.

Reported unit-test success can guide risk selection; it is not observed UI,
persistence, or live permission evidence. Avoid declaring QA complete from it.

## EXECUTE: establish a trustworthy observation path

Before the first write, make a safe read through the intended runner,
credentials, transport, and parser/helper path. Validate the target identity,
fixture, response contract, and ability to interpret the result. A successful
read proves neither write authority nor product correctness.

Classify the read outcome explicitly:

| Outcome | Meaning and next step |
| --- | --- |
| Present | Interpret the contract-valid payload; confirm fixture and preserved state. |
| Typed absence | Accept only the contract-defined absence shape for this target; check whether the authorized scenario permits creation. |
| Authentication/authorization error | Access is blocked; do not treat the resource as absent or change credentials implicitly. |
| Timeout/transport error | State is unknown; inspect safely or stop, not create-on-error. |
| Parser/helper/runner error | Observation failed, even if raw transport succeeded; repair or use an approved safe alternative before relying on it. |

Typed absence need not be HTTP 404: a contract may define HTTP 422 with a
`notFoundError` body. Neither a nonzero exit nor any generic 4xx establishes
absence. Inspect status and typed payload together. If the raw response contains
a valid object but a helper cannot interpret it, classify the observation-path
failure; do not infer absence from a null helper result.

If there is no safe same-path read, describe the limitation and alternatives
(such as a documented read-only probe or isolated fixture). Resolve material
uncertainty with the user before writing; lack of a probe is not automatic
permission, automatic success, or a reason to silently widen access.

### Execute the bounded check

1. Confirm the latest permission still identifies the action and target. Do not
   ask again when exact scope is already clear and no material risk has changed.
2. Confirm fixture ownership, observation access, and preserved fields. Inspect
   mutation semantics: patch, merge, replacement, deletion, or asynchronous work.
   Do not send empty/default fields as placeholders with unknown semantics.
3. Run the smallest authorized action. Record scenario ID, relevant identity,
   actual result, and evidence sufficient to connect the result to this run.
4. Read back authoritative state and verify the intended change and preserved
   state. An acknowledgement alone does not establish persistence or effects.
5. Restore only what is separately authorized, with known original state and no
   intervening user changes. Verify restoration; report blocked cleanup honestly.

Stop on wrong target, unexpected blast radius, unavailable observation, unsafe
fixture ownership, or materially changed risk. Do not continue merely to finish
the checklist. Do not perform cleanup, delete fixtures, cancel work, or publish
a report unless the latest authorization includes that action and target.

### Asynchronous and concurrent behavior

Track request/correlation or idempotency keys, operation IDs, stage transitions,
and relevant timestamps. Distinguish submission, acceptance, processing,
convergence, and terminal success/failure; not every system exposes every stage.
Connect observations to the same operation rather than polling an unrelated
“latest” result. Observe within a stated budget and bounded polling cadence.

At the budget boundary, “accepted, still pending; completion unverified” can be
the correct result. A test observation budget is not a product SLA unless a
contract says so. Do not mark pending as a timeout defect solely for exceeding
your chosen budget, or keep polling indefinitely.

After a lost acknowledgement, timeout, or ambiguous write result, inspect current
state using available identities before retrying. If accepted work is found,
observe that work instead of resubmitting it. If the outcome remains unknown,
stop or seek a safe contract-backed recovery decision; do not assume failure.
Stopping observation does not authorize cancellation.

Two concurrent client submissions show overlapping client activity, not proven
server-side contention. To claim contention handling, obtain evidence that the
relevant server execution overlapped at the contested boundary. Do not widen
load, create more requests, or change fixtures just to strengthen a claim.

## ASSESS: match each claim to its evidence

Read existing artifacts first. Connect each material claim to its scenario,
target/version, method, observation, and limitations using available metadata;
do not manufacture provenance. Separate current evidence from historical reports
and reported results from independently observed ones. A historical similarity
supports a hypothesis, not certainty about the present cause.

Keep these evidence levels distinct:

| Evidence | Supports | Does not establish alone |
| --- | --- | --- |
| Component/unit test | Behavior inside the tested boundary | Live integration, persistence, UI, or external effects |
| Live API check | Observed live request/state contract | All UI-to-worker-to-effect boundaries |
| Bounded E2E observation | The connected boundaries actually traversed | Unobserved terminal completion or unrelated paths |
| Concurrent client requests | Concurrent submissions and observed responses | Server contention, race safety, or exactly-once effects |

Do not promote these levels by relabeling a report. Identify the smallest
additional evidence needed for an unsupported claim, without executing it unless
authorized. A missing observation can mean unverified or blocked, not necessarily
a product failure. Use “fail” for a demonstrated contradiction of an established
expected outcome, not for uncertainty or infrastructure failure.

## Results and short handoff

Keep execution, verification, and publication status separate. For example:
“execution: accepted; verification: terminal result unverified; publication:
not requested.” Scenario results may be pass, fail, blocked, or unverified, with
partial observations stated explicitly; use existing project vocabulary if clear.

Report the main conclusion first, then only useful scenario/evidence details,
unsupported claims, and residual risk. Do not imply that a drafted report has
been published or that a local simulation is a live QA run.

For continuation, leave a short handoff: latest authorized scope; unresolved
scenario/operation IDs and known stage; key evidence and gaps; stop condition;
next safe action. Include restoration status if state changed. No separate
handoff file is required for a small task.

## Neighboring workflows

- Reuse `verification-planning` evidence strategy when available; consult it for
  a missing strategy, not as an unconditional extra phase.
- Route source edits and automated test implementation through `code-development`
  and the relevant language/testing skills; QA discovery does not authorize fixes.
- Use tool-specific skills for browser, CLI, database, and service mechanics.
  Their access mechanics do not enlarge this task's authorization.
- Keep incident diagnosis and code review with their dedicated workflows.
- Use `agentic-backpressure` only when explicitly requested; do not turn ordinary
  QA into an automatic worker/verifier/reviewer gate loop.
