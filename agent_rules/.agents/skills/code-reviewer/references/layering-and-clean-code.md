# Layering and Clean Code

Use these checks within the applicable review lenses and supplied subject. The goal is clear ownership and reliable change, not adherence to a preferred layer diagram. Apply the main skill's evidence, severity, read-only, and reporting contracts unchanged.

## Establish roles and ownership

Trace changed operations through actual callers, collaborators, and contracts. Identify the owner of each invariant or policy from active approved decisions, explicit project rules, and comparable current implementations in the main skill's convention evidence order. Class names ending in `Repository`, `DAO`, or `Service` do not establish architectural roles by themselves.

Respect module boundaries and approved architecture. Distinguish concrete application dependencies from dependency inversion: a domain-owned repository interface referring to domain types is not an application-layer dependency merely because an infrastructure implementation implements it. Read only context needed to evaluate the subject, not the entire repository.

## Persistence and business policy

Look for pricing, discounts, eligibility, or approval decisions placed in a DAO/repository contrary to the established domain policy, object, or application owner. Also check use-case orchestration such as payment, notification, or external-service calls inside persistence operations. A repository invoking an application service can reverse the established dependency direction; trace the concrete path and boundary before reporting it. Show whether rules duplicated across repository callers now produce divergent behavior or require coordinated edits.

Do not treat domain-specific SQL or conditional writes as intrinsically misplaced. Conditional inventory decrement, optimistic version updates, locks, constraints, and atomic operations often belong at persistence boundaries to preserve integrity. Policy may legitimately be enforced through SQL for atomicity or performance while retaining a clear policy owner and contract. Evaluate ownership and resulting behavior, not storage location alone.

Recommend correction at the established owner, not a universal transfer of every condition to a service. Preserve atomicity and concurrency guarantees: moving an atomic predicate into an unlocked check-then-write sequence is not an acceptable simplification. Retain approved transactions, error contracts, authorization, and resource cleanup. Do not create a new DTO, service, or interface merely to relocate a few lines.

Trust persistence reads for what persistence already guarantees. Values loaded from a DAO/repository within enforced schema or persistence constraints (NOT NULL, CHECK, enum, foreign key, atomic conditional write) are assumed valid for those conditions; do not require callers to revalidate the same condition without a named bypass such as a nullable legacy column or an older writer. Keep computed-result and transition checks at the state owner.

## Service collaborations

Service-to-service calls are not blanket violations. Trace the dependency and execution graph, including relevant runtime wiring, to distinguish valid acyclic collaboration or an explicit orchestrator from:

- A genuine dependency or execution cycle with a concrete initialization, recursion, or ownership consequence.
- Reuse of an entry-point use case that unintentionally repeats authorization, validation, notifications, payments, or other side effects.
- Unclear transaction propagation, retry, or cancellation contracts that permit partial commits or duplicate effects on an evidenced failure path.
- An invariant spread across collaborators such that callers must know undocumented ordering to maintain it.
- Dependence on an oversized use-case collaborator for a tiny shared policy when an existing suitable policy owner can serve that need without new coupling.

Verify transaction boundaries, commit points, retry ownership, cancellation propagation, and failure outcomes where relevant. Do not infer a cycle from two class names or presume nested calls share a transaction. A defined acyclic orchestration contract can be correct without another orchestration layer. Recommend the smallest change that restores the established boundary and behavior; do not mandate a new service or interface for every collaboration or refactor for hypothetical growth.

## Cohesion and comprehensibility

Report clean-code concerns only with material comprehension, change, or reliability impact. Trace responsibilities and reasons to change, misleading names (especially query-like methods that mutate), deeply nested branches, hidden mutable state, ambiguous flag semantics, duplicated policy, and caller ordering required to protect invariants. Show the actual misunderstanding, divergent change, or failure path that the structure enables.

Check both needless indirection and overfragmentation: a flow split into tiny wrappers can hide sequencing and ownership just as a method with unrelated responsibilities can. Preserve cohesive multi-phase operations when their intention and state guarantees are clear. Do not score by lines, function count, or fixed thresholds; do not require tiny methods, ban flags, demand comments, or split coherent flows solely for aesthetics.

Preserve meaningful failure handling, transactions, authorization, resource cleanup, safety checks, and approved structures. A repair must not multiply DTOs, services, interfaces, or pass-through helpers without a demonstrated responsibility. Prefer the established suitable owner and a direct, intention-revealing contract.

## Compound Boolean decisions

Inspect excessive Boolean chaining, mixed `&&`/`||`, and nested negation for obscured distinct policies, exceptions, or state checks. Four or more condition terms are an attention trigger, not a numeric prohibition. Identify the specific rule a maintainer could misunderstand or change inconsistently, supported by contracts, callers, tests, or change history. Operator count, line length or wrapping alone is not a finding; clear homogeneous enum comparisons and simple ranges need no decomposition. Apply the main skill's finding threshold and binding-rule versus heuristic distinction; severity follows actual impact, not expression shape.

Recommend the smallest meaning-oriented restructuring: local predicates that reveal distinct decisions, or a domain helper when it owns a meaningful responsibility; reuse an existing suitable owner when available. Moving the entire chain into an opaque helper does not clarify its rules. Avoid atomizing every comparison, eager arrays of evaluated conditions, or new frameworks or classes merely to shorten an expression.

Any suggested decomposition must preserve observable evaluation semantics: short-circuit skipping, evaluation order and count, and laziness are mandatory for effects, potentially throwing expressions or getters, and guarded access; preserve side effects, exception timing, and null guards. Naming a predicate does not justify computing it earlier: keep guarded work lazy at its original decision point. Verified pure, total, safe predicates over immutable primitive data may be grouped eagerly when no observable behavior changes. A readable decomposition that changes observable execution properties is a correctness concern, not a maintainability improvement. Recommendations remain read-only and within the applicable lens and scope, not a new universal checklist.

## Evidence and recommendation

For each candidate finding:

1. Name the changed operation, its actual role, and the established policy or invariant owner.
2. Cite relevant callers and the dependency path or control/data flow that demonstrates the issue.
3. Trace transaction and failure execution where the consequence depends on commit, retry, cancellation, or side effects.
4. State the concrete consequence and why it is materially relevant to the supplied subject.
5. Describe the smallest corrective behavior and the contracts and safeguards it must preserve, without implementing it or overturning an approved decision.

If roles, wiring, contracts, or failure evidence are unavailable, record the gap under unverified areas and use `INCOMPLETE` when it prevents a materially reliable scoped review. Do not invent a layering or clean-code defect to fill lens coverage.
