# Design Lens Guide

Use these lenses to answer the selected agenda's questions. They are optional,
combinable, and revisitable, not stages to finish in order. The filename is
retained for existing links. No lens requires its own directory or file set.

## 1. Problem

- Establish the user-owned outcome, affected people/systems, priorities, scope,
  and real constraints. Ask focused questions; do not invent numeric targets.
- For existing systems, capture relevant current behavior and pain points with
  evidence, clearly separate from the desired target.
- A short framing section may suffice. Split goals, constraints, or as-is analysis
  only when readers need independent documents.
- Revisit when requirements change. A new requirement may affect one agenda, not
  automatically every part of the design.

## 2. Research

- Start from a concrete question: what uncertainty prevents the next useful
  choice or implementation handoff? State scope, evidence needed, and stopping
  condition. Quick/Standard/Deep labels are optional shorthand, not quotas.
- Inspect relevant code, tests, contracts, configuration, and operational evidence
  when the existing system matters. A repository path is evidence only for what
  was actually inspected, not proof of runtime behavior.
- Prefer authoritative sources appropriate to the claim; corroborate uncertain
  high-consequence claims where useful. No universal source-count requirement.
- Record enough context, mechanisms, risks, and tradeoffs to answer the question,
  not a textbook survey. Keep uncertainty explicit and avoid invented benchmarks.
- Grounded recommendations are allowed, clearly unapproved. Research findings
  cannot select architecture on the user's behalf.
- Follow current OKF provenance rules for structured sources and attribution.
  One outside source has one reference home; mirrors do not add corroboration.

A separate research plan or synthesis is useful only for substantial independent
questions. A narrow check can be recorded directly in its owning agenda.

## 3. Concept

- Explain what the system is and is not, its external operating model, key
  scenarios, lifecycle, and relevant design principles.
- For evolution/migration, clarify coexistence, replacement, or gradual rollout
  relative to the observed system. Do not label planned migration implemented.
- Compare meaningful directions if they exist. An inline comparison and a
  grounded recommendation usually suffice; do not fabricate alternatives.
- Useful principles change a real decision. Do not require a quota of generic
  principles or a complete concept document before investigating a risky contract.

## 4. High-Level Design

Make the selected scope coherent at the system/domain level:

| Concern | Capture enough to establish |
|---|---|
| Major flows | Request/event/data paths, responsibilities, trust/failure boundaries |
| Domain model | Major concepts/entities, identifiers where material, relationships and lifecycle |
| Ownership | Which component/source owns data, state transitions, and shared definitions |
| Invariants | Rules that must hold across operations or boundaries; where enforced |
| Shared naming | Common concepts, components, events, and interface names, with stable meanings |
| Shared contracts | Observable semantics, compatibility expectations, and relevant dependencies |

Use one authoritative home for common models, vocabulary, and contracts. Link
from local designs rather than repeating mutable definitions. An event's meaning
and ownership may need agreement now even if its exact serialization does not.

Modeling is more than boxes and arrows, but does not mean specifying every field,
method, or internal class. Include exact details only when they carry a shared
invariant, interoperability constraint, security boundary, or implementation
blocker. Do not reject a useful cross-lens detail merely because of its level.

An overview and domain model can be sections in one document. Separate documents
or decision areas only when they improve navigation and independent maintenance.
Do not require all system-level choices to close before one scope progresses.

## 5. Issue-Ready Elaboration

Ask: **Can this selected outcome become implementable issues without guessing
material requirements or shared contracts?** Readiness belongs to an outcome or
slice, not necessarily a whole component or project.

| Readiness concern | Sufficient answer |
|---|---|
| Outcome and scope | Observable result, responsibility/boundary, explicit exclusions |
| Behavior/state | Main scenario and material failure paths, ownership, relevant invariants |
| Contracts | Inputs/outputs, shared semantics, compatibility and error policy where material |
| Dependencies | Actual prerequisites and their owners/status where known, not every adjacent topic |
| Verification | How the result and important risks can be checked, with available evidence paths |
| Unknowns | Which unknown blocks starting, which can be decided in implementation, which gates activation |

### Classify Unknowns Instead of Blocking Everything

- **Implementation-start blocker:** A missing authorization rule, data owner, or
  contract meaning that would force an implementer to invent a material decision.
  Resolve it, bound the scope to exclude it, or make the requested issue a research
  outcome. Explain why it blocks the affected slice.
- **Implementation-time choice:** Private method names, equivalent algorithms,
  local factoring, or minor fields that do not change the agreed contract. Leave
  these to implementation; exact private signatures are not a readiness ritual.
- **Activation/release condition:** A production credential, rollout approval,
  operational training, or migration window needed before enabling the result.
  Record the dependency without blocking safe development that can proceed now.
  If a condition really prevents safe implementation too, explain that separately.

For example, a delivery worker can be ready for implementation with a stable
delivery contract and testable retry policy while the audit UI remains under
design. Production activation may still depend on a rollout review. A changed
shared retry contract affects dependent designs/tickets; an unrelated UI open
question does not.

### Stop and Hand Off Locally

- Do not require every sibling component to receive a first pass or every lens
  to have a document. Deepen the user-selected or risky scope directly.
- State ready scope, unresolved blockers, and deliberate implementation-time
  freedom. Do not claim all open questions are settled or implementation is done.
- Issue creation is optional and requested, not an automatic completion step.
  `to-issues` owns outcome slicing, direct blockers, acceptance, and materialization
  gates. It can also work on partial scope without a completed design tree.
- Revisit any lens when evidence or requirements change. Check only the changed
  meaning and affected dependencies; no mandatory phase-transition ceremonies.
