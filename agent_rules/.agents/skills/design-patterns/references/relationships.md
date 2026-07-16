# Pattern Relationships and Distinctions

Read this guide when candidates share a similar shape or are commonly confused. Decide by intent, control owner, and change timing rather than by class diagrams.

## Creation Spectrum

| Design | Use when | Avoid confusing it with |
| --- | --- | --- |
| Constructor | One concrete type is created directly | A named constructor is not automatically a factory pattern |
| Creation function or static method | Construction needs a name, validation, caching, or a selected concrete result | It does not require creator inheritance |
| Simple factory | One function explicitly selects among products | It is not the GoF Factory Method unless creation is polymorphic through creators |
| Factory Method | A creator workflow delegates one product creation step to variants | It does not create a whole compatible family by itself |
| Abstract Factory | A family of related products must switch together | It is not staged assembly |
| Builder | One product is assembled in ordered or validated steps | It does not select a product family |
| Prototype | Runtime-configured instances are cloned | It does not centralize family compatibility |

Factory Method often starts as a creation function and may support Abstract Factory implementations. Builder can receive components from a factory, but the decisions remain separate: family selection versus assembly.

## Factory Method vs Builder vs Prototype

| Question | Factory Method | Builder | Prototype |
| --- | --- | --- | --- |
| Primary problem | Which concrete product is created by a creator? | How is a complex product assembled? | How is an existing configured object copied? |
| Source of variation | Creator implementation | Construction steps or representation | Runtime exemplar |
| Main risk | Creator subclass growth | Ceremonial setters and invalid partial state | Copy depth, identity, and shared mutable state |

## Adapter vs Facade vs Decorator vs Proxy

All can wrap another object, so structure alone is insufficient.

| Pattern | Intent | Client-visible contract | Typical ownership |
| --- | --- | --- | --- |
| Adapter | Translate an incompatible interface or representation | Usually the client's expected contract | Integration boundary |
| Facade | Offer a smaller coherent entry point to a subsystem | New simplified contract | Subsystem boundary |
| Decorator | Add composable behavior while preserving substitutability | Same core contract | Composition or wiring |
| Proxy | Control access, location, lifecycle, or loading | Usually the same contract | Infrastructure or boundary policy |

Use a direct wrapper function if object identity and substitutability do not matter. A wrapper may combine intents, but keep policy names explicit rather than calling every wrapper an adapter.

## Bridge vs Adapter

- Bridge is designed before or during growth so two dimensions can vary independently through composition.
- Adapter is introduced after independently designed interfaces do not match.
- Bridge needs evidence for both axes. Adapter needs evidence for the mismatch and an unmodifiable or independent side.

Do not introduce Bridge for one abstraction and one implementation merely to avoid a conditional.

## Composite, Iterator, and Visitor

These patterns can cooperate without replacing one another:

- Composite represents part-whole structures through a uniform contract.
- Iterator controls traversal without exposing representation.
- Visitor adds operations across a stable element hierarchy using type-specific dispatch.

Prefer native iteration when traversal is ordinary. Prefer methods or functions when the type set changes more often than operations; Visitor makes adding element types expensive.

## Strategy vs State

| Question | Strategy | State |
| --- | --- | --- |
| Who chooses? | Caller, configuration, or wiring | The context through lifecycle transitions |
| What varies? | Algorithm or policy for the same job | Behavior allowed in the current state |
| Do variants know transitions? | Usually no | Often yes, directly or through a transition policy |
| Typical substitute | Function, closure, direct branch | Enum plus explicit transition table |

If the client passes a different policy for each call, choose Strategy. If legal behavior depends on history and transitions, consider State.

## Strategy vs Template Method

- Strategy uses composition and can change at runtime.
- Template Method fixes an algorithm skeleton in a base type and varies selected steps through inheritance.
- Prefer Strategy or functions when inheritance is not already natural in the language or codebase.
- Prefer Template Method only when the invariant skeleton is stable and subclasses are a deliberate extension model.

## Strategy vs Command

- Strategy answers “how should this operation be performed?”
- Command answers “which request should be represented and executed?”
- Command becomes valuable for queues, retries, audit, scheduling, macro composition, or undo.
- A closure may be a sufficient Command when metadata, serialization, and undo are unnecessary.

## State vs Command

State owns lifecycle-dependent behavior. Command represents an action. A state may validate or execute commands, but using command classes does not model legal transitions by itself.

## Observer vs Mediator vs Chain of Responsibility

| Pattern | Communication model | Sender knowledge | Completion semantics |
| --- | --- | --- | --- |
| Observer | Publish to dynamic subscribers | Knows an event contract, not receivers | Usually fan-out; ordering and failure policy must be defined |
| Mediator | Coordinate peer interactions centrally | Peers know the mediator | Mediator decides the collaboration |
| Chain of Responsibility | Pass a request through ordered handlers | Sender knows the chain entry | A handler may stop, transform, or continue |

Use a callback for one fixed receiver. Use explicit orchestration when the collaboration is stable and readable without a mediator.

## Chain of Responsibility vs Decorator

Both can form linked wrappers:

- Chain handlers may choose whether the request continues and need not share cumulative behavior.
- Decorators preserve a common component contract and usually accumulate behavior around delegation.
- Middleware may act like either; decide from stop/continue semantics and responsibility ownership.

## Command and Memento

- Command can record intent and optionally inverse behavior.
- Memento captures opaque state for restoration without exposing internals.
- Combine them when undo requires state snapshots that commands cannot safely reconstruct.
- Avoid full snapshots when an inverse operation is reliable and cheaper; avoid inverse commands when external side effects are not reversible.

## Facade and Mediator

Both centralize interaction, but Facade is a one-way simplified entry point over a subsystem, while Mediator coordinates peers that would otherwise reference one another. A facade should not become a domain workflow god object.

## Prototype and Memento

Both may copy state. Prototype creates another usable object; Memento stores restoration state under encapsulation. Copying an object is not automatically undo, and a snapshot is not necessarily a valid independent instance.

## Composite and Decorator

Both share a component contract. Composite aggregates children as part-whole structure; Decorator wraps one component to add responsibility. They can coexist, but keep traversal, ownership, and mutation rules explicit.

## Selection Heuristic

When two patterns remain plausible, ask in order:

1. What is the primary intent?
2. Who owns the decision or transition?
3. When can the choice change?
4. Must the contract stay identical, be translated, or be simplified?
5. Is the variation open, closed, ordered, staged, or stateful?

If these answers do not reveal a meaningful distinction, use the direct baseline rather than layering patterns.
