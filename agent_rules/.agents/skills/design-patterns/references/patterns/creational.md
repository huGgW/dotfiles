# Creational Pattern Cards

Read this file when object creation, staged assembly, cloning, product-family compatibility, or instance uniqueness is the dominant force. Do not use a creational pattern merely to avoid writing `new`, a constructor call, or a language-native literal.

## Start with Direct Creation

Use the smallest baseline that preserves the required policy:

- Constructor or literal for one concrete representation.
- Named creation function or static method for validation, defaults, or a meaningful construction name.
- Explicit conditional or simple factory function for a small closed product set.
- Language-native options or named parameters for flat optional configuration.
- One instance constructed at the composition root and injected into consumers for shared services.

Escalate only when creation itself is a proven variation point or invariant boundary.

## Quick Selection

| Force | Candidate | Decisive evidence |
| --- | --- | --- |
| A creator workflow must vary one product construction step | Factory Method | Creator polymorphism is deliberate and the workflow is shared |
| Several related products must switch as a compatible family | Abstract Factory | At least two product roles vary together |
| A complex product is assembled in stages | Builder | Ordering, partial configuration, validation, or representations matter |
| Runtime-configured objects must be copied | Prototype | The exemplar carries configuration unavailable to static construction |
| Exactly one identity must exist and be globally reachable | Singleton | Uniqueness is an invariant, not merely convenient wiring |

## Factory Method

- **Intent:** Let variants of a creator choose the concrete product while shared creator logic depends on a product contract.
- **Problem signals:** A creator workflow is stable, product construction differs by creator variant, and subclasses or equivalent polymorphic creator implementations are already a supported extension model.
- **Preconditions:** The product has a useful common contract; the creator owns behavior beyond forwarding to construction; creation must vary through creator polymorphism.
- **Use when:** Framework hooks or creator variants need to supply products without duplicating the surrounding workflow.
- **Avoid when:** The goal is only to name or centralize a constructor, the product set is a small closed conditional, or no creator hierarchy exists.
- **Simpler alternatives:** Constructor, static creation method, creation function, or simple factory function.
- **Minimal structure:** A product contract, one creator operation that obtains a product, and only the concrete creator variants that already exist.
- **Costs and failure modes:** Creator subclasses can multiply with product variants; construction becomes indirect; users often mislabel any factory function as Factory Method.
- **Related patterns:** Abstract Factory can be implemented through factory methods; Template Method may call a factory method; Prototype can replace subclass-based construction.
- **Source:** https://refactoring.guru/ko/design-patterns/factory-method

## Abstract Factory

- **Intent:** Create a compatible family of related products without coupling clients to family-specific concrete types.
- **Problem signals:** Multiple product roles vary together, mixed-family combinations are invalid or undesirable, and clients must switch the family as one decision.
- **Preconditions:** At least two meaningful product roles and at least two family variants exist or are contractually committed; family compatibility is a real invariant.
- **Use when:** UI themes, platform integrations, or vendor families provide coordinated components behind stable product contracts.
- **Avoid when:** Only one product varies, products can be selected independently, or a small creation function expresses the choice clearly.
- **Simpler alternatives:** Configuration plus constructors, a family-specific module, a simple factory returning one aggregate, or explicit dependency wiring.
- **Minimal structure:** One family factory contract with one creation operation per product role, concrete family factories, and product contracts used by clients.
- **Costs and failure modes:** Adding a new product role changes every family; family contracts can become broad; configuration and testing multiply across family combinations.
- **Related patterns:** Factory Method handles individual creation hooks; Builder assembles one complex result; Prototype can populate family products from exemplars.
- **Source:** https://refactoring.guru/ko/design-patterns/abstract-factory

## Builder

