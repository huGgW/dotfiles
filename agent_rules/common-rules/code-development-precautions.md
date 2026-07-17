# Code Development Policy
Unified execution and precaution rules for coding agents.

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

## 4. Simplicity First

**Implement the minimum change that solves the requested problem.**

- No features beyond the request.
- Start with established project conventions, types, architecture, and recurring collaboration patterns. Treat a pattern as established when it is supported by project guidance, tests, or multiple comparable implementations rather than a single occurrence.
- When project guidance is silent or ambiguous, prefer idiomatic language, framework, and project-type patterns and direct implementations using existing types, language features, or standard-library facilities.
- Do not repeat a local pattern when it creates a concrete correctness, security, compatibility, or maintainability risk. Surface the tradeoff and choose the smallest safe change.
- Introduce an abstraction when it owns a meaningful invariant, defines a reusable boundary, improves testability, or makes an important contract clearer.
- Do not extract a helper, wrapper, or new type solely to name a one-off intermediate value or reduce line count.
- No speculative flexibility/configurability.
- No unnecessary error handling for impossible scenarios.
- Use comments and code documentation to explain non-obvious intent, tradeoffs, invariants, constraints, or meaningful phases in complex logic.
- Prefer clear naming and structure first. Add brief step-level comments when a complex sequence remains difficult to follow, but do not narrate obvious statements or repeat declarations.
- Update or remove comments and code documentation when the behavior they describe changes.

If 200 lines can be 50 with equal clarity and safety, simplify.

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
