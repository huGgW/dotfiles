# Workspace and Change Rules

## Organize for Readers, Not Process Compliance

Preserve the project's established locations. For new work, the optional default
roots are sibling `design/`, `meeting/`, `external/`, `output/`, and `issues/`.
Create a root or file only when it has useful content. The following is an
illustration, not a scaffold to generate:

```text
design/
  index.md                  # useful navigation when multiple topics exist
  plan.md                   # short resume checkpoint
  delivery.md               # current selected-scope design
  domain-model.md           # shared concepts, ownership, invariants, vocabulary
  contracts/delivery.md      # one authoritative shared contract
  decisions.md              # optional important decision memory
meeting/
  2026-10-19-delivery-review.md
external/
  partner-delivery-contract.md
output/
  delivery-review.md         # one-off purpose-specific brief
  delivery-handoff/
    delivery-handoff.md
    internal-source-map.md  # useful for independently maintained/shared output
issues/                     # only when persistent issue handoff is requested
```

- Use descriptive kebab-case names. Date-topic meeting names aid retrieval.
- Do not mandate phase directories, option files, indexes at every level, or a
  log. A root navigation index should link rather than repeat design rationale.
- Split by independent reader need or maintenance ownership, not fixed depth.
  Keep small comparisons inline. Separate extensive alternatives only when useful.
- Shared `contracts/`, `interfaces/`, or `cross-cutting/` directories are optional;
  use whichever existing home owns the common definition. Avoid dual authority.
- All managed Markdown follows minimal current OKF, including checkpoint, meeting,
  external reference, output, source-map, and local issue docs. Reserved filenames
  keep reserved semantics. Raw originals remain unchanged.

## Resume Existing Trees Non-Destructively

1. Read existing `plan.md` and useful navigation, if present. Locate the selected
   agenda, current shared owners, unresolved questions, and next useful action.
2. Preserve numbered trees such as `4-high-level-design/` and `5-detailed-design/`.
   Their names do not impose a sequential workflow. Do not move, rename, flatten,
   or regenerate them simply to match new defaults.
3. Restore only the selected agenda's documents and relevant contracts. Distinguish
   the documented target, drafts, and evidenced implementation; old completion
   checkboxes are not proof of implementation.
4. Continue an already authorized task without another phase/list confirmation.
   Ask only when authority, choice, scope, or conflicting evidence is material.
5. At a useful checkpoint, shorten resume-only clutter without deleting important
   decision/history content. Preserve existing histories and unknown metadata.
   Propose a separate authorized migration if restructuring would help; never
   silently migrate metadata or discard content as cleanup.

If no checkpoint exists, use the supplied context/current docs and create a short
one when it helps continuation. Do not invent prior consensus to fill it.

## Concurrent Agenda Memory

Keep a compact row per live agenda in `plan.md`: selected scope, design status,
owner if known, current document/shared contract links, open question, next action.
Detailed discussion stays in its topic home. A paused agenda can resume without
reloading unrelated branches. Remove completed resume clutter once durable
outcomes live in their owning documents; do not convert the checkpoint to a
backlog or execution-status database.

## Important Decisions Have One Rationale Home

Record significant choices, including the initial one: costly/irreversible
commitment, shared boundary/data ownership, security/regulation, operations,
important contract, delivery-sensitive reversal, or recurring contentious tradeoff.
Keep decision, why, consequences, related docs, and supersession where relevant.

A compact local section, a dedicated decision document, or `decisions.md` can own
the record. Choose one; an optional catalog only links/summarizes. Do not duplicate
the comparison in local, central, and change-log records. Preserve existing logs;
do not create new chronological machinery for ordinary corrections. Git history
alone is not the rationale for important choices.

## Proportional Change Handling

1. Identify the authorized changed meaning and owning design. A meeting note,
   outside update, or output comment is input, not automatic adoption.
2. Apply the change and compare it once against the authorized input. Preserve
   scope, obligations, numbers, rationale, uncertainty, and unrelated content.
3. Inspect direct dependents whose relevant meaning could change: shared model,
   contract consumers, linked output sections, and affected existing tickets.
   Continue only while impact continues; no full graph or full-tree audit needed.
4. For renames/moves, check affected links and source mappings. Do not silently
   restructure existing paths without authorization.
5. Update affected current docs within authorized scope; surface conflicts with
   in-progress implementation contracts rather than silently rewriting them.
   Remote ticket edits require separate explicit authorization.
6. Leave a clear outstanding-work note only for unresolved/unverified affected
   content. Place concept notes after frontmatter, reserved-file notes under the
   title/body top. Remove an existing note only after its relevant check succeeds.

Formatting/wording changes with unchanged meaning do not invalidate dependents.
Preserve existing metadata/source maps during a scoped correction; do not trigger
an unrelated migration or transient stale/add/remove cycle. Substantial new output
needs its purpose-specific checks, not a global design audit.

## Outside Inputs Without Sync Infrastructure

- Meeting notes retain source locator/context and separate reported/verified,
  proposed/authorized, conflicting/open, and applied/remaining items as needed.
- External references retain the outside owner and canonical locator. Decide
  whether the input is one-off or recurring; checkpoint only to detect useful
  deltas. Compare changed meaning rather than copying the same update repeatedly.
- Keep one source home and link from other agendas. Mark snapshots as snapshots
  and preserve original authority; do not count mirrors as independent evidence.
- No default per-platform sync system, full snapshots, automatic fetches,
  scheduled jobs, tracker bookkeeping, or permission inferred from "periodic".
