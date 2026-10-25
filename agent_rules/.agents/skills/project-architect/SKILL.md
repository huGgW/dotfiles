---
name: project-architect
description: >
  Use for designing and evolving complex projects, keeping a living current
  design while requirements change and selected parts enter implementation.
  Triggers include "프로젝트 설계해줘", "아키텍처 설계 시작하자", "시스템 설계",
  "프로젝트 구조 잡아줘", "설계 분해해줘", "설계 이어서", "architect this project",
  "design this system", and reconciling meeting or external feedback into an
  existing architecture. Uses optional, revisitable design lenses, independent
  agendas, shared domain models and contracts, and scope-specific issue readiness.
  Supports requested review briefs, explanation/handoff documents, and optional
  persistent implementation issues without making documents or tickets authority
  for unapproved choices. Not a mandatory full-project design or execution tracker.
---

# Project Architect

## Purpose and Boundaries

Keep a **human-readable current design** that explains what the system is, why
important choices were made, and what a selected implementation scope needs.
Design can continue in one area while another is implemented. Readiness is local:
do not wait for every component or every lens to be complete.

- Own architectural coherence, requirement/decision fidelity, source authority,
  shared models/contracts, selected-scope readiness, and design-change impacts.
- The user owns requirements, goals, priorities, constraints, and meaningful
  choices. Investigate facts and offer grounded recommendations, explicitly
  distinguished from approved decisions; do not invent project facts or targets.
- Use `document-writer` for a simple standalone document, `deep-research` for
  research without design work, and `to-issues` for implementation slicing.
- Implementation, execution tracking, remote publication, and tracker updates
  are separate authorized tasks. Design readiness authorizes none of them.

## Working Model

### Five Optional Design Lenses

These are questions to revisit, **not sequential phases or approval gates**.
Use whichever lenses help the current agenda; combine them in one document when
useful. The retained `phase-guide.md` filename is compatibility, not phase order.

| Lens | Question / useful result |
|---|---|
| 1. Problem | Who needs what outcome, why, within which real constraints and scope? |
| 2. Research | Which concrete uncertainty needs evidence before the next choice? |
| 3. Concept | What are we building, and how does it work from the outside? |
| 4. High-level design | What are the major flows, domain concepts, relationships, ownership, invariants, and shared names/contracts? |
| 5. Issue-ready elaboration | Can this selected outcome be implemented from clear scope, contracts, dependencies, verification, and explicit unknowns? |

Lens 4 establishes shared vocabulary for concepts, components, events, and
interfaces, not every method or field. Lens 5 resolves implementation-start
blockers while separating implementation-time choices and activation/release
conditions. See [the lens guide](references/phase-guide.md) when depth or readiness
is unclear.

### Independent Agendas, Shared Owners

Track concurrent agendas independently: scope, status, owner when known, shared
contract links, open questions, and next action. One agenda may be investigating,
another agreed and issue-ready, another awaiting an external owner. These are
design statuses, not claims of implementation or tracker progress.

- Start with the user's selected or highest-risk focus. Offer a brief context
  map when useful; no all-sibling first pass is required before going deep.
- Keep common models, names, and contracts in one authoritative home. Agenda
  documents link to it rather than maintaining competing copies.
- On switching, restore the selected agenda and its relevant shared contracts,
  not the whole tree. Explicitly expose conflicts that cross agenda boundaries.
- Keep `plan.md` a short resume checkpoint, not a roadmap, backlog, history, or
  execution tracker. Record detailed questions in the owning topic document.

### Truth and Consent

Distinguish within current documents:

| Claim | Required treatment |
|---|---|
| Observed implemented state | Evidence and observation scope; reported behavior is not verified behavior |
| Agreed target | Actual authorized decision and affected scope; not automatically implemented |
| Draft proposal / recommendation | Clearly unapproved; may be persisted before consensus |
| Assumption / open item | Uncertainty, consequence, and useful next action |

Do not turn a draft, meeting capture, recommendation, or output document into
consensus by writing it down. Seek explicit consent for meaningful new choices,
ambiguous authority, conflicts, or material scope/risk changes. A clear authorized
user decision within approved scope is sufficient: record and apply it without
asking the same question again. Moving between lenses needs no approval.

