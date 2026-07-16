# Structural Pattern Cards

Read this file when the dominant force is interface compatibility, independent structural variation, part-whole composition, behavior wrapping, subsystem simplification, memory sharing, or access control. Wrapping an object does not identify a pattern; the wrapper's intent does.

## Start with Direct Structure

Consider these baselines first:

- Align two owned interfaces directly.
- Use a conversion function at a small data boundary.
- Compose functions or call explicit helpers for local behavior.
- Expose a module-level entry point for a simple subsystem.
- Use native collections and iteration for ordinary trees.
- Measure memory before sharing representation.
- Use framework or standard-library proxy/cache primitives when their semantics fit.

## Quick Selection

| Force | Candidate | Decisive evidence |
| --- | --- | --- |
| Existing interfaces or representations do not match | Adapter | At least one side is unmodifiable or independently evolving |
| Two dimensions must vary independently | Bridge | Both axes have real variants and cross-product growth |
| Parts and groups require uniform operations | Composite | Recursive part-whole structure is intrinsic to the domain |
| Responsibilities must be stacked dynamically | Decorator | Layers preserve one contract and compose independently |
| Clients need a coherent entry point to a subsystem | Facade | Subsystem coordination is repeatedly leaked to callers |
| Many objects repeat large immutable state | Flyweight | Measurement shows shared intrinsic state materially helps |
| Access, location, loading, or lifecycle needs control | Proxy | The boundary policy must preserve the subject contract |

## Adapter

- **Intent:** Translate an existing interface or representation into the contract a client expects.
- **Problem signals:** Integration code repeats translation, a vendor or legacy API cannot be changed, or independently owned models evolve on different schedules.
- **Preconditions:** The mismatch and ownership boundary are explicit; translation semantics, errors, and data loss are defined.
- **Use when:** Isolating third-party APIs, legacy contracts, generated clients, or protocol representations from the core model.
- **Avoid when:** Both sides are owned and can be aligned directly, or one local conversion function is clearer than an object wrapper.
- **Simpler alternatives:** Rename or change the owned interface, use a mapping function, or translate once at the composition boundary.
- **Minimal structure:** A client-owned target contract and one adapter that translates calls and results to the adaptee. Add an adaptee interface only if its boundary independently requires one.
- **Costs and failure modes:** Extra indirection, duplicated models, lossy translation, exception mismatch, and stale adapters after either side changes.
- **Related patterns:** Facade simplifies rather than translates; Decorator adds behavior; Proxy controls access; Bridge separates planned variation axes.
- **Source:** https://refactoring.guru/ko/design-patterns/adapter

## Bridge

- **Intent:** Split an abstraction from an implementation dimension so both can vary independently through composition.
- **Problem signals:** Two real axes create subclass or conditional cross-product growth, and each axis changes for different reasons.
- **Preconditions:** Both dimensions have meaningful variants, a stable collaboration contract exists between them, and independent evolution is valuable now.
- **Use when:** A domain abstraction and platform/provider/rendering implementation have separate lifecycles and combinations.
- **Avoid when:** Only one axis varies, variants are speculative, or a single strategy/function handles the variation without a second abstraction hierarchy.
- **Simpler alternatives:** Composition with a function, one interface at the boundary, explicit conditionals, or separate modules.
- **Minimal structure:** The high-level abstraction owns an implementation contract; concrete abstractions and implementations exist only for current variants.
- **Costs and failure modes:** More concepts, wiring complexity, feature leakage across the bridge, and a supposedly stable contract that becomes a lowest-common-denominator API.
- **Related patterns:** Adapter repairs an existing mismatch; Strategy usually varies one algorithm dimension; Abstract Factory can create compatible bridge pairs.
- **Source:** https://refactoring.guru/ko/design-patterns/bridge

## Composite

- **Intent:** Represent recursive part-whole structures so clients can treat leaves and groups through a common operation.
- **Problem signals:** The domain is a tree, operations recurse over leaves and groups, and callers otherwise branch repeatedly on node shape.
- **Preconditions:** Uniform operations are semantically valid for both leaves and composites; ownership, mutation, cycles, and traversal are defined.
- **Use when:** File-like trees, UI hierarchies, expressions, organization structures, or nested tasks require recursive behavior.
- **Avoid when:** The structure is flat, leaf and group behavior is fundamentally different, or a plain recursive data type and function are clearer.
- **Simpler alternatives:** Native tree data, tagged unions with pattern matching, recursive functions, or collection helpers.
- **Minimal structure:** A narrow component operation, leaves, and composites owning children. Keep child-management APIs separate when leaves cannot support them meaningfully.
- **Costs and failure modes:** Over-broad common contracts, hidden traversal cost, cycles, unclear ownership, and operations that make no sense for leaves.
- **Related patterns:** Iterator traverses structures; Visitor adds external operations to stable element types; Decorator also preserves a component contract but wraps one child.
- **Source:** https://refactoring.guru/ko/design-patterns/composite

## Decorator

