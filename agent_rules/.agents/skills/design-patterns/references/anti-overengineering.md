# Anti-Overengineering Guardrails

Read this guide when proposing or reviewing a hierarchy, factory layer, framework-like extension point, global instance, event bus, generic pipeline, or wrapper chain. Its purpose is to prevent speculative generality while preserving abstractions that enforce real boundaries and invariants.

## Core Test

An abstraction should answer all three questions:

1. What current fact varies or must be protected?
2. Which change becomes local because this abstraction exists?
3. What ongoing cost does the repository accept in return?

If any answer is vague, use or restore the direct design.

## Common Warning Signs

| Signal | Why it is suspicious | Preferred response |
| --- | --- | --- |
| “We may support more implementations later” | No committed variation | Keep a direct call; record a concrete extraction trigger |
| Interface and implementation have the same lifecycle and one caller | Contract may only rename the class | Inline unless it marks a real consumer boundary |
| Factory delegates to one constructor with no policy | Creation is not actually variable | Use the constructor or a named creation function |
| Builder sets flat optional fields in any order | No staged assembly or invariant | Use an object literal, constructor, or native options |
| Strategy type wraps one short function | Type hierarchy exceeds the algorithm | Pass a function or keep a branch |
| Observer has one publisher and one fixed listener | Dynamic subscription is absent | Use an explicit callback or direct call |
| Adapter wraps code owned by the same team | The mismatch may be removable | Align the interfaces directly |
| Decorator or proxy only forwards | No added behavior or policy ownership | Inline or call the target directly |
| Singleton exists for convenient access | Dependency and lifecycle become hidden | Construct once and inject explicitly |
| Generic registry or plugin loader has no plugins | Configuration surface precedes demand | Use explicit wiring |
| New layers mirror folder names but own no decisions | Navigation cost rises without isolation | Collapse the layers |

Do not use line count alone. A small boundary can justify an adapter; a large codebase can still benefit from a direct function.

## Simpler Substitutes

Before introducing a GoF structure, try the language-native form that preserves the same intent:

- Function, closure, or callable value for a small Strategy or Command.
- Map or lookup table for stable dispatch.
- Enum, sum type, sealed type, or pattern matching for a small closed state space.
- Constructor, static creation method, or module-level creation function for simple creation.
- Object literal, named parameters, record update, or functional options for flat configuration.
- Standard iteration protocol or generator for traversal.
- Direct callback for one fixed notification path.
- Plain module function for a stateless facade.
- Explicit dependency injection without a container for shared services.
- Standard-library proxy, cache, synchronization, or event primitive when its semantics fit.

Language-native does not mean automatically better. Check ownership, invariants, failure semantics, and team conventions.

## Pattern-Specific Restraints

### Factory restraint

Keep these terms distinct:

- A constructor creates an instance.
- A creation function or static creation method names construction policy.
- A simple factory selects among concrete products without requiring subclass polymorphism.
- Factory Method delegates a product creation step through an overridable creator contract.
- Abstract Factory creates a compatible family through a family-level contract.

Do not call every creation helper Factory Method. Do not create a creator hierarchy when explicit selection in one function is clearer.

### Strategy restraint

Use a function when behavior is small, stateless, and selected explicitly. Introduce a Strategy contract when policies have meaningful identity, state, dependencies, lifecycle, or a stable cross-module extension boundary.

### Builder restraint

Builder earns its cost through staged assembly, ordering, repeated incremental construction, cross-field validation, or multiple representations. Optional setters alone are not enough.

### Observer restraint

Observer requires explicit subscription ownership, ordering, failure isolation, and unsubscribe behavior. If these semantics do not need to vary, a direct callback is easier to trace.

### Singleton restraint

“Only one is configured” differs from “only one can exist.” Prefer application wiring that constructs one instance and passes it to consumers. Consider Singleton only when identity uniqueness is itself an invariant and tests, concurrency, initialization, and teardown are controlled.

### Adapter restraint

If both sides are modifiable and share ownership, make them agree directly. Adapter is strongest at an unmodifiable or independently evolving boundary.

## Objective Reasons for Early Abstraction

Do not apply a rigid two-implementation rule. A seam with one implementation is justified when one of these facts exists now:

- An external, legacy, generated, or vendor interface cannot be changed.
- A public extension API must remain stable for independent consumers.
- Access control, remote transport, caching, lazy loading, or lifecycle is a boundary policy.
- Invalid state transitions or incompatible product combinations must be impossible or explicit.
- A side-effecting boundary must be isolated for deterministic tests and is already part of the domain boundary.

State the objective reason. Do not disguise speculative flexibility as a boundary.

## Cost Inventory

Count ongoing costs, not only initial code:

- Types, files, naming, and documentation.
- Wiring, registration, configuration, and startup failures.
- Indirect call paths and debugging hops.
- Mock, fixture, and test-matrix growth.
- Error, cancellation, ordering, and concurrency semantics.
- Migration burden when contracts change.
- Cognitive load for contributors unfamiliar with the pattern.

An abstraction that makes one test easier but every production call harder to trace may be a net loss.

## Removal and Simplification

Remove scaffolding when its variation disappears or never arrives.

| Smell | Simplification |
| --- | --- |
| Lazy class with no independent responsibility | Inline the class or module |
| Middle man forwarding every operation | Remove the intermediary or expose the real collaborator |
| Parallel hierarchy with one surviving branch | Collapse the hierarchy |
| Parameter or option never varied | Remove it |
| Interface owned by the implementation, not a consumer | Return or accept the concrete type where appropriate |
| Registry with static entries | Replace with explicit construction |
| Event used as an indirect method call | Restore the direct call |

Delete superseded code in the same change when safe. Compatibility layers are justified only by actual persisted data, public consumers, staged migration, or another concrete constraint.

## Reversibility Bias

When evidence is incomplete, choose the option that is easiest to change after learning:

- Direct function before hierarchy.
- Explicit wiring before container.
- Local adapter before shared framework.
- Closed representation before public extension API.
- One-purpose wrapper before generic middleware stack.

Reversibility is not an excuse to ignore known requirements. It limits the cost of uncertain ones.

## Review Checklist

- Can the abstraction's current force be named in one sentence?
- Is the direct baseline documented or obvious?
- Does each type own a decision, invariant, boundary, or lifecycle?
- Is the expected next change local?
- Are control flow and ownership still traceable?
- Are language-native alternatives considered?
- Does the pattern preserve repository conventions?
- Is there a concrete removal or revisit condition?

If several answers are no, recommend the smallest behavior-preserving collapse rather than replacing one pattern with another.
