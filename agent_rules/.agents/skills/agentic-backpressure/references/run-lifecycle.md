# Run Lifecycle And Budgets

The main current session owns the run as manager. There is no coordinator,
manager dispatch, no-history manager requirement, or manager call charge.
Classify requests by latest intent, not session, branch, or contract filename.

## Request Modes

| Mode | Meaning | Capacity |
|---|---|---|
| `new` | Distinct request; normally an independently verifiable follow-up after completion | Initial profile limits, zero used calls |
| `extend` | User-added requirements sharing an active objective; joint validation has a concrete benefit | Unique authorized grant; retain usage |
| `continue` | Same unfinished objective, repair, clarification, narrower scope, or interruption recovery | Retain limits and usage |

Explicit continuation takes precedence over the default `new`. Familiarity or
budget exhaustion does not justify extension. Internal revisions, failed checks,
transport retries, reviewer replacements, and renamed gates grant no capacity.
Ask only when the distinction materially affects scope or authority.

## Activating Or Restoring A Contract

Before replacing the active file, quiesce outstanding children. Do not overwrite
a live action's contract or create concurrent writers. Inventory and protect
staged, unstaged, and relevant untracked work. Select a base that exposes all
in-scope changes, including existing work needing review; record the rationale.

Write one compact `.backpressure/runs/<run_id>/run.md` for the replaced run:
final summary, counters, unresolved items, criterion coverage, relevant evidence
references, and external outcomes. Preserve existing archives; do not copy full
logs/transcripts or save a contract snapshot at every gate. Archive details only
when relevant; never secrets. Do not silently omit unknown outcomes or important
superseded meaning while reducing history.

A new contract carries relevant constraints, protected work, unresolved hazards,
and exact partial-operation references, not old PASS decisions, budgets, or full
conversation history. Prior approvals are not current evidence. Recheck earlier
external authority against latest intent without demanding duplicate approval
when target, scope, and material risk are unchanged.

For `continue`, re-establish contract/state and retain counters. To restore a
suspended archived run, quiesce and summarize the current run, then restore the
original run ID, limits, usage, grants, and blockers. Revalidate evidence;
suspension/restoration grants nothing. No destructive migration of older records
is required: read the relevant legacy facts and use a compact current summary.

## Extension Grants

1. Identify the stable user request and unique extension ID. State added scope
   and why joint validation helps. Check active and archived grants for duplicates.
2. Reassess risk; use the profile grant or explicit additional amount.
3. Update decisions, linked requirements, accepted plan, and validation hash
   together. Stale affected evidence and final review. Obtain agreement for a
   materially new plan unless already explicitly approved.
4. Credit the grant once; retain usage. Derive limits from initial values plus
   unique applied grants. Reconcile interrupted/partial grant updates before
   dispatch; conflicting amounts require resolution, not a second grant.

Keep only a compact grant entry with request, delta, amount, affected gates,
plan allowance, and applied/reconciliation status. Preserve references needed
for deduplication; do not append old contracts.

## Accounting

Initial calls/repairs come from the profile table in SKILL.md.
Every child launch or resume costs one call, including delegated action attempts
and interrupted recovery. The main manager costs none. Direct manager tool
read-back costs no child call; reserve delegated read-back only when required.
Completed non-pass gate evaluations consume one repair; transport failure alone
does not. A result remains non-pass even when its owner is environment/baseline.

| Allowance | New | Authorized extension | Continue |
|---|---|---|---|
| Child calls | Profile or explicit initial limit | Add reassessed profile grant or explicit calls | Unchanged |
| Repairs | Profile allowance per gate | Add allowance to affected existing gates; new gates get initial allowance | Unchanged |
| Plan review | Four calls when required | Four scoped calls for material plan expansion | No new allowance |
| External attempts | Four total per underlying operation, initial included | No reset for same operation | No reset |

An explicit call grant overrides only calls unless other allowances are explicitly
overridden. Do not rename existing work to create a new repair allowance.
Plan reviews consume calls; unused slots do not transfer to unrelated plans.
Example: recorded Standard limit 20, 18 used, default extension +40 => limit 60,
used 18, remaining 42. Affected repair allowance 6, used 6, grant +6 => limit 12,
used 6. Existing recorded limits/grants are not retroactively replaced by defaults.

Compute final reserve from actual uncovered required work: verifier checks,
fresh final review, required specialists, publication judgment/checks, actions,
and delegated read-back. Count combined checks/lenses once. There is no mandatory
3/4/6 floor. Before dispatch, available calls must cover this action plus the
remaining required route without double-counting this action. Repairs must also
fit their allowance. If infeasible, escalate rather than weakening coverage.
Explicit budget overrides need source/value/reason; they do not waive other stops.

## Stops Survive Renaming And Boundaries

- An unchanged failure repeated without new evidence stops. A genuine new or
  expanded objective can receive capacity but cannot relabel an unchanged blocker.
- Exhausting the allowed plan reviews with unresolved blockers or SHOULD findings
  requires escalation.
  Extension capacity addresses material added requirements, not the same blocker.
- Underlying external attempts, partial successes, and unknown outcomes survive
  new IDs/specifications. Read back before retry; never repeat successful parts.
- Required evidence, scope, authority, and user stop points remain binding.
