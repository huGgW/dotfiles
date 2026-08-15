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

## 1. Think Before Coding

**Do not assume. Do not hide uncertainty. Surface tradeoffs early.**

Before implementation:
- State assumptions explicitly.
- If multiple interpretations exist, present options instead of silently picking one.
- If a simpler approach exists, say so.
- If something is unclear, ask a focused clarification.
- Identify applicable project conventions and relevant language, framework, and project-type guidance before choosing an approach.
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
- No speculative flexibility/configurability.
- No unnecessary error handling for impossible scenarios.

### Comments and Code Documentation

- Prefer clear naming and structure, but add comments when they preserve information that is not evident from the code itself, such as intent, tradeoffs, invariants, ordering constraints, lifecycle rules, ownership, units, or valid state relationships.
- When a method coordinates multiple non-trivial phases, add a brief comment before each meaningful phase to explain its role in the overall flow. Describe why the phase exists or what invariant it establishes rather than narrating individual statements.
- Use numbered step comments only when the execution order or branch relationship is important to understanding the workflow. Keep numbering and comments synchronized with implementation changes.
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
- Keep I/O and cross-component orchestration in established coordination boundaries. For rules spanning multiple owners, do not force the rule into one owner or duplicate it across callers.
- Consider language and framework conventions for lifecycle, transactions, and immutability, but do not introduce a new abstraction merely to relocate trivial logic.

Every changed line must be traceable to the approved plan.

## 6. Readable Code Layout

**Use blank lines intentionally to separate meaningful code groups. Readable spacing is encouraged; compact code is not inherently better.**

When writing or modifying code:
- Group related statements together.
- Prefer inserting blank lines between logical steps when they make the flow easier to scan.
- Insert blank lines between distinct responsibilities, phases, or validation branches.
- Keep setup, validation, transformation, side effects, and return logic visually distinguishable when they are meaningfully separate.
- Do not remove useful blank lines just to make code shorter.
- Do not add decorative spacing that conflicts with the surrounding project style.

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

At completion, provide:
- What changed and why.
- Files touched.
- Verification evidence (executed tests/commands or clear reason if not run).
- Known limitations or follow-up risks.

## 8. Clarification Rules

Ask clarification questions only when truly necessary:
- Ambiguity that materially changes implementation.
- Destructive/irreversible actions.
- Security/billing/production-impact decisions.
- Missing credentials or external values that cannot be inferred.

Otherwise, proceed using the approved plan.
