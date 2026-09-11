# Run Lifecycle And Budget Grants

Read this reference at intake, before reusing an active contract, and before a
budget decision. Request boundaries separate unrelated context and give new work
adequate capacity. They do not erase unresolved failures or authorize side effects.

## Choose The Request Mode

Use the latest user request and current contract, not conversation, repository,
branch, or child identity, to choose:

| Mode | When | Contract and context | Budget |
|---|---|---|---|
| `new` (default) | A distinct backpressure request, including an independently verifiable follow-up after completion | New run ID, contract, and fresh manager | Full initial profile limits; no prior usage |
| `extend` (exception) | User-added requirements benefit from joint validation with the active objective | Same run ID; record the expansion and why joint validation helps | Add the selected profile's default grant or explicit additional amount |
| `continue` | Resume unfinished work under the same contract, recover an interruption, or perform internal repair/reverification | Same run, decisions, and applicable evidence | Preserve limits and usage |

An explicit request to continue the same work takes precedence over the default.
A request to add acceptance conditions to the same feature can be `extend`; a
separate feature after completion is normally `new`. Record one sentence naming
the shared objective or acceptance conditions that justify `extend`. Familiarity
with earlier work or a nearly exhausted budget is not a justification.

Classify a correction, narrower scope, or clarification without material added
work as `continue`; update decisions and invalidate affected evidence normally.
An internal plan revision, failed check, transport retry, reviewer replacement,
or renamed gate is not a user request for new capacity. If the distinction affects
scope or authority and cannot be established, ask one focused question. Do not
ask merely because an existing contract is present.

## New Run: Fresh Manager And Minimal Handoff

The receiving agent is the intake coordinator. It reads only enough prior state
to classify the request and preserve relevant facts, then:

1. Record the current request source, new run ID, profile, and dispatch budget.
2. Stop or finish outstanding old-run actions before switching the active file.
   Archive the old contract, counters, blockers, and evidence references at
   `.backpressure/runs/<old-run-id>/run.md`, preserving existing history. Do not
   mark unfinished work complete or overwrite a contract still owned by a live
   manager. Concurrent runs need separate workspaces and active contract paths.
3. Inventory staged, unstaged, and relevant untracked work. Preserve it. Choose
   the immutable review base for the new goal and record why it covers the
   changes requiring review. Do not blindly choose current `HEAD` or snapshot
   pre-existing in-scope changes into the base, hiding them from the review diff.
   Out-of-scope changes remain protected; identify their dependencies as needed.
4. Dispatch exactly one fresh manager with no inherited parent or prior child
   transcript, using the manager-intake template in `subagent-prompts.md`.
   Explicitly disable history inheritance where the host supports it (for
   example, `fork_turns="none"`). A new ID with copied history is not isolation.
5. The manager reads the minimal handoff, checks current repository facts,
   activates the new contract, and runs the protocol. An agent already assigned
   the manager role does not dispatch another manager. The coordinator relays
   user steering and returns results without creating a second gate ledger.

The handoff contains the current request and source, accepted plan and constraints,
repository and base, protected existing work, relevant unresolved defects or
requirements, and references to unknown or partial external operations. Include
exact operation targets, successful parts, attempts, and read-back obligations
when needed to avoid duplicate effects. Carry no prior `PASS`, skip, or budget as
current state and no full discussion, action transcript, or unrelated history.
Read archived details only when a concrete dependency requires them.

If the host cannot launch a manager without inherited conversation history,
record `context isolation: unavailable` and the limitation, then hand off rather
than claiming a fresh run. A new document, context summary, or compacted session
is not actual isolation. If the user explicitly accepts a degraded same-context
execution, record that exception and still use a new contract and budget; never
report it as isolated. Do not create a user-visible task without authorization.

## Existing Run: Continue Or Extend

For `continue`, re-establish current contract and repository state and retain all
counters. A replacement manager may receive a compact same-run handoff when
needed, but its launch costs a call and does not reset anything. Child resumption
still follows Invocation Freshness; a continued run does not imply reused children.

When continuing a suspended archived run, first quiesce the current active run
and preserve its state, then transfer active-file ownership to the resumed run.
Restore its original run ID, limits, used counters, grant references, and blockers;
revalidate evidence against current state. Suspension and restoration grant no
capacity and do not mark either run complete. Never let two managers write the
same active contract.

