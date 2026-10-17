---
name: code-development
description: >
  Use this skill when implementing, modifying, refactoring, debugging, or
  testing source code, tests, build files, migrations, or executable
  configuration. Load it before proposing an implementation plan. Do not use
  it for read-only research, code explanation, review-only tasks, or prose-only
  documentation. If a non-coding task transitions into code changes, load this
  skill before planning the implementation.
compatibility: Designed for coding agents that can inspect repositories, edit files, and run project checks.
---

# Code Development

Use this skill for the general workflow and safeguards that apply to code changes across languages and frameworks. Follow project-specific conventions first, and load relevant language, framework, testing, design, or tool-specific skills for specialized mechanics.

## Scope

Use this skill for implementation work involving:

- Source code.
- Tests and test infrastructure.
- Build files.
- Database migrations.
- Executable configuration.

Do not use it for read-only research, code explanation, review-only tasks, or prose-only documentation. If one of those tasks transitions into implementation, load this skill before proposing the implementation plan.

### Requirements and Design Heuristics

Keep binding explicit requirements, approved decisions, applicable project rules, and this skill's mandatory authoring safeguards distinct from default design heuristics. The plan agreement gate, surgical-change boundaries, verification duties, numbered step comments for newly written or directly modified methods and functions of 30 lines or more, and readable blank-line rules remain mandatory with their stated qualifications. Preferences about reuse, abstraction, type choice, and phase structure guide design; justify a different choice with concrete requirements or evidence rather than treating a preference as an unconditional prohibition. Do not turn every development rule into a reviewer checklist.

## 1. Think Before Coding

**Do not assume. Do not hide uncertainty. Surface tradeoffs early.**

Before implementation:
- State assumptions explicitly.
- If multiple interpretations exist, present options instead of silently picking one.
- If a simpler approach exists, say so.
- If something is unclear, ask a focused clarification.
- Identify applicable project conventions from project instructions, enforced formatter/linter rules, tests, and several comparable implementations before choosing an approach. Follow established conventions where they do not conflict with explicit requirements, correctness, or safety; do not infer a convention from one nearby example.
- When a design decision depends on ecosystem-specific behavior, consult available specialist guidance rather than relying only on general principles.

## 2. Mandatory Plan Agreement Gate

**No implementation before plan agreement.**

For every code-development request:
1. Propose a concise plan.
2. Get explicit user agreement on the plan.
3. Start implementation only after agreement.

After plan agreement:
- Execute autonomously without requesting approval at every sub-step.
- Ask again only when scope changes materially, new risk appears, or required information is missing.

## 3. Plan Format (Keep It Lightweight)

Use a plan format proportional to task complexity.

For small tasks:
```
1. [Change]
2. [Verify]
```

For medium/large tasks:
```
1. [Step] -> outcome: [expected result] -> verify: [test/check]
2. [Step] -> outcome: [expected result] -> verify: [test/check]
3. [Step] -> outcome: [expected result] -> verify: [test/check]
```

The plan must include:
- Scope boundaries (what will and will not be changed).
- Verification method (tests, build, lint, runtime check, or reproducible evidence).

## 4. Smallest Safe Solution Ladder

**Choose the simplest solution that fully preserves required behavior, clarity, and safety.**

Before choosing a rung, understand the requested outcome and inspect the code and configuration that govern it. For shared behavior or a bug fix, trace the real behavior flow and relevant callers first. Prefer correcting the shared owner or root cause over duplicating guards in callers when that owner is the right architectural boundary.

Evaluate these rungs in order and stop at the first one that fully holds:

1. **Confirm new code is necessary.** Remove speculative work or solve the outcome without code when possible, but do not ignore or renegotiate an explicit approved requirement.
2. **Reuse a suitable established implementation.** Prefer an existing helper, type, component, or project pattern that already owns the behavior. Treat a pattern as established when project guidance, tests, or multiple comparable implementations support it rather than a single occurrence.
3. **Use the standard library.** Prefer a well-matched standard-library facility over custom code or another dependency.
4. **Use a native platform capability.** Prefer a suitable browser, operating-system, database, runtime, or framework capability when it is the established layer for the behavior.
5. **Reuse a suitable already-installed dependency.** Use an existing dependency when its current role and contract fit the need; do not broaden its role merely to avoid a direct implementation.
6. **Implement the smallest direct solution.** Add only the behavior needed to satisfy the approved requirements, without speculative flexibility or scaffolding.

Every rung must satisfy the approved requirements and project conventions, including applicable correctness, security, compatibility, accessibility, migration, and operational constraints. When project guidance is silent or ambiguous, prefer idiomatic language, framework, and project-type patterns. Do not reuse a local implementation when it creates a concrete risk in those constraints; surface the tradeoff and move to the next safe rung.

