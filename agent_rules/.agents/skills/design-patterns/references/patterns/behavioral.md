# Behavioral Pattern Cards

Read this file when the dominant force concerns request flow, algorithms, state transitions, traversal, collaboration, notification, snapshots, or operations over a type structure. First identify who controls the behavior and when the choice changes.

## Start with Direct Behavior

Consider these baselines first:

- Direct call, branch, table lookup, or pure function.
- Function or closure passed as behavior.
- Explicit orchestration in an application service.
- Native iterator, generator, or collection operation.
- One callback for a fixed notification target.
- Enum or sum type plus an explicit transition function for a small closed state space.
- Explicit inverse operation or copy for simple undo.

## Quick Selection

| Force | Candidate | Decisive evidence |
| --- | --- | --- |
| Ordered handlers may process or pass a request | Chain of Responsibility | Chain composition and stop/continue semantics vary |
| Requests need identity, scheduling, logging, or undo | Command | The action must outlive or be decoupled from the call |
| Traversal must be separated from representation | Iterator | Multiple or stateful traversals exceed native iteration |
| Peer interactions require centralized coordination | Mediator | Many-to-many dependencies obscure collaboration rules |
| Internal state must be restored opaquely | Memento | Snapshot-based restoration is required |
| Dynamic subscribers need event notification | Observer | Subscription lifecycle genuinely changes at runtime |
| Lifecycle state governs legal behavior and transitions | State | Transition defects or branching grow with state history |
| Callers select interchangeable algorithms or policies | Strategy | Multiple policies perform the same conceptual operation |
| A stable algorithm skeleton varies selected inherited steps | Template Method | Inheritance is a deliberate extension model |
| New operations frequently target a stable element hierarchy | Visitor | Element types are stable and type-specific dispatch matters |

## Chain of Responsibility

- **Intent:** Route a request through an ordered set of handlers that may handle, transform, stop, or pass it onward.
- **Problem signals:** Sender and receiver selection must be decoupled, handler order is configurable, or middleware-like stages have explicit continuation semantics.
- **Preconditions:** Request ownership, ordering, termination, error propagation, and “unhandled” behavior are defined.
- **Use when:** Validation, middleware, approval, fallback, or processing stages need independently composable order and stop/continue decisions.
- **Avoid when:** The sequence is fixed and explicit orchestration is clearer, every stage must always run, or tracing the chain would hide critical control flow.
- **Simpler alternatives:** Loop over functions, explicit pipeline, switch, or direct orchestration.
- **Minimal structure:** A handler contract with an explicit outcome or continuation signal and an explicitly assembled ordered chain.
- **Costs and failure modes:** Requests may be silently unhandled, order becomes configuration-dependent, debugging spans handlers, and error or mutation semantics can be inconsistent.
- **Related patterns:** Decorator usually accumulates behavior; Command represents the request; Observer fans out; Mediator centrally coordinates peers.
- **Source:** https://refactoring.guru/ko/design-patterns/chain-of-responsibility

## Command

- **Intent:** Represent a request as a value or object so execution can be delayed, queued, logged, retried, composed, or undone.
- **Problem signals:** Request producers and executors have different lifecycles, actions need metadata or persistence, or history and undo are requirements.
- **Preconditions:** Command input, execution result, idempotency, failure, serialization, and undo semantics are explicit where relevant.
- **Use when:** Jobs, transactions, macros, audit logs, retry queues, or undo stacks require request identity beyond an immediate call.
- **Avoid when:** A direct call or closure is sufficient, commands contain all business logic without a useful receiver boundary, or no lifecycle separation exists.
- **Simpler alternatives:** Function, closure, message record plus dispatcher, or direct method call.
- **Minimal structure:** A command contract or data representation, explicit execution boundary, and only required metadata. Add receivers, history, or undo only for current needs.
- **Costs and failure modes:** Many tiny types, duplicated validation, stale serialized commands, hidden transaction boundaries, non-idempotent retries, and unreliable inverse operations.
- **Related patterns:** Strategy changes how one job is performed; Memento can support undo; Chain routes commands; Prototype can copy configured commands.
- **Source:** https://refactoring.guru/ko/design-patterns/command

## Iterator

- **Intent:** Traverse a collection without exposing its internal representation, potentially supporting multiple traversal policies.
- **Problem signals:** Traversal state must be externalized, several traversal orders exist, or clients should not depend on collection internals.
- **Preconditions:** The language's native iteration is insufficient; mutation during traversal, resource ownership, completion, and error behavior are specified.
- **Use when:** Custom lazy traversal, graph/tree order, paged data, resumable iteration, or parallel traversals require an explicit cursor abstraction.
- **Avoid when:** Native loops, generators, streams, or collection APIs already express the traversal safely.
- **Simpler alternatives:** Native iterator protocol, generator, sequence, stream, callback traversal, or collection method.
- **Minimal structure:** An iterator or generator that owns traversal state and exposes only the language-idiomatic next/current contract.
- **Costs and failure modes:** Resource leaks, invalidation after mutation, awkward error handling, hidden allocation, and redundant wrappers around native iteration.
- **Related patterns:** Composite is often traversed; Visitor performs operations during traversal; Memento can capture cursor state when resumption is required.
- **Source:** https://refactoring.guru/ko/design-patterns/iterator