Compare meaningful alternatives inline by default. Separate option files only
when alternatives need independent detailed treatment or the user requests them.
Do not manufacture options or forbid a grounded recommendation before approval.

## Workspace and Document Policy

Default sibling roots are **optional and lazy-created**:

| Root | Responsibility |
|---|---|
| `design/` | Current design authority, shared models/contracts, `plan.md`, optional important decisions |
| `meeting/` | Dated meeting inputs and outcomes, not design authority |
| `external/` | References to outside-owned documents, contracts, and threads |
| `output/` | Requested purpose-specific review/decision support or explanation/handoff views |
| `issues/` | Optional persistent local implementation handoff, delegated to `to-issues` |

Preserve established paths and filenames. Never automatically migrate an existing
numbered phase tree. Split by reader need, not a mandatory directory taxonomy.
A design-root `index.md` is useful for navigation; an index in every directory is
not required. Keep `plan.md` for resume, `decisions.md` only if useful, and do not
create a default `log.md`. Preserve existing histories rather than deleting them.
See [structure rules](references/structure-rules.md) for resume and change handling.

### Minimal OKF on All Managed Markdown

Apply current `open-knowledge-format` guidance to authored/managed Markdown in
**all five roots**, including output documents and `internal-source-map.md`.
Read that skill and its authoring checklist before creating templates or a new
artifact set; consult its relevant guidance for substantial metadata changes.

- Every non-reserved Markdown document starts with parseable YAML frontmatter
  and a nonempty `type`. Include `title` and `description` by default.
- Mark unreviewed agent-authored content `status: draft`. Keep approval and
  implementation state honest in the body; metadata alone is not consensus.
- `index.md` and `log.md` are reserved, with no concept frontmatter. Only a
  bundle-root index may optionally declare `okf_version: "0.2"` alone.
- Use conditional `sources`, `generated`, and `verified` truthfully under the
  current OKF contracts; no invented actors, checks, dates, or provenance.
- Shareable metadata must be disclosure-safe just like the body. Keep private
  provenance in the internal map, not the shareable document's frontmatter.
- Preserve unknown metadata and valid legacy v0.1 content; do not emit new
  legacy `timestamp` / `# Citations` or migrate existing fields without request.
  Read OKF migration guidance before editing legacy metadata.
- Do not alter raw transcripts or source snapshots merely to retrofit OKF.
  Wrap/link them through a managed note when needed.

Metadata does not require extra logs, directories, indexes, or lifecycle files.
OKF owns format details; do not reproduce its specification here.

### Writing and Explanation Ownership

Use `document-writer` for both internal documents and output: full guidance for
new/substantial work, localized guidance for small edits. Generated project docs
default to Korean unless requested otherwise; keep technical identifiers exact.
Use `visual-first-explanation` for substantive design discussion without copying
its style rules here. Illustrations are nonbinding unless actually agreed.
Document Writer owns prose quality and may use Humanizer as needed; there is no
mandatory additional whole-document Humanizer stage.

## Local Working Loop

1. **Restore/select:** Read existing `plan.md`, the selected agenda's current
   document, and relevant shared owners. For a new project use supplied context,
   ask only materially missing questions, and create only useful documents.
2. **Frame:** Identify the outcome, affected scope, current evidence, unknowns,
   and next useful lens. Clarify user-owned requirements rather than filling
   imagined goals, numeric targets, constraints, or a complete architecture.
3. **Investigate/discuss:** Bound research by its concrete question and risk.
   Inspect relevant code for existing systems. Distinguish facts, inference,
   source reports, and recommendations. No source quotas or textbook survey.
4. **Record:** Persist clearly labeled drafts when useful. Apply authorized
   decisions to the owning current design; preserve alternatives/rationale only
   where useful. Record important decisions using the rule below.
5. **Check once:** Compare changed meaning against the authorized input once:
   choice, why, scope, obligations, numbers, tradeoffs, and open items. Follow
   direct dependencies only while impact continues; include affected shared
   contracts, existing outputs, and existing issues. Check renamed/moved links.
