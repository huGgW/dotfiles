---
name: design-patterns
description: >
  Use this skill whenever selecting, comparing, applying, reviewing, or removing
  software design patterns across programming languages. Trigger for requests
  about Strategy, Factory, Builder, Adapter, Decorator, Observer, State, and
  other GoF patterns; growing conditionals, unstable construction, awkward
  object collaboration, state-transition defects, interface mismatches, or
  suspected overengineering; and phrases such as "어떤 디자인 패턴", "패턴을
  적용해줘", "이 추상화가 필요한가", "리팩터링해줘", or "design pattern
  review". Evaluate concrete forces, compare against a no-pattern baseline, and
  choose the smallest coherent design. Use installed language or framework
  specialists for idiomatic implementation details. Do not use for broad system
  architecture, project decomposition, or a general review with no pattern or
  abstraction decision.
compatibility: Designed for coding agents that can inspect repositories, edit code, and run project checks.
---

# Design Patterns

Select patterns from evidence, not from a desire to introduce named abstractions. A pattern is useful when it gives a recurring design pressure a smaller and more stable place to change. The correct result may be a direct function, a conditional, a standard-library feature, or removal of an existing pattern.

## Scope

Own the language-independent decision:

- Identify the actual problem forces and required variation.
- Decide whether a pattern is justified now.
- Compare the direct design with at most two close pattern candidates.
- Select, apply, simplify, or remove one of the 22 cataloged GoF patterns.
- Explain costs, rejected alternatives, and a revisit or removal condition.

Do not expand this skill into system architecture, distributed-systems patterns, concurrency control, database design, security, or performance tuning. Route those concerns to an installed specialist. For broad project architecture or decomposition, use `project-architect` when available.

## Specialist Precedence

Use the following order when instructions overlap:

1. Project or company-specific conventions.
2. Installed language or framework specialists.
3. This skill for pattern selection and complexity control.
4. General review or documentation guidance.

Keep ownership explicit: this skill decides whether and why a pattern fits; a language specialist decides details such as Go interface shape, Java type hierarchy, framework lifecycle, or language-native alternatives. Use both when the task includes selection and implementation.

## Modes

| Mode | Goal | Default action |
| --- | --- | --- |
| Explain | Teach a pattern in context | Explain intent, forces, costs, one close alternative, and when not to use it. |
| Select | Choose among designs | Compare a direct baseline with no more than two fitting patterns. |
| Design | Introduce a design seam | Implement the smallest structure justified by observed variation. |
| Review | Assess an existing abstraction | Report concrete costs or defects first, then retain, shrink, replace, or remove it. |
| Refactor | Change structure safely | Preserve observable behavior, move one seam at a time, and verify after the change. |

If the user asks for a code change, inspect and edit the repository rather than stopping at a recommendation.

## Decision Workflow

1. Inspect the context.
   - Read relevant code, tests, configuration, and local conventions.
   - Detect the language, framework, public API constraints, and installed specialist skills.
   - Do not infer a variation point from a class name or pattern-shaped code alone.

2. State the forces before naming a pattern.
   - `Problem`: What behavior is difficult, duplicated, coupled, or defective?
   - `Evidence`: Which concrete call sites, branches, changes, tests, or incidents demonstrate it?
   - `Variation`: What differs now, who selects it, and when can it change?
   - `Constraints`: What cannot be modified, what is public, and which invariants must hold?
   - `Baseline`: What is the simplest direct implementation?

3. Apply the pattern-needed gate.
   - A present pain or objective boundary exists.
   - A function, conditional, data structure, standard library, or language feature is insufficient.
   - A second real variation exists, or there is credible near-term evidence for one.
   - Reduced coupling or safer invariants outweigh added types, indirection, configuration, and tests.
   - Removing the pattern would fail a current requirement.

4. Load only the needed references.
   - Read `references/decision-workflow.md` for non-trivial selection, design, review, or refactoring.
   - Read `references/anti-overengineering.md` when a new hierarchy, framework-like seam, global, event bus, or speculative extension point is proposed, or when reviewing excess abstraction.
   - Read one category file under `references/patterns/` based on the dominant force.
   - Read `references/relationships.md` only when candidates are structurally similar or commonly confused.
   - Read `references/sources.md` only for provenance or further study.

5. Compare bounded candidates.
   - Always include the no-pattern baseline.
   - Add the smallest fitting pattern.
   - Add one close alternative only when it could realistically win.
   - Compare present fit, added concepts, change isolation, testability, debugging cost, reversibility, and team conventions.