- No features beyond the request.
- Introduce an abstraction when it owns a meaningful invariant, defines a reusable boundary, improves testability, or makes an important contract clearer.
- Do not extract a helper, wrapper, or new type solely to name a one-off intermediate value or make the implementation appear smaller.
- For a small aggregation used only within a narrow internal scope, prefer an existing type-safe tuple such as `Pair` or `Triple` over a dedicated record or class when each element's role is clear at construction and use sites and the grouping carries no meaningful invariant or behavior. A few local uses do not by themselves justify a new type.
- Introduce a named type when it materially improves clarity or safety, such as by naming ambiguous slots, enforcing meaningful invariants, owning related behavior, or expressing a domain or public API contract. Judge by meaning and scope, not a fixed usage count or distinct static types alone. Do not add a tuple dependency or weaken type safety merely to avoid defining a type.
- No speculative flexibility/configurability.
- No unnecessary error handling for impossible scenarios.

### State Changes and Phase Boundaries

- A method may coordinate multiple phases when they serve one cohesive intention. Before changing state, identify failure points, the first mutation, and the state that remains after each possible failure.
- Where appropriate, prefer input validation -> compute -> validate result -> apply -> return. Compute a pure change proposal before applying it when that makes rejection paths and state guarantees clearer; do not force this structure onto flows whose established contracts require another order.
- Extract helpers for a distinct intention, useful test boundary, entangled intermediate values, or meaningful responsibility, not merely line count. Keep cohesive short flows direct; do not create tiny helpers solely to label each phase.
- A state-changing command may return a receipt or result. Make mutation explicit in its name and contract; do not hide state changes inside query-like functions.

### Boolean Decision Readability

- Treat four or more condition terms, mixed `&&`/`||`, or nested negation as attention triggers, not numeric prohibitions. Judge whether distinct policies, exceptions, or state checks obscure the decision structure; when they do, restructure by meaning rather than merely wrapping lines.
- Prefer intent-revealing local predicates or a domain helper at a meaningful boundary. Naming a meaningful local predicate is allowed; extracting a helper still needs a distinct intention or contract beyond naming a one-off value. Do not hide the entire tangled expression behind a helper, use generic names, split every term, or introduce classes, frameworks, or speculative abstractions.
- Preserve observable short-circuit behavior, side effects, exceptions, and null guards: retain evaluation order, count, and skipped evaluations for side effects, potentially throwing expressions or getters, and guarded access. Eager grouping into local predicates is allowed only when verified pure, total (cannot throw), and safe under the original guards. Do not eagerly precompute unsafe terms or replace lazy conditions with arrays that eagerly evaluate them; use guarded branches or lazy helpers where needed.
- Keep clear homogeneous enum/value comparisons and simple ranges direct when their meaning is already evident. Use membership checks only when an established idiomatic equivalent preserves semantics; do not add a dependency for this purpose.

### Validation Ownership

- Follow one invariant, one owner, one check. One invariant is enforced at one
  ownership point. A second check for the same condition needs a named bypass
  path, not "just in case". Extra guards hide the real owner and force
  coordinated edits when the rule changes.
- Identify the current boundary and the invariants the changed code must uphold.
  Validate actual untrusted inputs where they enter the system or where a new
  trust boundary requires it; keep each check close to the owner of that
  invariant rather than scattering equivalent guards through callers.
- Trust verified upstream guarantees instead of rechecking them:
  - Values read from a DAO/repository within constraints already enforced by
    schema, persistence contract, or a checked persistence operation are assumed
    valid for those conditions. Do not revalidate the same condition downstream.
  - Facts guaranteed by a verified upstream contract (enforced type or checked
    constructor/factory, entry-boundary validation, tests proving rejection,
    and no bypass caller) must not be rechecked downstream for the same condition.
  - Verify the guarantee in implementation and tests or an explicit enforced
    contract, not from a method name or an assumption that callers behave well.
    A suggestive name such as `Validated*` without checks proves nothing.
- Retain or add validation only with a named bypass path: a second caller or
  entry point, retry queue, older producer, nullable or legacy schema, or an
  upstream layer that can fail to uphold the guarantee. Cover that path with a
  focused test. Avoid defensive checks for states the verified contract makes
  impossible.
- Distinguish request applicability from invariant protection: a valid request
  may still produce an invalid next state through computation, overflow, or
  concurrent changes. Let the state owner enforce its transition invariants
  without repeating input facts already guaranteed upstream.
- Allow repeated checks only when each check owns a distinct threat: security
  and authorization boundaries, untrusted parsing, money and state integrity,
  or a post-commit external effect with its own failure contract. Name the
  distinct threat in a comment or plan when keeping such checks.

### Naming