## Mediator

- **Intent:** Centralize collaboration rules among peers so they do not directly depend on one another.
- **Problem signals:** Components form a many-to-many dependency graph, interaction rules are duplicated, or reusable peers are coupled to a specific screen or workflow.
- **Preconditions:** The collaboration has a coherent owner; the mediator boundary can remain focused rather than absorbing unrelated domain behavior.
- **Use when:** UI components, workflow participants, or protocol peers need coordinated interaction that changes independently of each participant.
- **Avoid when:** A few direct calls are clear, normal application orchestration already owns the workflow, or centralization creates a god object.
- **Simpler alternatives:** Explicit application service, callback, event, direct dependency, or smaller pairwise collaborator.
- **Minimal structure:** Peers report meaningful events or requests to a mediator; the mediator owns only coordination and invokes peers through narrow operations.
- **Costs and failure modes:** Oversized mediator, hidden control flow, stringly events, circular re-entry, and reduced peer autonomy.
- **Related patterns:** Observer distributes notifications; Facade offers a subsystem entry point; Chain routes requests; Command can represent mediated actions.
- **Source:** https://refactoring.guru/ko/design-patterns/mediator

## Memento

- **Intent:** Capture and restore an object's state without exposing representation to the caretaker.
- **Problem signals:** Undo, checkpoints, speculative edits, or rollback require snapshots while encapsulation must remain intact.
- **Preconditions:** Snapshot scope, ownership, versioning, memory cost, sensitive data, and external side effects are defined.
- **Use when:** An originator can safely create and restore opaque state and inverse operations are unreliable or unavailable.
- **Avoid when:** State is already an immutable value, a simple copy is sufficient, snapshots are huge, or external effects cannot be restored.
- **Simpler alternatives:** Immutable state history, copy function, event log, inverse command, database transaction, or domain-specific change set.
- **Minimal structure:** The originator creates and consumes an opaque snapshot; a caretaker stores it without inspecting internals.
- **Costs and failure modes:** Memory growth, stale snapshot versions, captured secrets, invalid resource references, and a false sense that external side effects are undone.
- **Related patterns:** Command can pair snapshots with actions; Prototype creates usable copies; Iterator state may be captured for resumption.
- **Source:** https://refactoring.guru/ko/design-patterns/memento

## Observer

- **Intent:** Notify a dynamic set of subscribers when a subject event occurs without coupling the publisher to concrete receivers.
- **Problem signals:** Independent subscribers appear or disappear at runtime, fan-out is required, and publisher code should not own subscriber behavior.
- **Preconditions:** Subscription ownership, unsubscribe lifecycle, delivery order, synchronous or asynchronous execution, error isolation, re-entrancy, and payload contracts are explicit.
- **Use when:** Multiple independent views, plugins, domain reactions, or integrations subscribe dynamically to meaningful events.
- **Avoid when:** There is one fixed receiver, event order is business-critical but implicit, or a direct workflow call communicates the dependency more honestly.
- **Simpler alternatives:** Direct call, callback, returned result, explicit application orchestration, or framework-native event primitive.
- **Minimal structure:** A typed event contract, explicit subscribe/unsubscribe lifecycle, and publisher behavior with documented delivery and failure semantics.
- **Costs and failure modes:** Hidden dependencies, leaks from stale subscriptions, nondeterministic ordering, cascading failures, event cycles, and difficult tracing.
- **Related patterns:** Mediator owns coordination; Chain routes one request; Command represents actions; State may publish transitions but should still own transition rules.
- **Source:** https://refactoring.guru/ko/design-patterns/observer

## State

- **Intent:** Encapsulate lifecycle-dependent behavior so legal operations and transitions change with an object's internal state.
- **Problem signals:** Large state conditionals recur across methods, transition rules are duplicated, illegal transitions cause defects, or state-specific behavior grows independently.
- **Preconditions:** States, events, legal transitions, transition ownership, persistence, concurrency, and failure semantics can be named.
- **Use when:** Orders, workflows, sessions, parsers, or devices have meaningful lifecycle states whose behavior and transitions require explicit enforcement.
- **Avoid when:** The state space is small and closed enough for one clear transition table or switch, or callers simply choose interchangeable policies.
- **Simpler alternatives:** Enum or sum type plus pure transition function, lookup table, pattern matching, or a state machine library already used by the project.
- **Minimal structure:** A context holding current state, explicit event operations, and only current state behaviors or a transition table. Keep transition policy in one identifiable place.
- **Costs and failure modes:** Many state types, fragmented transition visibility, cyclic transitions, persistence mapping, concurrency races, and accidental Strategy-like caller selection.
- **Related patterns:** Strategy is externally selected policy; Command can represent transition events; Memento restores state; Observer can notify after transitions.
- **Source:** https://refactoring.guru/ko/design-patterns/state