- **Intent:** Assemble a complex object through explicit steps while separating the construction process from the final representation.
- **Problem signals:** Construction has ordered phases, cross-field invariants, optional branches, repeated incremental setup, or multiple representations produced by the same logical process.
- **Preconditions:** A one-shot constructor or native options obscures invariants or permits invalid combinations; intermediate construction state has a clear owner.
- **Use when:** The caller benefits from staged assembly, validation at `build`, reusable construction sequences, or alternate outputs from equivalent steps.
- **Avoid when:** Data is flat, options are independent, only one short constructor call exists, or fluent syntax is the sole motivation.
- **Simpler alternatives:** Constructor, named parameters, object literal, record, functional options, or a validated creation function.
- **Minimal structure:** A builder that owns partial state, only required step operations, and one final operation that validates and returns the product. A director is optional and requires reusable sequences.
- **Costs and failure modes:** Partial mutable state can leak; required step order may remain unenforced; one builder per representation can add ceremony; fluent APIs may hide validation failures.
- **Related patterns:** Abstract Factory selects product families; Composite may be assembled by a builder; Prototype can clone a configured base before small changes.
- **Source:** https://refactoring.guru/ko/design-patterns/builder

## Prototype

- **Intent:** Create objects by copying a runtime exemplar instead of reconstructing them from concrete-type knowledge.
- **Problem signals:** Instances carry expensive or runtime-derived configuration, concrete types are not known to the caller, and cloning is a meaningful domain operation.
- **Preconditions:** Copy semantics are well-defined for identity, mutable members, resources, and nested objects; cloning is safer or cheaper than normal construction.
- **Use when:** Preconfigured variants are registered at runtime or initialization cost can be reused through controlled copies.
- **Avoid when:** Objects are simple to construct, identity must remain unique, resources cannot be duplicated safely, or serialization is being used only to imitate copying.
- **Simpler alternatives:** Copy constructor, record update, explicit `copy` function, immutable value reuse, or normal creation from configuration.
- **Minimal structure:** An explicit copy operation or protocol and concrete copy logic that documents deep, shallow, shared, and regenerated fields.
- **Costs and failure modes:** Shared mutable references, cycles, stale caches, duplicated identifiers, open handles, and subclass copy bugs can make clones invalid.
- **Related patterns:** Abstract Factory can return prototypes; Memento captures restoration state rather than a new usable instance; Builder can modify a copied base.
- **Source:** https://refactoring.guru/ko/design-patterns/prototype

## Singleton

- **Intent:** Enforce one instance identity and provide controlled access to it.
- **Problem signals:** Multiple instances would violate a process-level invariant, and the language or composition boundary cannot enforce uniqueness more explicitly.
- **Preconditions:** Uniqueness, initialization, concurrency, reset, failure, and teardown semantics are specified and testable.
- **Use when:** Rarely, for a truly process-unique coordinator or resource identity whose duplication is invalid rather than merely inefficient.
- **Avoid when:** The goal is convenient global access, shared configuration, logging, caching, database access, or avoiding dependency injection.
- **Simpler alternatives:** Construct one instance at the composition root, pass it explicitly, use module state with controlled ownership where idiomatic, or let a framework lifecycle own the instance.
- **Minimal structure:** Restricted creation, a concurrency-safe access path, explicit initialization failure behavior, and a test strategy. Do not add a global service locator around it.
- **Costs and failure modes:** Hidden dependencies, order-sensitive tests, leaked state, race conditions, difficult teardown, and conflation of instance ownership with global access.
- **Related patterns:** Facade may expose a subsystem without enforcing one instance; Proxy may control access or lifecycle without global state; Abstract Factory can configure scoped instances.
- **Source:** https://refactoring.guru/ko/design-patterns/singleton

## Exit Check

Before selecting a creational pattern, answer:

- What creation decision cannot remain explicit at the call site?
- Is the variation about one product, a family, an assembly process, a runtime exemplar, or identity uniqueness?
- Which invalid state or repeated change does the pattern prevent?
- Can the same result be achieved with a creation function and explicit dependency wiring?

If the final answer is only “callers should not know the concrete class,” explain why that knowledge is harmful now.
