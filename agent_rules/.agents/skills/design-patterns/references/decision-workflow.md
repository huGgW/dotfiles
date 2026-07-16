# Evidence-Driven Pattern Decisions

Read this guide for non-trivial selection, design, review, or refactoring. The purpose is to turn pattern choice into a falsifiable design decision rather than pattern matching by vocabulary.

## 1. Frame the Decision

Capture only facts that can change the outcome.

| Field | Question | Strong evidence |
| --- | --- | --- |
| Problem | What is costly, coupled, duplicated, or unsafe now? | Repeated edits, defects, hard-to-isolate tests, unstable call sites |
| Variation | What differs, who chooses it, and when? | Two implementations, runtime policy, state-dependent behavior |
| Boundary | What cannot be changed or must remain stable? | Third-party API, public contract, process or network boundary |
| Invariant | What must always be true? | Legal transitions, compatible product family, ordered construction |
| Frequency | How often does this change or execute? | Change history, roadmap commitment, measured object count |
| Constraints | Which costs matter most? | Compatibility, latency, memory, team familiarity, deadline |
| Baseline | What is the direct solution? | Function, branch, constructor, data map, standard-library primitive |

Do not accept “cleaner,” “more flexible,” or “might need it later” as evidence without naming the current coupling or credible variation.

## 2. Distinguish Variation Types

Pattern selection becomes easier when the variation has an owner and a time.

| Variation | Selection owner and time | Likely direction |
| --- | --- | --- |
| Construction | Caller, configuration, subclass, or environment at creation time | Creation function, Factory Method, Abstract Factory, Builder, Prototype |
| Algorithm or policy | Caller or configuration before an operation | Function, Strategy, Template Method |
| Internal lifecycle state | Object through legal transitions over time | Explicit transition table, State |
| Request identity | Producer before delayed or indirect execution | Function/closure, Command |
| Interface shape | Integration boundary at compile or wiring time | Direct change, Adapter, Facade |
| Responsibility layers | Composition or wiring time | Function composition, Decorator, Proxy |
| Subscription | Runtime publishers and subscribers | Callback, Observer, Mediator |
| Structure and traversal | Collection owner and operation time | Native iteration, Composite, Iterator, Visitor |

Avoid treating “behavior changes” as a single force. Strategy, State, Command, and Observer all change behavior but assign control and time differently.

## 3. Pattern-Needed Gate

Score the decision qualitatively; do not turn it into a mechanical point system.

### Present pressure

- Identify a current defect, repeated change, coupling hotspot, objective boundary, or invariant.
- Locate it in code, tests, incidents, or a committed near-term requirement.
- If there is only aesthetic discomfort, improve names or local structure first.

### Simpler alternatives exhausted

Test the baseline mentally or in a small refactor:

- A named function or closure.
- A direct conditional or table lookup.
- A constructor or creation function.
- Plain composition or delegation.
- A standard-library iterator, event primitive, proxy, cache, or data type.
- A language feature such as lambdas, sum types, pattern matching, records, protocols, or traits.

The baseline does not need to be shortest by line count. It must expose control flow and ownership with the fewest concepts.

### Credible variation

A second implementation is strong evidence, but not the only evidence. One implementation may justify a seam when:

- The code integrates an external API that cannot be changed.
- A public extension contract is a product requirement.
- Access, remote transport, caching, or lifecycle must be controlled at a boundary.
- State invariants must prevent illegal transitions.
- Tests require an external side effect to be isolated and the boundary is already real.

Do not count speculative plugins, hypothetical vendors, or vague reuse as credible variation.

### Positive trade-off

Estimate both sides:

| Benefit | Cost |
| --- | --- |
| One localized change point | More types and files |
| Stable caller contract | Indirect control flow |
| Enforced invariant | More setup and tests |
| Independent evolution | Wiring and configuration |
| Replaceable policy | Debugging across boundaries |

Choose a pattern only when the concrete benefit is larger in this repository, not in a textbook example.

### Removal test

Imagine inlining or deleting the abstraction. If all current requirements, boundaries, and tests remain clear and correct, remove or avoid it. A pattern should earn its continued existence.

## 4. Build a Bounded Candidate Set

Use no more than three candidates:

