# Gate Decisions And Evidence

The manager maps current evidence to `PASS`, `SEND_BACK`, `BLOCKED`, `STALE`, or
`ESCALATE_HUMAN`. Only PASS satisfies a required outcome. CI `pending` means
waiting, not repair; `routing.md` owns its deadline and revision binding. This
file owns mapping/evidence, not state algorithms, lens methods, or external-operation rules.

## Prerequisites

Before each selected capability, require an actionable goal/scope/stop and its
resolved prerequisites. Correctness work requires accepted plan/constraints,
criteria/checks, immutable review base, and current hash/state. Observation-only
work requires exact external provenance, not gratuitous local gates. Main-session
manager ownership needs no isolation gate. A sufficient approved plan needs no planning worker. Preserve
protected work, active user intent, important superseded meaning, and unknown
external outcomes. At contract intake or a material plan change, an unresolved
decision follows the SKILL.md Contract Intake rule, not an invented interpretation.
Anti-loop stops and handoff still name one focused decision.

Worker, verifier, and reviewer remain separate; workers cannot validate their own
patches. Verifiers/reviewers do not edit the subject. Child lifecycle follows
SKILL.md: terminal host-reusable worker/verifier continuation is allowed within
the same approved scope; reviews are always fresh and independent.

## Evidence Binding

Each result needs the run, applicable subject identity, declared scope, and
producer attribution (tool or child ID/role/mode). For local gates this includes
the applicable hash and state; external observations use `routing.md` provenance.
Bind checks and reviews to
before/after state for the check set, not each command. Confirm fresh identity at
invocation and gate synthesis; detected drift makes the affected evidence STALE
even if commands succeeded.
Same session never means same evidence. Partial evidence can be retained only
when its actual coverage and identity still match; run uncovered work, not a
ritual duplicate check set.

Mechanical evidence records check IDs, actual command/cwd, exit status, relevant
output or reference, and failure owner/route. Commit-dependent evidence records
exact before/after HEAD for the applicable set. Run identical frozen-state checks
once and map all targeted/final coverage IDs to that result.
Read-only or declared sandboxed-local commands are checks; source mutation or
external writes are work/actions. A check changing candidate content cannot pass.

Review evidence records subject identity, reviewed scope, coverage of criteria
and relevant decisions/sources, findings with stable IDs/severity/file-line-symbol
evidence, unverified areas, and residual risk. Cover forbidden scope, ownership,
public API, agreed-plan semantics, and relevant superseded decisions. Criteria
invented by agents cannot substitute for user decision sources.

Reference contract anchors/IDs and report results/deltas without repeating unchanged
facts or empty optional sections; retain required identity/evidence/reviewer fields.
Store long output by reference, not copies. Keep latest results and one compact
decision/criterion -> current evidence or blocker mapping. Historical findings
explain repairs; they do not validate the repaired state.

## Capability Mapping

Reviewers load `plan-reviewer` or `code-reviewer` and return capability reports,
not protocol approval. First verify required identity/scope/coverage fields.

| Report | Manager outcome |
|---|---|
| `SUBJECT_MISMATCH` | `STALE` |
| `INCOMPLETE`: unavailable required repository/runtime evidence | `BLOCKED` |
| `INCOMPLETE`: unresolved requirement/authority/scope/ownership/risk | `ESCALATE_HUMAN` |
| `COMPLETE`: unresolved in-scope `BLOCKER` or `SHOULD`, repairable within plan | `SEND_BACK` |
| `COMPLETE`: finding needs new plan/authority/scope/API/risk decision | `ESCALATE_HUMAN` |
| `COMPLETE`: complete coverage, no unresolved `BLOCKER`/`SHOULD` | Review condition satisfied; other gate conditions still apply |

Invalid or materially incomplete reports remain BLOCKED; absent fields are not
approval. NIT is nonblocking unless the contract requires disposition. The manager
owns evidence-backed finding dispositions, repair routing, and enclosing gate.
COMPLETE alone never authorizes implementation, publication, or whole-run approval.

## Conditional Plan/Early Gates

