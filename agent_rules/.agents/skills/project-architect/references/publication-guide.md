# Output and Publication Guide

Output is a requested reader-facing view, not design authority or permission to
publish. Use existing locations; default to optional `output/`, created lazily.

## Choose Purpose and Source Eligibility

| Purpose | Eligible content | Guardrail |
|---|---|---|
| Review / decision support / meeting preparation | Current facts, draft proposals, alternatives, meeting reports, outside inputs | Label recommendation, uncertainty, authority, and decision requested |
| Agreed explanation / implementation handoff | Agreed target, verified current facts, relevant unresolved conditions explicitly separated | Do not turn targets into claims of implemented/verified behavior |
| Final external sharing | Current content eligible for the stated audience and disclosure boundary | No stale/unresolved proposals presented as consensus or established fact |

An unconfirmed proposal can be a useful output. It must remain a proposal, even
when polished. Draft discussion may use meeting/external sources; do not restrict
all output to agreed design. Equally, a source's mere existence does not make it
eligible for final agreed explanation.

## Author or Revise

1. Derive audience, reader goal/use moment, scope, language, status, and disclosure
   boundary from the request. Ask only about materially missing information.
2. Read the smallest relevant source set. Identify observed facts, agreed target,
   drafts, and unresolved items; resolve contradictions needed for the purpose.
3. Apply `document-writer`: full guidance for a new document/major rewrite,
   localized guidance for a small edit. It owns readability and any needed
   Humanizer use; no mandatory separate full-document stage.
4. Organize around the reader's questions, not lens order, directory layout, or
   discussion chronology. Include the essential context rather than requiring
   readers to open internal design files. Use meaningful visuals/examples under
   delegated writing guidance, not a duplicate style checklist here.
5. Apply current minimal OKF to the primary document **and** managed source map.
   Use safe `type`, `title`, `description`, truthful draft/trust metadata, and only
   disclosure-safe optional provenance in the shareable document. Internal paths,
   IDs, and private source URLs do not belong in shareable frontmatter.
6. Compare technical meaning with eligible sources. Check standalone usefulness,
   status honesty, relevant links/assets, and disclosure boundaries. A small
   wording correction checks affected sections only and preserves existing
   metadata/maps; it does not authorize unrelated format migration.

Do not fabricate consensus, verification, metrics, production outcomes, source
checks, or actor identities. New v0.2 documents do not emit legacy timestamp or
`# Citations`; preserve existing legacy metadata unless migration is requested.

## Lightweight Provenance

For an independently maintained/shared document, keep a light
`internal-source-map.md`, normally next to its primary file:

```text
output/delivery-handoff/
  delivery-handoff.md
  internal-source-map.md
  assets/                    # only assets actually used
```

The map records section -> source -> source/content status and necessary notes.
No universal hashes, revision checkpoints, per-visual inventory, or timestamp
ceremony. Add stronger traceability only when risk or maintenance requires it.
The map is internal and absent from the shareable file set. It is nevertheless a
managed OKF concept, not an exception to frontmatter requirements.

A one-off brief can use inline private provenance when appropriate instead of a
separate map. If the brief is shareable, keep private provenance outside it;
do not leak internal paths/IDs by using an inline shortcut. Public-safe attribution
can remain in the shareable document when useful and permitted.

Use the [templates](templates.md) for a minimal source-map starting point. Keep
existing source maps intact on scoped edits, updating only affected mappings.

## Sharing Boundary

- Authoring is not sending or publishing. Confirm the exact destination/scope
  before any separately requested external write.
- Make the shareable file set explicit when packaging/sending. Exclude internal
  source maps and private provenance. Include only referenced safe assets.
- A shareable primary document stands alone: no private design paths, absolute
  repository paths, internal IDs, prompts, source-map references, or private URLs
  outside the explicitly approved disclosure boundary.
- Check metadata, diagrams, captions, asset links, comments, and inspectable image
  metadata, not only prose. Use safe local links within the shareable set or
  eligible public references; do not rely on private parent-directory links.
- An internal review brief may use internal links when suitable for its actual
  audience. Do not incorrectly call it ready for external sharing.

## Feedback and Freshness

- Expression-only changes stay local to output. Semantic changes to agreed design
  must be reconciled with its owning design before adoption into an agreed view.
  Clear authorized feedback within approved scope needs no repeated approval.
- A changed source triggers assessment of mapped/directly affected sections,
  not every output or the whole design tree. Propagate only while meaning changes.
- If affected content cannot yet be refreshed/checked, record the outstanding
  stale/blocked scope in the private map or appropriate checkpoint. Remove that
  state only after the relevant check succeeds. No transient stale ritual for
  changes completed and checked now.
- If only source formatting changed, confirm unchanged meaning and adjust only
  necessary mapping details. Do not rewrite the output or update unrelated
  metadata. A missing source blocks only claims that actually depend on it.

## Proportional Completion Check

For initial/major output, check the whole requested artifact; for small revisions,
only changed sections and their actual effects:

- Purpose, audience, source eligibility, and proposal/agreement status are clear.
- Essential meaning, obligations, boundaries, uncertainty, and terminology match.
- Relevant claims are traceable with proportionate private/public-safe provenance.
- Standalone understanding, useful representation, links/assets, and disclosure
  safety hold for the intended reader and shareable set.
- Minimal OKF is valid; optional trust/provenance is truthful and safe to share.
- Outstanding freshness or verification gaps are explicit, not claimed complete.
