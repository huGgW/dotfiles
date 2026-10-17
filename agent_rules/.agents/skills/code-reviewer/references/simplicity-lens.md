# Simplicity Lens

Use this lens to identify unnecessary complexity without rewarding deletion for its own sake. The goal is the smallest design that preserves every established requirement and load-bearing safeguard.

## Evidence standard

A simplicity finding needs all of the following:

- A concrete structure in the supplied subject that adds indirection, duplication, policy, or lifecycle cost.
- Evidence that a smaller established mechanism satisfies the same requirements.
- A trace of affected callers, contracts, tests, configuration, or migration state sufficient to show that removal or consolidation is safe.
- A concrete recommendation and the behavior that must remain true afterward.

Do not score simplicity by changed lines, total lines, number of files, or number of abstractions. A shorter patch can be less understandable or less safe, and a necessary boundary can add code while reducing system complexity.

## Categories

### Delete

Look for dead branches, duplicate validation, obsolete compatibility paths, unreachable adapters, redundant state, or pass-through layers with no remaining contract.

Duplicate validation means a second check for the same condition already enforced at its verified owner: the untrusted entry, a checked constructor/factory plus entry validation and tests, or a DAO/schema guarantee. DAO reads within schema constraints are trusted for those conditions. Report it when no named bypass path (second caller, queue, older producer, nullable schema, fallible upstream) is evidenced. Do not report defense-in-depth checks that own distinct threats such as authorization, untrusted parsing, or money/state integrity.

Recommend deletion only after checking references, runtime registration, reflection or dynamic loading, generated-code relationships, configuration, public API use, migration state, and tests as relevant. Absence from a text search alone is not proof that code is dead.

### Stdlib (standard library)

Look for custom parsing, collection, concurrency, retry, path, time, encoding, cryptographic, or identifier helpers already provided safely by the language standard library.

Recommend replacement only when the standard facility matches required semantics, platform support, error behavior, security properties, and compatibility constraints. Do not replace a policy-owning wrapper merely because its implementation currently delegates to the standard library.

### Native capability

Look for custom behavior already owned by the framework, runtime, browser, operating system, database, protocol, or build system in use.

Prefer the native mechanism when it is supported by project versions and preserves observability, accessibility, lifecycle, portability, and failure semantics. A native feature is not simpler if adopting it creates a parallel migration or obscures ownership.

### YAGNI

Look for speculative extension points, unused configurability, premature plugin systems, abstract factories with one fixed implementation, generic layers built for hypothetical consumers, and fallback paths for unsupported scenarios.

Distinguish speculation from an approved near-term requirement, public extension contract, staged migration, test seam, or operational contingency. Lack of a second implementation today does not by itself make an interface unnecessary.

### Shrink

Look for a coherent owner that can absorb scattered logic, repeated transformations that can share an established implementation, excessive state transitions, wide APIs, deep call chains, or abstractions exposing more capability than callers need.

Shrink at the correct owner. Do not move cross-cutting coordination into a domain object, combine independent trust boundaries, collapse transaction phases, or hide meaningful failure handling just to reduce visible structure.

### DTOs and mapping chains

Trace each changed DTO or intermediate type from producer through mappings to consumers. Identify its domain or public contract, invariants, clarity or type-safety role, validation/serialization policy, security exposure, and ownership/version boundary. Look for duplicate same-contract types, unchanged `A -> B -> C` field copies, and new types that duplicate an existing suitable type without owning a distinct responsibility.

Show the cost: fields that must be changed in several types and mappings, parallel validation or serialization policy, or extension scaffolding for hypothetical consumers. Compare with reuse of an existing suitable type or removal of an unnecessary intermediate mapping, not automatically with direct exposure of a persistence entity.

Identical shapes, abstraction counts, and single-use types are clues, not proof. Preserve distinct change reasons, API independence, security boundaries, and meaningful named-type clarity or safety even when current fields match. An approved DTO boundary remains binding; a repeated habit is only convention evidence. If consolidation would contradict an active decision, do not recommend it or silently reopen that architecture.

### Established solutions and conventions

Use the architecture/maintainability lens's evidence order to establish conventions. Compare relevant existing helpers, types, and project patterns against the changed solution's actual requirements. A finding needs specific rules or comparable current examples, concrete duplicated behavior or maintenance impact, and evidence that reuse preserves required semantics without new coupling.

Allow a justified deviation when the established implementation is unsafe, obsolete, contract-incompatible, or otherwise unsuitable. Do not demand conformity for its own sake or treat missing convention evidence as proof that the new approach is wrong. Keep inspection limited to context needed for the supplied subject.

## Load-bearing complexity

Preserve complexity that carries a demonstrated requirement. Common examples include:

- Security boundaries: authorization, validation before parsing, output encoding, secret isolation, least privilege, and defense in depth. Preserve the check at its owner; a second same-condition check elsewhere needs its own named threat or bypass path.
- Correctness and data integrity: transactions, idempotency, atomic replacement, concurrency control, durability, cleanup, and explicit state transitions. Keep state-transition checks at the state owner without repeating already-guaranteed input facts.
- Compatibility: public APIs, protocol guarantees, supported runtime versions, consumer contracts, and deprecation windows.
- Accessibility: semantic structure, keyboard and focus behavior, announcements, contrast support, and reduced-motion behavior.
- Migration: expand-migrate-contract phases, dual reads or writes, backfills, adoption checks, rollback windows, and separately approved cleanup.
- Operations: timeouts, cancellation, retries with bounds, telemetry, rate limits, circuit breaking, recovery, and rollback mechanisms.
- Ownership: module boundaries, dependency direction, policy owners, test seams, and independently deployed components.
- Approved architecture: explicit decisions and constraints supplied by the caller or evidenced by authoritative repository documentation.

Do not label these structures unnecessary because the happy path works without them. Challenge them only with evidence that the requirement has ended, moved to another established owner, or is fully preserved by the proposed smaller mechanism.

## Review method

1. Name the apparent complexity and the category it belongs to.
2. Identify the requirement or invariant the structure may own.
3. Trace callers, contracts, tests, configuration, deployment, and migration evidence relevant to that invariant.
4. Compare the current structure with the smallest established alternative.
5. Test the alternative against correctness, security, compatibility, accessibility, migration, operational, ownership, and approved-architecture constraints.
6. Report a finding only when the smaller alternative is demonstrably sufficient.
7. State what must be preserved in the recommendation.

If evidence is insufficient, record the area as unverified rather than recommending deletion. If the complexity is load-bearing, do not create a positive finding merely to fill the simplicity lens; coverage may state that the safeguard was inspected and preserved.

## Provenance

This lens adapts the general idea of reviewing diffs for removable complexity
from Ponytail Review, using independent wording and this skill's capability-only
review contract. It does not copy Ponytail's mode, output, or scoring behavior.

- Source: https://github.com/DietrichGebert/ponytail/blob/main/skills/ponytail-review/SKILL.md
- License: https://github.com/DietrichGebert/ponytail/blob/main/LICENSE