Use the triggers in SKILL.md, not file count. Hash the exact plan before review;
mutable review status stays outside. A plan edit stales dependent evidence.
Require repository fit, load-bearing decisions, user-source alignment, boundaries,
and relevant superseded meaning. Repeated unresolved findings follow the
anti-loop stop; reviewer replacement does not remove the blocker.

An early targeted/focused gate passes only for its declared coverage and current
state. For risk/blocker repair review include original stable findings/evidence,
manager dispositions, concrete repair delta, justified adjacent regression scope,
and current mechanical evidence. Missing context routes investigation or BLOCKED,
not invented repair provenance. Simplicity follows `simplicity-review.md`.

## Mechanical And Repair Routing

Mechanical PASS requires every required applicable check passed on the current
state. Mechanical failure normally precedes review; diagnostic review is justified
only when command evidence cannot identify a safe route.

| Condition | Route |
|---|---|
| Supported worker/fixture/tooling-owned in-plan repair | `SEND_BACK` with concrete delta |
| Baseline/environment/unavailable evidence | `BLOCKED` |
| Wrong applicable hash/state/coverage | `STALE`, refresh affected evidence |
| Unresolved requirement/authority/risk | `ESCALATE_HUMAN` |

Assign worker/environment/tooling/human owner; optional fixture/baseline tags
preserve detail without expanding the state machine. An isolated baseline failure
remains non-pass; no gate weakening. If no authorized route establishes the
criterion, request a focused human decision while preserving the failed result.

SKILL.md owns conditional production root-cause triggers. Triggered evidence
records applicable precondition/reproduction/control/transaction/exception/lock
facts and labels cause as hypothesis or verified conclusion. Missing evidence
permits focused investigation with an owner/question, not production speculation;
use BLOCKED for unavailable facts, human escalation for unresolved behavior/authority.

## Final Correctness

PASS requires all of:

- Repository-changing work stopped; specification/base/candidate frozen.
- Required targeted and final checks covered by current verifier evidence.
  One combined verifier set is sufficient; rerun only uncovered/invalidated checks.
- Fresh independent whole-changeset `code-reviewer` report with complete required
  coverage, applicable simplicity/risk lenses, and no unresolved BLOCKER/SHOULD.
- Every active decision and criterion mapped to current evidence, not a blocker.
- No candidate/specification drift during the gate; all prerequisite gates pass.

Early delta reviews and worker diagnostics do not replace final evidence. Changed
content reopens correctness. Unaffected evidence can carry only with an explicit
dependency reason under the contract identity rules; final semantic review stales
after correctness-affecting changes.

A newly proven current-candidate defect against binding requirements reopens
affected correctness/readiness and blocks dependent publication immediately,
even before mutation or when repair is unauthorized. Reevaluate semantic
acceptance; keep valid mechanical results and rerun only checks whose coverage
or dependencies changed. Mere unsupported comments do not invalidate acceptance.
Route repairs through approved work, affected checks, and fresh final review.
User-adopted new requirements update the specification/accepted plan and stale
affected evidence under `backpressure-contract.md`, rather than silently changing
the review criteria. A completed findings observation does not clear this blocker.

## Selected External Outcomes, Actions, And Handoff

Apply `run-lifecycle.md` continuity and anti-loop stops; new names cannot bypass
the same blocker. For actions/publication apply `boundary-actions.md`, including
unknown outcomes, read-back, and candidate mutation before failure classification.

CI and PR feedback are optional capabilities, but both must pass if both are
required. CI PASS requires the exact required check set on the applicable tested
revision, run and attempt; pending/timeout, baseline, and infra failures remain
non-pass. Feedback completion requires evaluated findings/dispositions for the
bounded snapshot, refreshed provenance, and explicit unprocessed additions/gaps.
Do not label observation completion as whole-candidate correctness. An unavailable
required capability blocks; no simulated loading or invented evidence.

Handoff links current IDs, required-outcome coverage, check/review or observation
results, blockers, actual stop occurrence, next action, residual risk, and one focused decision
when needed. Include action authority/status/read-back and superseded/unresolved
context only when relevant; history is not current evidence.