## Strategy

- **Intent:** Encapsulate interchangeable algorithms or policies for the same conceptual operation so the caller or wiring can select one.
- **Problem signals:** Multiple algorithms exist, selection varies by configuration or request, and branches mix policy with orchestration.
- **Preconditions:** Strategies share meaningful input and output semantics; the selection owner is external to the strategy; variants are independently testable.
- **Use when:** Pricing, routing, validation, serialization, ranking, or retry policy has real interchangeable variants and a stable operation contract.
- **Avoid when:** Only one short algorithm exists, variants are unlikely to change, or a function parameter or direct branch is clearer.
- **Simpler alternatives:** Function or closure, lookup table, enum plus switch, higher-order function, or standard-library policy type.
- **Minimal structure:** Prefer a callable or narrow strategy contract and explicit selection. Add classes or objects only when strategies own state, dependencies, identity, or lifecycle.
- **Costs and failure modes:** Clients must understand selection, contracts may become lowest-common-denominator, tiny classes proliferate, and configuration errors move to wiring.
- **Related patterns:** State changes internally through transitions; Template Method uses inheritance and a fixed skeleton; Command represents a request rather than an algorithm.
- **Source:** https://refactoring.guru/ko/design-patterns/strategy

## Template Method

- **Intent:** Define a stable algorithm skeleton in a base abstraction while allowing selected steps to vary through inheritance.
- **Problem signals:** Several subclasses duplicate the same ordered process, only specific steps differ, and inheritance is an established extension mechanism.
- **Preconditions:** The skeleton and invariants are genuinely stable; overridable hooks are narrow; subclass contracts and call order can be documented and enforced.
- **Use when:** A framework controls execution order and subclasses supply a few well-defined steps without changing the overall algorithm.
- **Avoid when:** Runtime composition is needed, inheritance is discouraged by the language or repository, or subclasses need to override most of the workflow.
- **Simpler alternatives:** Higher-order function, Strategy composition, explicit pipeline, or a shared helper called by concrete implementations.
- **Minimal structure:** One non-overridable or conventionally stable template operation and the smallest set of required hooks. Optional hooks need a safe semantic default.
- **Costs and failure modes:** Fragile base class, hidden call order, subclass coupling, hook proliferation, and violations of the intended skeleton.
- **Related patterns:** Strategy varies behavior through composition; Factory Method may be a hook; Chain models independently assembled stages.
- **Source:** https://refactoring.guru/ko/design-patterns/template-method

## Visitor

- **Intent:** Add type-specific operations across a stable element hierarchy without placing every operation on the element types.
- **Problem signals:** Many unrelated operations are repeatedly added to a stable set of element variants, and each operation needs variant-specific behavior or double dispatch.
- **Preconditions:** The element type set changes less often than operations; traversal and dispatch semantics are explicit; the language lacks a simpler exhaustive matching form for the context.
- **Use when:** Compilers, document models, ASTs, or heterogeneous structures have stable variants and a growing operation set that should remain grouped by operation.
- **Avoid when:** Element variants change frequently, only one operation exists, pattern matching or methods are clearer, or visitors require exposing sensitive internals.
- **Simpler alternatives:** Exhaustive pattern matching, type switch, methods on elements, external functions, or data-oriented transforms.
- **Minimal structure:** An element dispatch operation and one visitor operation per current element variant. Keep traversal separate unless every visitor must own it.
- **Costs and failure modes:** Adding an element changes every visitor, boilerplate dispatch, broken encapsulation, awkward return types, and difficult asynchronous operations.
- **Related patterns:** Composite supplies structures; Iterator controls traversal; Strategy swaps one algorithm; Interpreter is outside this skill's 22-pattern catalog.
- **Source:** https://refactoring.guru/ko/design-patterns/visitor

## Exit Check

Before selecting a behavioral pattern, answer:

- Who chooses behavior: caller, object state, sender, chain, subscribers, or traversal?
- When does the choice change: each call, wiring, lifecycle transition, or type dispatch?
- Does behavior need identity, persistence, ordering, undo, or dynamic subscription?
- Can a function, explicit orchestrator, native iterator, callback, or transition table express it more directly?

If control ownership remains unclear, do not hide it behind a pattern.
