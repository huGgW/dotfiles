# Adaptable Document Templates

Use only sections that help the reader. These are shapes, not project facts or a
required file inventory. Combine small topics; split independently useful ones.
Fill from supplied/verified information or clearly labeled proposals. Unknown
goals, owners, targets, and decisions stay unknown, not invented to fill cells.

Consult current `open-knowledge-format` and its authoring checklist before adding
templates or a new artifact set. Every non-reserved managed Markdown document in
design, meeting, external, output, and issues has parseable YAML and a nonempty
`type`; default `title` and `description` help navigation. The examples use
`status: draft` for unreviewed agent content, not as a substitute for body-level
approval/implementation distinctions. Add conditional provenance/trust fields
only under current OKF rules with actual evidence. Do not copy invented actors,
dates, or verification. Preserve unknown metadata and existing valid legacy v0.1
fields without unrequested migration. Never retrofit raw source originals.

Template instructions are English; generated project prose defaults to Korean
under `document-writer` unless requested otherwise. Placeholder links below are
not claims that files already exist: use actual established paths when authoring.

## Short Resume Checkpoint — `plan.md`

Keep only live resume state, not history, roadmap, backlog, or execution tracking.
Link to detailed questions and authoritative contracts rather than copying them.

```markdown
---
type: Design Checkpoint
title: "{Project} Design Checkpoint"
description: "Current design agendas and next actions for resuming {Project}."
status: draft
---

# Design Checkpoint

## Current Focus
{Selected outcome/scope and already authorized work; unresolved choice only if any.}

## Live Agendas
| Agenda / scope | Design status | Owner, if known | Current doc / shared contracts | Open question | Next action |
|---|---|---|---|---|---|
| {Selected slice} | Investigating / Draft / Agreed / Issue-ready / Waiting | {Known owner or unknown} | {Actual links} | {Material question or none} | {Useful next step} |

## Resume Notes
{Only local context needed next time; link durable decisions instead of repeating why.}
```

## Current Design — Topic or Selected Outcome

Use this shape for problem, concept, architecture overview, operating model, or
issue-ready detail. Omit irrelevant sections; do not create one file per lens.

```markdown
---
type: Design
title: "{Topic} Design"
description: "Current design, scope, contracts, and unresolved items for {topic}."
status: draft
---

# {Topic}

## Outcome and Scope
{User-owned outcome, boundaries, real constraints, and exclusions.}

## Observed State
{Inspected evidence and scope/date context where meaningful; distinguish reports
from verified implementation. Do not imply the agreed target is already built.}

## Agreed Target
{Authorized choices, affected scope, and rationale or link to important decision.}

## Draft Proposals and Assumptions
{Unapproved recommendation, reasoning, uncertainty, and decision needed.}

## Behavior and Boundaries
{Main flow/scenarios and material failure paths. Use a useful visual or example.}

## Shared Model and Contracts
{Links to authoritative concepts, ownership, invariants, names, and interfaces.
Keep local responsibilities here without duplicating common mutable definitions.}

## Readiness for the Selected Outcome
- Implementation-start blockers: {Material missing decisions, or none known.}
- Implementation-time choices: {Deliberately delegated freedom.}
- Activation/release conditions: {Separate conditions for enabling the result.}
- Dependencies: {Actual prerequisites and known owners/status.}
- Verification: {Observable evidence path for outcome and important risks.}

## Open Items
| Question | Affected scope / consequence | Owner, if known | Next action |
|---|---|---|---|
```

## Shared Domain Model / Vocabulary

```markdown
---
type: Domain Model
title: "{Scope} Domain Model"
description: "Authoritative shared concepts, relationships, ownership, and invariants for {scope}."
status: draft
---

# {Scope} Domain Model

## Authority and Scope
{Who owns these definitions, what is agreed vs proposed, and applicable scope.}

## Concepts and Shared Names
| Concept / component / event / interface | Meaning | Authoritative owner | Related contract |
|---|---|---|---|

## Relationships and Lifecycle
{Material relationships, identifiers, cardinality/lifecycle when needed.}

## Invariants and Ownership
| Invariant | State/data owner | Enforcement boundary | Implication |
|---|---|---|---|

## Open Questions
{Only relevant unresolved items; not every field or method.}
```

## Focused Research / Outside Reference

Use `type: Research` for investigated analysis, `type: External Reference` for an
outside-owned source wrapper. Include actual `sources` under current OKF guidance
when deriving content; do not copy a fabricated URL to satisfy the shape.