- **Intent:** Add independently composable responsibilities around an object while preserving its core contract.
- **Problem signals:** Optional behaviors combine in many ways, inheritance causes combinatorial subclasses, or layers must be ordered at wiring time.
- **Preconditions:** The wrapped contract is stable; each layer has one clear responsibility; ordering, failure, and identity semantics are understood.
- **Use when:** Instrumentation, validation, transformation, retry policy, or presentation behavior must be stacked and independently configured.
- **Avoid when:** One helper call is enough, behavior is not substitutable, wrapper order is accidental, or only one permanent combination exists.
- **Simpler alternatives:** Function composition, explicit pipeline, helper function, subclass for one stable variation, or framework middleware.
- **Minimal structure:** A component contract, concrete component, and only current decorators that hold and delegate to another component while adding behavior.
- **Costs and failure modes:** Deep call stacks, opaque ordering, difficult unwrapping and identity, duplicated lifecycle handling, and many tiny forwarding types.
- **Related patterns:** Proxy controls access rather than composing responsibilities; Adapter changes the contract; Chain may stop propagation instead of accumulating behavior.
- **Source:** https://refactoring.guru/ko/design-patterns/decorator

## Facade

- **Intent:** Provide a small coherent entry point to a complex subsystem without hiding necessary lower-level access.
- **Problem signals:** Callers repeat orchestration, depend on many subsystem types, or must know initialization order and incidental details.
- **Preconditions:** A stable high-level use case can be named; the facade owns coordination rather than becoming a miscellaneous utility or domain god object.
- **Use when:** Establishing an application-facing boundary over a library, framework, legacy subsystem, or multi-step infrastructure operation.
- **Avoid when:** The subsystem is already simple, different callers need incompatible workflows, or the facade would merely mirror every underlying method.
- **Simpler alternatives:** Module function, application service, helper, or direct calls with improved subsystem APIs.
- **Minimal structure:** A focused entry point exposing a few use-case operations and delegating to subsystem components. Preserve escape hatches only when callers genuinely need them.
- **Costs and failure modes:** Oversized facade, hidden transaction or failure semantics, duplicated lower-level API, and a new coupling bottleneck.
- **Related patterns:** Adapter translates a contract; Mediator coordinates peers; Abstract Factory may construct subsystem components; Singleton is not required for a facade.
- **Source:** https://refactoring.guru/ko/design-patterns/facade

## Flyweight

- **Intent:** Reduce memory by sharing large immutable intrinsic state across many lightweight contextual objects.
- **Problem signals:** Profiling shows very high object counts and repeated state dominates memory; shared and contextual state can be separated safely.
- **Preconditions:** Memory pressure is measured, intrinsic state is immutable or safely shared, and lookup cost is acceptable.
- **Use when:** Text glyphs, tiles, symbols, or other massive repeated representations have a small set of shared values.
- **Avoid when:** Object counts are modest, state is mutable or identity-sensitive, or no measurement identifies memory as a bottleneck.
- **Simpler alternatives:** Interning supported by the runtime, enums, immutable value reuse, compact data representation, arrays, or deduplicated configuration.
- **Minimal structure:** An immutable shared value, external contextual state, and a cache or factory that reuses shared values with bounded lifecycle.
- **Costs and failure modes:** Cache growth, synchronization, accidental mutation, lookup overhead, split-state complexity, and retained objects preventing reclamation.
- **Related patterns:** Factory manages shared instances; Composite can share leaves; Prototype copies rather than shares; Proxy may lazy-load heavy state.
- **Source:** https://refactoring.guru/ko/design-patterns/flyweight

## Proxy

- **Intent:** Stand in for a subject to control access, location, loading, caching, or lifecycle while preserving the subject-facing contract.
- **Problem signals:** Clients need the same contract but calls cross a boundary or require policy such as authorization, lazy loading, remote transport, or caching.
- **Preconditions:** The proxy can preserve observable contract semantics; staleness, identity, errors, concurrency, and lifecycle policy are explicit.
- **Use when:** The boundary concern must be transparent or substitutable and cannot live cleanly inside the subject.
- **Avoid when:** A direct helper, explicit client, or decorator better communicates changed semantics; transparency would hide network or expensive behavior dangerously.
- **Simpler alternatives:** Explicit service client, wrapper function, framework interceptor, cache abstraction, or direct composition.
- **Minimal structure:** A subject contract, real subject, and proxy owning one boundary policy. Keep remote or failure behavior visible in naming and types when the language allows.
- **Costs and failure modes:** Hidden latency and I/O, cache inconsistency, identity surprises, duplicate lifecycle, partial contract emulation, and difficult debugging.
- **Related patterns:** Decorator composes behavior; Adapter changes the interface; Facade simplifies a subsystem; Flyweight shares state rather than controlling access.
- **Source:** https://refactoring.guru/ko/design-patterns/proxy

## Exit Check

Before selecting a structural pattern, answer:

- Is the intent translation, simplification, composition, access control, independent variation, recursive structure, or measured sharing?
- Must the client-facing contract remain the same, change, or become smaller?
- Can both sides be modified directly?
- What ownership, failure, lifecycle, and identity semantics does the new boundary add?

If the wrapper owns no distinct responsibility, remove it.
