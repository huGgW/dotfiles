# Run Lifecycle And Continuity

The main current session owns the run as manager. Classify requests by latest
intent, not session, branch, or contract filename. There is no coordinator or
manager dispatch.

## Request Modes

- `new`: a distinct objective, normally an independently verifiable follow-up.
- `extend`: authorized added requirements sharing an active objective where joint
  validation has a concrete benefit. Update the accepted plan and affected evidence.
- `continue`: the same unfinished objective, repair, clarification, narrower scope,
  or interruption recovery. Explicit continuation takes precedence over `new`.

Ask only when this distinction materially affects scope or authority. A material
plan expansion needs agreement unless already approved. Internal revisions,
renaming, retries, and reviewer replacement do not remove blockers or grant authority.

## Activating Or Restoring A Contract

Before replacing the active file, quiesce outstanding children. Do not overwrite
a live action's contract or create concurrent writers. Inventory and protect
staged, unstaged, and relevant untracked work. For correctness work choose a base
exposing all in-scope changes, including existing work needing review.

Archive one compact `.backpressure/runs/<run_id>/run.md` for the replaced run:
final summary, unresolved items, coverage, relevant evidence references, and
external outcomes. Preserve existing archives; do not copy logs/transcripts or
save snapshots at every gate. Never archive secrets.

A new contract carries relevant constraints, protected work, superseded meaning,
unresolved hazards, and exact partial-operation references, not automatic old
PASS decisions or full conversation history. Recheck earlier external authority
against latest intent without duplicate approval when target, scope, and material
risk remain unchanged. Reuse unaffected current evidence with its dependency reason.

For `continue`, re-establish current contract, subject identity, active child IDs
and actual host lifecycle, blockers, next action, and external outcomes. To restore
a suspended run, first quiesce and summarize the current run. Revalidate evidence;
restoring a run does not make history current. No destructive migration of legacy
records is required; retain relevant facts in the compact current summary.

## Stops Survive Renaming And Boundaries

- Stop an unchanged failure when there is no new evidence, hypothesis, or approach.
  Recurring oscillation or fruitless repairs require focused investigation or a
  human decision; cosmetic novelty cannot justify unlimited loops.
- Preserve stable finding IDs and evidence-backed dispositions across repairs.
- Successful parts and unknown external outcomes survive new IDs/specifications.
  Read back before retrying; never repeat a successful part to recover another.
- Carry an active CI episode's absolute deadline across polls, handoff, and resume.
  A renamed/restarted wait or newer head does not automatically restart its clock.
- Required evidence, exact authority, and user stop points remain binding. On a
  cyclic route identify the occurrence, such as the next push or current feedback
  snapshot; an ambiguous occurrence needs clarification, not an inferred cycle.

No routine call, repair, cycle, or attempt counters are needed. Only if the user
chooses a coarse run-wide cap for long unattended work, record its source and
stop condition; it cannot waive required gates or the anti-loop rules. This is
not a monitoring daemon or workflow scheduler.