6. Decide at the current evidence level.
   - Prefer the direct design when the gate is not satisfied.
   - Allow one-implementation abstractions only for an objective boundary such as an unmodifiable external API, a public extension contract, lifecycle or access control, or a state invariant.
   - Name a pattern only when its intent matches the problem; structural resemblance is not enough.

7. Implement the minimum coherent form.
   - Abstract only observed variation.
   - Introduce one seam at a time and preserve existing naming and module boundaries.
   - Prefer composition and language-native functions where they express the intent without ceremonial types.
   - Avoid unrelated cleanup unless it is required to make the change safe.

8. Verify the decision.
   - Run focused tests, then the relevant build, type checker, linter, or static analysis.
   - For refactoring, verify observable behavior and public contracts before and after.
   - Check that the expected next variation is easier without making the current path harder to understand.

9. Report the result proportionally.
   - State the decision and evidence.
   - Mention the direct baseline and why it won or lost.
   - Name the closest rejected alternative and its disqualifying force.
   - State added costs, verification performed, and the condition for revisiting or removing the abstraction.

Use `references/decision-workflow.md` for the full evidence rubric and comparison matrix.

## Category Routing

| Dominant force | Read | Typical candidates |
| --- | --- | --- |
| Object creation, configuration, cloning, or instance ownership | `references/patterns/creational.md` | Factory Method, Abstract Factory, Builder, Prototype, Singleton |
| Interface mismatch, composition, wrapping, access, or representation | `references/patterns/structural.md` | Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy |
| Algorithms, state, requests, traversal, communication, or undo | `references/patterns/behavioral.md` | Chain, Command, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor |

When several forces appear, identify the primary decision first. Read a second category only if it represents an independent problem, not merely a supporting implementation detail.

## Hard Simplicity Defaults

- One construction branch: call the constructor or use a creation function before introducing a factory hierarchy.
- One small algorithm: use a function or direct branch before Strategy classes.
- One callback target: use a callback before Observer or an event bus.
- Optional fields with no ordering or cross-field rules: use a constructor, object literal, or language-native options before Builder.
- Process-wide convenience: inject an explicit dependency before Singleton.
- A modifiable interface mismatch: change the service or caller directly before adding Adapter.
- An unconfirmed plugin future: do not build a plugin framework.
- A wrapper that only forwards calls: inline it unless it owns policy, translation, lifecycle, access, or instrumentation.

These are defaults, not keyword rules. Override them only with repository evidence or an objective boundary.

## Critical Distinctions

| Candidates | Distinguishing question |
| --- | --- |
| Factory Method vs creation function | Is subclass-polymorphic creation inside an existing creator hierarchy actually required? |
| Abstract Factory vs Factory Method | Must a whole compatible product family change together, or only one product creation point? |
| Builder vs options | Is ordered, staged, or invariant-heavy assembly the problem? |
| Adapter vs Facade vs Decorator vs Proxy | Is the intent interface translation, subsystem simplification, behavior composition, or access/lifecycle control? |
| Bridge vs Adapter | Are two variation axes designed to evolve independently, or is an existing mismatch being repaired? |
| Strategy vs State | Does the client choose an algorithm, or does internal state govern behavior and transitions? |
| Strategy vs Template Method | Is runtime composition needed, or is a stable inherited skeleton appropriate? |
| Strategy vs Command | Is the variation how to perform one job, or which request to represent, schedule, log, or undo? |
| Observer vs Mediator vs Chain | Is the need dynamic notification, centralized coordination, or sequential request handling? |

Read `references/relationships.md` before deciding among these pairs.

## Review Rules

Treat extra types as costs that require evidence, not as automatic improvements. In review mode, look for:

- Interfaces with one implementation and no boundary or testing role.
- Factories that only rename a constructor.
- Strategy, State, or Command objects with no meaningful behavioral distinction.
- Builders for flat optional data.
- Decorators, proxies, or adapters that merely forward without owning a distinct responsibility.
- Observer graphs whose event order, ownership, or failure behavior is implicit.
- Singleton state that hides dependencies or leaks between tests.
- Pattern scaffolding retained after the variation disappeared.

Do not recommend a rewrite solely because a textbook structure is incomplete. Judge whether the current code localizes the real change safely and clearly.

## Output Contract

For explanation or selection, use a compact structure:

```markdown
## Decision
## Evidence and Forces
## Direct Baseline
## Selected Design
## Rejected Alternative
## Costs and Revisit Condition
```

For code changes, keep the final response shorter: summarize the implemented decision, files changed, verification, and any residual risk. Do not force a design essay when the diff and tests provide the evidence.

## Source Discipline

The bundled references are original decision-oriented summaries. They do not reproduce source diagrams, narrative examples, pseudocode, or page structure. Use direct links in `references/sources.md` for attribution and deeper reading.