6. **Checkpoint:** Update the short resume state at a meaningful boundary.
   State next action and unresolved implementation blockers, not a mandatory
   next approval. Stop at the selected outcome's useful depth.

For ordinary corrections, do not default to a full-tree review, verifier agent,
audit artifact, new research, or repeated approval. Broaden only for actual
contract changes, lossy summaries, structure changes, or substantial output work.
Keep outstanding affected content visibly unresolved; no transient stale ritual
for documents updated and checked in the same task.

### Important Decision Memory

Record a decision, **including the first**, when it involves costly/irreversible
choices, shared boundaries, data ownership, security/regulation, operations,
important contracts, delivery-sensitive reversal, or repeatedly contentious
tradeoffs. Capture decision + why + consequences + related documents, and what
it supersedes when relevant. Keep the analysis in one home; link rather than
duplicate option comparisons. A central catalog is optional, not a second full
record. No mandatory central + local + change-log triple.

Ordinary edits update current docs. Git history preserves edits but does not
replace rationale for an important decision. Do not erase existing history.

## Inputs, Outputs, and Handoff

### Meeting Inputs

Use optional `meeting/YYYY-MM-DD-topic.md` notes when retention helps. Preserve
source locator/context, distinguish reported vs verified facts, proposals vs real
authorized agreements, conflicts, and open items. Add applied scope/follow-up
only as needed. **Capture != adoption != implementation/verification.**

Meeting preparation may be an output brief; meeting results are inputs. A meeting
does not require a full file set, index, lifecycle ceremony, or decision-log row.
Apply clear authorized outcomes without redundant reapproval; ask about ambiguous
authority, conflicting contracts, or genuinely new choices.

### Outside-Owned Sources

Use `external/` for lightweight references, not bulk copies by default. Retain the
source owner and locator; classify one-off vs recurring input. Keep a last-seen
checkpoint only when needed to detect meaningful deltas. Deduplicate repeated
input; give one source one home and link elsewhere. Mirrors are not independent
corroboration. A justified snapshot must be labeled with its source/context and
must not usurp the outside owner's authority.

Recurring wording does not authorize automatic fetches, scheduled jobs, or a
platform-sync framework. Read/check sources only within the requested task and
available access; never claim unseen changes were checked.

### Requested Output Views

Read [the output guide](references/publication-guide.md) before authoring or
refreshing output. Support review/decision briefs (including labeled unconfirmed
proposals) as well as agreed explanation/handoff documents. Choose sources for
the purpose: discussion drafts can use meeting/external inputs with explicit
status; final sharing cannot present unresolved/stale content as agreed truth.

Output is a derived view, not design authority. Reconcile semantic feedback into
the owning design before adopting changed meaning in an agreed output; expression-
only edits stay local. Authoring files does not authorize sending/publishing them.

### Optional Implementation Issues

Selected-scope readiness does **not** automatically generate issues. When asked,
delegate outcome slicing, direct blockers, acceptance/verification, and ticket
authoring to `to-issues`, retaining its proposal/materialization gates. A partial
scope may proceed without a complete architecture or all lens documents.

- For requested persistent handoff, pass `issues/` (or the user's chosen path)
  as the explicit destination override to `to-issues`' `.scratch/` default; do not
  modify that skill. Without persistent handoff, preserve its normal workflow.
- Tickets need self-contained minimum context and deep links to owning designs,
  not copied design documents. Apply minimal OKF to local managed Markdown.
- Distinguish local specification, tracker last-observed status, and evidenced
  implementation verification. Do not build routine tracker-sync bookkeeping.
- An authorized design meaning change triggers checks of **affected existing
  tickets only**. Report impacts; do not silently rewrite in-progress contracts,
  mutate remote tickets, or infer remote publishing permission.

## References

- [Design lenses and selected-scope readiness](references/phase-guide.md)
- [Workspace, resume, and proportional change handling](references/structure-rules.md)
- [Adaptable templates](references/templates.md)
- [Output purposes, provenance, and sharing boundaries](references/publication-guide.md)