- Use the project's domain vocabulary for types, methods, fields, and local variables. Choose names that make their role and meaning clear in context; do not shorten names into cryptic abbreviations merely to reduce line length.
- Keep names concise when meaning remains clear, but allow longer names when needed to distinguish domain concepts or ownership. Follow established naming conventions unless they obscure intent or conflict with explicit requirements.

### Comments and Code Documentation

- Prefer clear naming and structure, but add comments when they preserve information that is not evident from the code itself, such as intent, tradeoffs, invariants, ordering constraints, lifecycle rules, ownership, units, or valid state relationships.
- When a method coordinates multiple non-trivial phases, add a brief comment before each meaningful phase to explain its role in the overall flow. Describe why the phase exists or what invariant it establishes rather than narrating individual statements.
- For a newly written or directly modified method or function of 30 lines or more, add concise numbered step comments (`Step 1`, `Step 2`, ...) before its meaningful phases so the overall flow is easy to follow. Explain each phase's purpose or invariant rather than restating its statements; do not invent artificial phases solely to add comments. Keep numbering and comments synchronized with implementation changes. For shorter methods, use numbered steps only when execution order or branch relationships need explanation.
- Add concise comments above fields or field groups when they clarify lifecycle, ownership, semantics, constraints, or conceptual grouping that names and types cannot express clearly.
- Do not comment every field, restate identifiers, describe obvious operations, or use comments to compensate for unclear naming or avoidable structural complexity.
- For public APIs, prefer the language's standard documentation format. Use regular comments for private implementation details and local phase boundaries.
- Update or remove comments and code documentation whenever the behavior, ordering, or invariant they describe changes.

Prefer the solution whose behavior is complete, intent is easiest to follow, and safety properties are explicit. Simplify incidental structure only when those qualities remain at least as strong.