```markdown
---
type: Research
title: "{Concrete Question}"
description: "Evidence and open uncertainty informing {specific design choice}."
status: draft
---

# {Concrete Question}

## Question and Bound
{Decision/outcome served, included/excluded scope, stopping condition.}

## Source Context
{Actual source owner/locator and relevant version/scope. For an external wrapper:
one-off or recurring; last-seen checkpoint only if needed for meaningful deltas.}

## Findings
{Facts with source attribution, reported behavior, inference, and uncertainty separated.}

## Tradeoffs and Recommendation
{Compact comparison if useful; grounded recommendation explicitly NOT approved.}

## Remaining Uncertainty / Next Action
{Only what matters to the selected scope. For recurring input, meaningful delta
and already-applied input can be noted without duplicate snapshots or sync machinery.}
```

## Important Decision — Local Section or Optional `decisions.md`

Use for significant decisions, including the first. Do not require a local record
plus central log plus change log. Inline comparisons are normally sufficient;
link independent detailed alternatives if they actually exist.

```markdown
---
type: Design Decision
title: "Decision: {Topic}"
description: "Important choice, rationale, and consequences for {scope}."
status: draft
---

# Decision: {Topic}

- Authority / status: {Actual authorized decision or clearly pending proposal.}
- Scope / context: {What this affects and why the choice matters.}
- Decision: {Chosen direction only if actually agreed.}
- Why: {Evidence, criteria, alternatives, and accepted tradeoff; link long analysis.}
- Consequences: {Constraints, risks, obligations, and delivery/reversal impact.}
- Related documents: {Actual owner/dependency links.}
- Supersedes: {Prior important decision, only when relevant.}
```

If `decisions.md` is a catalog, use `type: Decision Catalog` and a compact table of
decision, significance, and rationale-home link. Do not repeat the full rationale.

## Meeting Input — `meeting/YYYY-MM-DD-topic.md`

```markdown
---
type: Meeting Note
title: "{Topic} Meeting Results"
description: "Source-grounded meeting input and authorized outcomes for {topic}."
status: draft
---

# {Topic} Meeting Results

## Source and Context
{Meeting date/context, source locator, relevant participants/authority when known.}

## Input and Outcomes
| Item | Reported fact / verified fact / proposal / authorized agreement | Source / authority | Scope |
|---|---|---|---|

## Conflicts and Open Items
{Material ambiguity/conflicts and useful follow-up, if any.}

## Applied Scope
{Only when applied: affected owning designs and remaining follow-up.
Capture does not imply adoption, implementation, or verification.}
```

## Output and Internal Source Map

A review brief can have `type: Review Brief`; an agreed explanation can have
`type: Architecture Explanation`. Keep title/description/status and all optional
metadata safe for the intended audience. Organize the body with `document-writer`
for that purpose, not a mandatory internal template. Clearly label unconfirmed
proposals and unresolved conditions. Consult [the output guide](publication-guide.md).

Use this minimal map for an independently maintained/shared output. A one-off
private brief may instead retain brief inline provenance where appropriate.

```markdown
---
type: Source Map
title: "{Document} Internal Source Map"
description: "Private section-to-source mapping and content status for {document}."
status: draft
---

# Internal Source Map

> INTERNAL — exclude this file from sharing.

- Primary document: {Actual file.}
- Purpose / audience / status: {Review proposal or agreed explanation; known gaps.}
- Shareable files: {Primary file and actually used safe assets only.}

| Output section | Source / owner | Source content status | Relevant notes / unresolved check |
|---|---|---|---|
| {Section} | {Actual private design or external locator} | Observed / Agreed / Proposal / Reported | {Only necessary context} |
```

No universal hash/checkpoint inventory. Do not put private map contents into the
shareable document's body, metadata, or assets. Preserve existing maps on small edits.

## Optional Persistent Issues

Do not replace `to-issues`' ticket templates or gates here. Pass requested persistent
destination `issues/` (or the user's path) explicitly instead of its `.scratch/`
default. Request self-contained minimum context, outcome scope, direct blockers,
acceptance/verification, and deep design links, without design-document copies.
Use meaningful `type`, `title`, `description`, and honest draft metadata on local
managed Markdown. Keep local spec, tracker observation, and implementation
verification distinct; issue drafting does not authorize remote publication.

## Optional Reserved Navigation / Existing Update Log

An `index.md` has no concept frontmatter. Only a bundle-root index may optionally
declare `okf_version: "0.2"` alone. Use real links for useful one-level navigation,
not repeated rationale or required indexes everywhere:

```markdown
# {Scope}

{Purpose and navigation context.}

- [Current topic](topic.md) — {What the reader finds here.}
```

Do not create a default `log.md`. Preserve an existing one; it has no concept
frontmatter. If the project uses it, follow current OKF newest-first date groups:

```markdown
# Change Log

## 2026-10-19

- {Meaningful retained change and reference; no duplicate decision analysis.}
```

For genuinely outstanding affected content, place a concise update-needed note
after concept frontmatter or under a reserved file's title. State affected meaning
and next check. No mandatory log reference and no transient marker for work
updated and checked now. Remove existing notes only after their checks succeed.
