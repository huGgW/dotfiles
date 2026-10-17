---
name: visual-first-explanation
description: >
  How to explain or discuss a design, plan, architecture, or technical decision
  by showing first with visuals and examples. Use this skill whenever the user
  asks to explain, discuss, compare, or review a design, plan, structure, flow,
  model, contract, or trade-off with Mermaid diagrams, tables, snippets, or
  concrete examples instead of long prose. Triggers include "설계 설명",
  "계획 설명", "구조 설명", "그림으로 보여줘", "mermaid로", "표로 정리",
  "snippet으로", "예시로 보여줘", "줄글 없이", "핵심만", "간결하게 설명",
  "explain the design", "show the structure", "visual explanation",
  "explain with diagram", "compare options visually". Always consult this skill
  before drafting a design or plan explanation, even when the user does not name
  a format.
---

# Visual-First Explanation

Explain by showing first, then use words only for what the visual cannot carry.
The reader should grasp the structure from the visual or example alone, and use
the surrounding text only to resolve ambiguity or record a judgment.

## Use when

- Explaining or discussing a design, plan, architecture, flow, model, contract,
  or technical trade-off.
- Comparing candidate directions where a diagram, table, or snippet carries the
  difference better than paragraphs.
- The user asks for a compact, visual, example-led style, or for less prose.

## Do not use when

- Writing a final standalone document (use `document-writer` instead).
- Managing a multi-phase design tree, agenda order, or consensus gates
  (use `project-architect` instead).
- Doing research-only investigation without an explanation output
  (use deep research instead).

## Core principle

Show the shape before describing it in words. Prefer a diagram for flows and
relationships, a table for comparisons over shared dimensions, a snippet for
behavior and contracts, and a concrete example for abstract ideas. Never repeat
the same fact in two representations without adding distinct value. If removing
the prose loses no understanding, remove the prose. If removing the visual loses
no understanding, remove the visual.

## How to choose the representation

Decide what the reader must see, then pick the form that carries it with the
least effort:

| Reader need | Prefer |
|---|---|
| Order, flow, state change, relationship, boundary | Mermaid diagram |
| Options sharing the same evaluation dimensions | Comparison table |
| Behavior, contract, shape of data or API | Short snippet in the real language |
| Abstract rule or principle | Single concrete scenario |

Use only the representations that answer the current question. Leave the rest
parked for a later turn.

## Conversation shapes

Two modes share the same representation rules and differ only in how they close.

### Explanation mode (one-shot)

Used when the user asks what something is or how it works.

```markdown
**Conclusion:** {judgment or key fact, stated directly}
{visual, table, snippet, or example that carries the structure}
**Why:** {points the visual cannot show — reason, constraint, trade-off}
**Takeaway:** {sentence directly under the visual stating what to see}
```

Close with the takeaway. Do not append a question when no decision is pending.

### Discussion mode (back-and-forth)

Used when the user is weighing directions or refining a plan together with you.

```markdown
**Conclusion:** {current reading of the item under discussion}
{visual, table, snippet, or example for this item only}
**Why:** {what supports or blocks it}
**Next (only when needed):** {confirmation or choice required to proceed}
```

Ask only for what blocks the current decision. Do not ask ahead for items the
conversation has not reached. When nothing blocks progress, close with the
takeaway as in explanation mode.

## Visual rules

- Give each visual a single responsibility. When a visual starts answering a
  second question, split the turn instead of stuffing more into the same visual.
- Keep labels concrete and tied to the system under discussion. Avoid generic
  nodes that could belong to any system.
- Place the takeaway directly beside the visual so the reader knows what to see
  without hunting through surrounding text.
- Prefer the smallest visual that preserves the decision-relevant difference.
  A focused fragment beats a complete map when the question is narrow.
- Do not decorate. Remove any element whose removal loses no understanding.
- Keep internal paths, draft IDs, and process metadata out of labels, captions,
  and alt text.

## Snippet and example rules

- Write snippets in the real language with its normal tag, and fold what the
  current question does not need.
- Show the shape, not the implementation. The snippet proves the contract or
  behavior; surrounding text carries the rationale.
- Ground abstract claims in a single runnable or traceable scenario rather than
  a general definition.
- Mark what is verified, what is illustrative, and what remains open. Never
  present an invented field, endpoint, or behavior as observed fact.

## Density without loss

- Cut openings, closings, compliments, and restatements of the request.
- Keep terms in the user's language. Keep code, identifiers, commands, and
  proper nouns in English.
- Define an unavoidable technical term on first use, then reuse it consistently.
- When a sentence grows hard to follow, clarify first, then split claims while
  keeping their causal link visible.

## Anti-patterns to catch

- Explaining a flow purely in paragraphs when a diagram would carry it.
- Showing a diagram and then narrating it node by node in prose.
- Comparing options in separate paragraphs instead of a shared-dimension table.
- Pasting a long snippet and then describing every line in words.
- Adding a visual that repeats nearby text without answering a distinct question.
- Closing every response with a question even when the explanation is complete.
- Stuffing sibling topics into one response to avoid a second turn.

## Additional resources

- **`references/visual-guide.md`** — Selection heuristics and before/after
  pairs for diagram, table, snippet, and example. Read when unsure which form
  fits or when a draft feels dense but the cause is unclear.