For `extend`, retain the run ID and usable current evidence. Before further work:

1. Identify the user request by a stable source reference and assign an extension
   ID. Record the added requirements and joint-validation reason. Check for an
   existing grant for this same request, including archived grant records.
2. Reassess the profile against the expanded risk. Determine the explicit
   additional amounts, or the defaults below, and check route feasibility.
3. Update linked active decisions, normative targets, agreed plan, and validation
   hash together. Mark affected evidence and final semantic review stale. A
   materially new plan still requires user agreement; approval already present
   in the request or accepted plan is sufficient.
4. Record the grant once and derive new limits from the initial limits plus
   unique grants. Keep all used counters. On interruption, reconcile the request,
   grant, and totals before proceeding; never credit a grant twice. If a recorded
   grant is only partly applied, finish reconciling that grant rather than
   creating another. Conflicting amounts for the same request require resolution.

Keep only a compact grant table in the active contract. Archive lengthy expansion
rationale and old artifacts; preserve stable grant references for deduplication.
Do not append previous full contracts into the active contract.

## Accounting

Initial profile defaults come from SKILL.md. Every child launch or resume costs
one call, including dispatch of the fresh manager and delegated Boundary Action
attempts. A new run starts at zero used calls and its manager dispatch consumes
one of its own calls, never an old run's budget. Transport failure costs a call
but no repair round. A completed non-pass gate evaluation costs one repair round.

| Allowance | New run | Authorized extension | Continue |
|---|---|---|---|
| Total child-call limit | Profile default or explicit initial override | Add reassessed profile default, or explicitly specified additional calls | Unchanged |
| Repairs per gate | Profile default or explicit override | Add profile repair allowance to affected existing gates; new gates get that profile's initial allowance | Unchanged |
| Plan review | At most 2 invocations when required | A material plan expansion receives a new allowance of at most 2 invocations scoped to that extension | Unchanged |
| Final-call floor | At least profile floor and required remaining final route | Recompute from profile and remaining route; do not sum old and new floors | Recompute remaining route |
| Boundary Action execution attempts | At most 2, including first attempt | Unchanged for the same operation | Unchanged |

An explicit child-call amount overrides only the default child-call grant; default
repair and plan extension allowances still apply unless separately overridden.
Record affected gate IDs and added repair allowance; existing
unaffected gates receive no top-up. Usage never resets. Do not assign existing
work a new gate to obtain initial allowances. Plan-review invocations consume
child calls too; unused invocation slots do not transfer to unrelated plans.

Example: Standard limit 20, used 18, extension default +20 gives limit 40, used
18, remaining 22. An affected gate with limit 3 and used 3 receives +3, producing
limit 6, used 3, remaining 3. A new gate gets limit 3, not 6. A material plan
expansion gets its own two-review allowance even when the initial two were used;
existing findings and repeated-failure stops remain in force.

The final-call floor is reserved inside the child-call ceiling. Before dispatch,
account for startup and the required remaining route; before another repair,
require remaining calls above the floor for a fresh final verifier and reviewer
plus any required specialist, publication, Boundary Action, and read-back calls.
If the route cannot fit, hand off instead of reducing coverage. The user may
explicitly override budget values; record the value, source, and reason without
weakening freshness, role separation, or stop conditions. Tokens and session
counts are telemetry, not separate pass conditions.

## Stops Survive Request Boundaries

Budget capacity permits additional authorized work; it is not evidence that a
blocker was resolved. Preserve stable failure and operation references wherever
they affect the requested work, including in a new run's minimal handoff.

- An unchanged repeated failure still stops work without new evidence. An agent
  cannot re-label the same failing task as `new` or `extend` to evade this rule.
- Two reviews with unresolved blockers or SHOULD findings exhaust that plan
  allowance and require escalation. An extension provides capacity for materially
  expanded requirements, not another attempt at the same unchanged blocker.
- A renamed action, new run ID, changed specification, or extension grant does
  not reset the two attempts for the same external operation or erase partial
  success. Resolve unknown outcomes through authoritative read-back before any
  retry; never repeat known-successful parts.
- Required evidence, scope, authority, and user stop conditions remain binding.
  An earlier run's approval or external-write authorization is not automatically
  current authority; verify the latest intent for the exact operation and target.
