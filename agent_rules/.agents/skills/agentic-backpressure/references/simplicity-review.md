# Simplicity Lens Routing

Simplicity is independent semantic review, not an editing role. The
`code-reviewer` skill's `references/simplicity-lens.md` owns the finding method,
evidence threshold, and load-bearing-complexity analysis; do not duplicate it.

## Trigger And Placement

Include the simplicity lens when the candidate adds a dependency, abstraction,
wrapper, configuration option, unnecessary cross-layer expansion, duplicated
platform functionality, or the user explicitly requests simplification.
Record the concrete trigger from the actual diff, not just patch size.

Default: include this lens in the **one final whole-changeset reviewer**, alongside
correctness/tests and applicable risk lenses. A trigger is not an automatic
separate child call. A direct patch without a trigger needs no simplicity lens.

Use a separate early simplicity review only when multiple slices, load-bearing
uncertainty, or high repair risk makes feedback necessary before the next safe
action. Explain that sequencing reason; run applicable targeted checks first.
An early delta review never replaces the fresh final whole-changeset reviewer.

## Subject And Preservation

Bind review to current validation hash, base, state, and exact scope. Include
active user decisions, accepted plan, ownership/public API, criteria, non-goals,
current mechanical evidence, and relevant callers/configuration consumers.
Bind applicable safeguards to decision/criterion IDs and sources; recover missing
authority rather than invent IDs or promote a preference to a requirement.

Do not remove complexity required for safety, correctness, compatibility,
accessibility, migration, operational needs, ownership, or approved architecture.
Review the diff and definitions/callers needed to tell incidental machinery from
a load-bearing invariant. Fewer constructs alone do not establish improvement.

## Repairs

Use the shared review delta in `subagent-prompts.md` and capability mapping in
`gate-checklist.md`. Findings cannot broaden the approved plan. Send accepted
in-scope repairs to a worker; unrelated findings are report-only.

Mutation stales affected checks and review evidence. Reassess triggers and obtain
current checks plus a fresh independent review, carrying stable findings,
dispositions, concrete repair delta, and justified adjacent regression scope.
Worker/verifier same-role reuse does not make old evidence current. Final review
stays fresh; early lens evidence cannot approve the whole candidate.