The solution-ladder concept is adapted in independent wording from [Ponytail](https://github.com/DietrichGebert/ponytail/blob/main/skills/ponytail/SKILL.md), available under the [MIT License](https://github.com/DietrichGebert/ponytail/blob/main/LICENSE).

## 5. Surgical Changes

**Touch only what is required. Clean up only what your change makes unnecessary.**

When editing existing code:
- Do not refactor unrelated areas.
- Do not change adjacent formatting/comments without a direct reason.
- Readability-preserving whitespace in newly written or directly modified code is a valid direct reason.
- Match existing style and architecture conventions.
- If unrelated issues are noticed, report them instead of fixing without request.

When your changes create orphans:
- Remove imports/variables/functions made unused by your change.
- Do not remove pre-existing dead code unless requested.

### Keep Invariants Close to Their Owner

- Place rules that must remain true across a state transition close to the established owner of that state while following the project's architecture.
- Prefer one intention-revealing atomic operation over requiring callers to coordinate several partial mutations.
- A name such as `applyChange` does not prove atomicity. Changes spanning multiple owners need a real transaction or equivalent atomic mechanism when all-or-nothing behavior is required, with locks or version checks when concurrent changes can invalidate the decision. Do not assume separate databases or external systems share one transaction; preserve established failure contracts and make partial-failure handling explicit.
- Keep I/O and cross-component orchestration in established coordination boundaries. For rules spanning multiple owners, do not force the rule into one owner or duplicate it across callers.
- Consider language and framework conventions for lifecycle, transactions, and immutability, but do not introduce a new abstraction merely to relocate trivial logic.

Every changed line must be traceable to the approved plan.

## 6. Readable Code Layout

**Use one blank line to make declaration boundaries, field groups, member boundaries, scope changes, and meaningful logical phases visible. Do not sacrifice this separation to minimize line count or imitate dense neighboring code. Verify the result directly before completion.**

When writing or directly modifying code:
- Separate field declarations with blank lines by default, especially when their responsibilities differ. Keep closely related fields together when an established project convention treats them as a clear conceptual group; always separate distinct field groups with a blank line.
- Put a blank line between distinct member declarations, including fields or field groups, constructors, and methods, unless an explicit project formatting rule requires otherwise.
- Within methods and functions, put blank lines between distinct phases, such as setup, validation, transformation, persistence, side effects, and result construction or return. Even short methods can benefit from a visible phase boundary.
- Put a blank line before a new standalone control-flow block (`if`, `switch`, loop, `try`) when it follows a different statement or phase, and after that block when the next statement starts a distinct operation. Separate consecutive independent branches or blocks; do not insert a blank line between syntactically joined clauses such as `} else {`, `} catch {`, or `} finally {`.
- Inside each branch, loop, or nested scope, separate setup, decisions, side effects, and return paths when they are distinct steps. A change of scope or responsibility should be visible even when the surrounding code is short.
- Keep statements that perform one cohesive operation together. Do not insert a blank line after every statement or split a tightly coupled expression.
- Keep annotations, documentation, and explanatory comments attached to the declaration or code group they describe. Place a separating blank line before the attached comment, not between it and its code.
- Do not compress distinct logical groups to minimize line count or diff size. A short method can still need blank lines.
- Respect explicit project formatting rules and enforced formatter behavior when they constrain spacing. Otherwise, prefer meaningful separation over nearby dense layout; a single compact neighbor does not override the default.
- Apply these rules to newly written or directly modified code without reformatting unrelated areas.

## 7. Verification-Driven Execution

**Define success criteria, then verify with evidence.**

Examples:
- "Fix bug" -> reproduce with test/check, implement fix, confirm reproduction no longer fails.
- "Add validation" -> add failing cases first (when applicable), then make them pass.
- "Refactor" -> preserve behavior and confirm with relevant tests/checks.

### Choose Precise Verification Targets

- Start with the narrowest deterministic test or check that covers the changed behavior, using the project's standard verification tools.
- Prefer a specific named test target or case over a broad wildcard when the affected target is known.
- Broaden verification when the change has wider impact, the precise scope is uncertain, or a project final gate requires it.
- Do not classify an unrelated failure from a broad verification scope as a patch defect until its relationship to the change is established.
- Record required verification that could not run and explain the substitute evidence.
- For state-changing flows, verify the intended state guarantees on input rejection, computed-result rejection, and application failure. Cover multi-target partial failure and concurrent conflicts when applicable. Distinguish precommit failure from receipt construction or notification failure after commit; do not promise unchanged state for every failure when the established contract permits a committed or partial change.

Before declaring completion:
- Directly inspect newly written and modified code for blank-line separation between declarations, established field groups, members, scope or control-flow block boundaries, and meaningful phases within branches. Add missing separation and remove excessive spacing within the changed scope. Formatter or linter success alone does not establish readable logical grouping.
- Check newly written or directly modified methods and functions of 30 lines or more for numbered step comments at meaningful phase boundaries, and ensure the comments still match the code's flow.
- Directly inspect changed Boolean decisions for obscured policy structure, using the attention triggers above without enforcing a term-count limit. Confirm that any restructuring exposes meaningful decisions and preserves short-circuit evaluation and observable behavior; line wrapping or hiding the chain alone is not a fix.

At completion, provide:
- What changed and why.
- Files touched.
- Verification evidence (executed tests/commands or clear reason if not run).
- Known limitations or follow-up risks.

### Conditional Review Handoff

Only when review is requested or delegated, prepare a compact handoff using the reviewer's existing input fields:

- `repository_root`, `subject`, and `scope`: identify the repository, exact review target and comparison basis, and included and excluded paths or components.
- `authoritative_context`: record binding acceptance criteria, active approved decisions, applicable project rules, and ownership, public API, migration, and excluded-scope constraints. Mark superseded decisions as inactive. Keep implementer rationale and unverified claims separately labeled and non-binding; include only important alternative choices and reasons, not reasoning history.
- `required_lenses`: carry the caller's required risk lenses and propose any additional risk-relevant lens explicitly rather than silently broadening review.
- `expected_subject_identity`: include observed refs, commit IDs, or a reproducible working-tree basis when target drift matters; never invent hashes or evidence.
- `prior_findings`: on re-review, retain stable finding IDs and map each disposition, fix, and regression check to those IDs and the current subject.

Include verification commands, results, and gaps as labeled evidence, separate from binding requirements; identify unexecuted checks and unverified implementer claims. Keep the handoff proportional to scope. This skill does not require review: review timing, independence requirements, and acceptance remain caller-owned. Loading both skills does not establish independent review.

### Responding to Review Findings

Use this procedure only when asked or authorized to address findings; an advisory report is not permission to edit.

1. Verify each finding against the current code and binding context. Record an evidence-backed disposition: accept, dispute, or defer; do not treat reviewer recommendations or implementer claims as proven facts.
2. Fix accepted findings within the approved plan. If no approved plan covers the fixes, propose one and obtain agreement before implementation; seek renewed agreement for material scope or risk changes. Do not fix disputed or deferred findings without authorization.
3. Record the change and verification evidence, or the dispute or deferral reason, under the original stable ID. If re-review is requested, pass these dispositions and ID-to-fix/test mappings in `prior_findings` with the current subject and verification gaps.

Do not start automatic repair or re-review loops, claim an approval verdict, or infer caller acceptance from finding resolution.

## 8. Clarification Rules

Ask clarification questions only when truly necessary:
- Ambiguity that materially changes implementation.
- Destructive/irreversible actions.
- Security/billing/production-impact decisions.
- Missing credentials or external values that cannot be inferred.

Otherwise, proceed using the approved plan.
