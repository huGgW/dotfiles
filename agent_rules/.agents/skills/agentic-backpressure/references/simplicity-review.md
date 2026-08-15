# Conditional Simplicity Review

Use this focused review to remove avoidable complexity from a mechanically valid
candidate without weakening the approved behavior. It is an independent semantic
gate, not a source-editing role and not a substitute for Final Correctness.

## Trigger

Create the gate only when the candidate or explicit request contains at least one
of these conditions:

- A new dependency
- A new abstraction or wrapper
- A new configuration option
- Unnecessary cross-layer expansion
- Duplicated platform functionality
- An explicit simplification request

Record the concrete trigger in `BACKPRESSURE.md`. A small direct patch with none
of these conditions does not consume a simplicity-review child call. Reassess the
trigger from the actual diff after targeted mechanical verification rather than
assuming every non-trivial patch needs this gate.

Do not remove complexity required for safety, correctness, compatibility,
accessibility, migration, operational needs, ownership boundaries, or approved
architecture. The reviewer must distinguish unnecessary machinery from a
load-bearing safeguard instead of treating fewer constructs as inherently better.

## Placement And Freshness

Route a triggered review in this order:

1. A fresh worker produces the coherent patch.
2. A fresh verifier passes the applicable targeted mechanical checks.
3. A fresh independent child loads `code-reviewer` with its simplicity lens and
   evaluates that exact state.
4. If the manager maps the capability report to `SEND_BACK`, a fresh repair
   worker applies only the accepted finding delta.
5. Candidate mutation creates a new `state_id`. Prior simplicity-review evidence
   and affected mechanical evidence are stale; use a fresh verifier and fresh
   simplicity reviewer for the changed state.
6. Freeze the candidate only after the manager maps the current capability report
   to `PASS`, then run the separate fresh final verifier and fresh
   whole-changeset reviewer required by Final Correctness. A mapped `BLOCKED` or
   `ESCALATE_HUMAN` result stops for handoff instead.

Every invocation consumes one child call. Only a completed non-pass gate
evaluation consumes a repair round. Reviewer replacement resets neither budget.
A mapped simplicity `PASS` covers only its declared delta and never passes the
whole changeset.

## Validation Subject

The manager binds the review to the current `validation_spec_hash`, base, and
`state_id` from the active contract and supplies them as the expected subject
identity. It provides active decisions, Agreed Plan, ownership and public API
constraints, acceptance criteria, safeguards, required checks, and out-of-scope
boundaries as authoritative context. An already user-approved plan is the active
authority; the reviewer does not ask for duplicate approval.

Inspect:

- The complete base-to-candidate diff for the declared work slice
- Relevant definitions, symbols, callers, and configuration consumers needed to
  determine whether the added machinery has a real second use or invariant
- Current targeted mechanical evidence for the same `state_id`
- Stable findings and dispositions from an earlier simplicity review, when this
  is a changed-state recheck

If the candidate, validation specification, or declared review scope differs,
the capability report uses `SUBJECT_MISMATCH`. If required context or evidence
cannot be established, it uses `INCOMPLETE` rather than guessing. The manager
maps those statuses through `references/gate-checklist.md`.

## Capability Handoff

Construct the `code-reviewer` request with:

- Repository root from the active run.
- Exact base-to-candidate subject identity.
- Exact work-slice scope and directly relevant symbols, callers, and consumers.
- Active decisions, Agreed Plan, constraints, safeguards, and acceptance criteria
  as authoritative context.
- `simplicity` as the required lens.
- Stable prior finding IDs and dispositions for a changed-state recheck.
- The current `validation_spec_hash`, base, and `state_id` as expected identity.

The child follows `code-reviewer/references/simplicity-lens.md`. That capability
owns the `delete`, `stdlib`, `native`, `yagni`, and `shrink` review method,
evidence threshold, finding schema, and load-bearing-complexity analysis. This
workflow does not duplicate those rules.

The child returns only the `code-reviewer` capability report:

- `review_completion`
- `subject_identity`
- `reviewed_scope`
- coverage
- findings
- unverified areas
- residual risks

The reviewer does not edit source files, choose a repair owner, or return a core
gate outcome. Findings may support a narrower implementation within the approved
plan but cannot broaden scope. The manager reports unrelated findings without
routing them for repair.

## Outcomes

Apply the shared capability mapping in `references/gate-checklist.md`.
`COMPLETE` with no unresolved `BLOCKER` or `SHOULD` satisfies the review
condition; `COMPLETE` with an in-plan repairable finding maps to `SEND_BACK`;
`INCOMPLETE` maps by its evidence or decision cause; and `SUBJECT_MISMATCH` maps
to `STALE`. Only the manager's mapped `PASS` advances successfully.