1. The direct baseline.
2. The smallest pattern whose intent matches the dominant force.
3. One close alternative that differs in ownership, timing, or boundary.

Do not list unrelated patterns to appear thorough. If one design clearly dominates, compare it only with the baseline.

## 5. Compare Candidates

Use this matrix in reasoning; include only decisive rows in the answer.

| Criterion | Questions |
| --- | --- |
| Present fit | Which current pain or invariant does it directly solve? |
| Control owner | Who selects behavior, sends requests, or changes state? |
| Change timing | Compile time, wiring time, runtime, or lifecycle transition? |
| Concept count | How many new contracts, types, factories, or configuration paths appear? |
| Change isolation | Does the next evidenced variation stay in one place? |
| Testability | Can behavior and failure paths be tested without duplicating setup? |
| Observability | Can a developer trace control flow and diagnose failures? |
| Compatibility | Does it preserve public API and repository conventions? |
| Reversibility | Can it be inlined or replaced without a migration project? |
| Team cost | Is the pattern understood and consistently implemented here? |

Reject a candidate with a specific disqualifying force. Examples: “State is rejected because transitions are selected by the caller and there is no lifecycle,” or “Adapter is rejected because both interfaces are owned and can be aligned directly.”

## 6. Handle Ambiguity

Ask one concise question only when missing information can reverse the decision, such as:

- Whether an external interface is modifiable.
- Whether behavior changes at runtime or only during wiring.
- Whether transition history or undo is required.
- Whether a public extension point is committed.

Inspect the repository instead when code, tests, history, or configuration can answer. If two choices have nearly identical consequences, choose the more reversible direct option and state the assumption.

## 7. Apply the Design

### New design

- Start with the public behavior and invariant.
- Introduce the narrowest seam around the observed variation.
- Keep construction and wiring explicit.
- Prefer a consumer-owned contract when a real boundary needs an interface.
- Avoid a registry, reflection, dependency-injection container, or event bus unless it solves an independent present requirement.

### Existing pattern review

Classify the outcome:

| Outcome | Evidence |
| --- | --- |
| Retain | It isolates a current variation or enforces a boundary/invariant. |
| Shrink | Its intent is valid but the hierarchy or configuration is larger than required. |
| Replace | A different ownership model or language feature fits the actual force. |
| Remove | Inlining preserves requirements and makes control flow clearer. |

Review behavior, not textbook completeness. A closure can be a complete Strategy; a native iterator can fully satisfy Iterator intent; an adapter function can be sufficient at a small boundary.

### Refactoring sequence

1. Add or identify characterization tests for observable behavior.
2. Isolate one variation or boundary without changing behavior.
3. Move one caller or branch at a time.
4. Delete superseded paths immediately.
5. Run focused checks after each coherent step.
6. Stop when the current force is handled; do not build the imagined next layer.

## 8. Validate the Outcome

Verify more than compilation:

- Existing behavior and public contracts remain intact.
- Illegal states or incompatible combinations are prevented when that justified the pattern.
- The known alternative can be added or changed locally.
- Failure, cancellation, ordering, and ownership remain explicit where relevant.
- The design does not require duplicated mocks or elaborate fixture wiring.
- The direct path remains readable for the common case.

If the abstraction increases the number of places required for the next known change, reconsider it.

## 9. Record a Revisit Condition

Make future action evidence-based.

Good revisit conditions:

- “Introduce Strategy when a second runtime-selected pricing policy ships.”
- “Replace the callback with Observer when independent subscribers need separate lifecycles.”
- “Split the facade when callers need materially different subsystem capabilities.”
- “Remove this adapter when the legacy provider is retired.”

Poor revisit conditions:

- “When the system grows.”
- “If we need more flexibility.”
- “For future scalability.”

## Compact Decision Record

```markdown
## Decision
[Direct design or named pattern]

## Evidence and Forces
- Current pain or boundary:
- Required variation and owner:
- Constraints or invariants:

## Direct Baseline
[Simplest viable implementation and why it wins or loses]

## Selected Design
[Minimum structure and why it fits now]

## Rejected Alternative
[Closest candidate and decisive mismatch]

## Costs and Revisit Condition
- Added cost:
- Validation:
- Revisit or removal trigger:
```
