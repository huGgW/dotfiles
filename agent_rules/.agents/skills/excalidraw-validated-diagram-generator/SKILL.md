---
name: excalidraw-validated-diagram-generator
description: Generate validated Excalidraw diagrams and PNG exports from natural language descriptions. Use whenever the user asks to create, draw, visualize, diagram, make a flowchart, create an architecture diagram, generate an Excalidraw file, or export/validate a diagram as PNG. This skill combines canonical Excalidraw starter scenes with a mandatory render-read-fix validation loop.
---

# Excalidraw Validated Diagram Generator

Create a focused diagram from a canonical Excalidraw template, render it, inspect the rendered image, and fix visible defects before delivery.

## Output Contract

Produce exactly these two deliverables unless the user explicitly requests otherwise:

1. One `.excalidraw` source file.
2. One `.png` rendered from that source file.

Do not claim validation is complete until the final PNG has been read with the image-capable Read tool.

## Workflow

### 1. Select The Diagram Type

Read `templates/catalog.json` first. It is authoritative for available IDs, primary questions, semantics, limits, styles, and file paths. Route the request by its primary question, then use `references/template-selection.md` to choose exactly one of the 36 catalog IDs.

| Primary-question family | Candidate catalog IDs |
| --- | --- |
| System structure, runtime placement, or connections | `architecture`, `deployment`, `relationship` |
| Data movement or weighted flow | `data-flow`, `sankey`, `medallion` |
| Process, ownership, lifecycle, or recurrence | `flowchart`, `process`, `business-flow-swimlane`, `state`, `loop` |
| Software or data model | `class-diagram`, `er-diagram`, `db-schema` |
| Hierarchy, containment, grouping, or overlap | `mind-map`, `org-chart`, `nested`, `layers`, `pyramid`, `treemap`, `venn` |
| Time, interaction order, work, or experience | `sequence-diagram`, `timeline`, `gantt`, `kanban`, `journey`, `story-map` |
| Quantitative comparison or matrix | `bar`, `line`, `scatter`, `quadrant`, `radar`, `polar`, `dp-security-matrix` |
| Cause, strategy, or evolution | `fishbone`, `wardley` |

Treat these absorbed upstream names as aliases, not additional catalog IDs: `it-state` -> `architecture`, `tree` -> `mind-map`, `high-level` -> `architecture`, `dp-integration` -> `data-flow`, and `dependency` -> `relationship`.

If two types remain plausible and the choice would materially change the meaning, ask one concise question. Otherwise choose the type whose `primaryQuestion` best matches the user's main question.

### 2. Select The Style And Template

After selecting the catalog ID:

1. Find that exact entry in `templates/catalog.json`.
2. Apply the user's requested style when the catalog supports it; otherwise use `defaultStyle`.
3. Read only the selected `templateFile`, not every template.
4. Read only the relevant reference sections and the JSON element guidance needed for the edit.

The selected template is the canonical starter scene. Copy and adapt that scene rather than treating it as a loose layout hint or rebuilding from a blank file. Do not load every template or preview for comparison.

### 3. Extract Type-Specific Semantics

Use the selected catalog entry's `semanticMinimums`, `limits`, and canonical scene as the contract. Consult only that type's row in `references/template-selection.md`; when maintaining a canonical template, also consult its row in `references/template-authoring.md`.

Preserve every required semantic role, including labels or notation that distinguish the selected type from its nearest confusable types. Do not invent unsupported system facts. Use a short visible assumption only when proceeding without clarification is safe.

### 4. Adapt The Canonical Scene

Preserve the selected template's type grammar and replace its placeholders with the requested content. Add or remove elements only as needed to express the request within the catalog budgets.

Apply these rules:

- Use a 4 px grid rhythm and one dominant layout axis.
- Stay within the selected entry's `nodeBudget` and `edgeBudget`. Split overview and detail into separate requested diagrams when the content exceeds a budget; do not create one unreadable scene.
- Use a plain white (`#ffffff`) canvas with no tinted background.
- Use one accent color by default and at most two. Keep ordinary elements muted, external systems blue, and the focal path or node orange.
- Use no shadows. Use an independent Excalidraw palette; do not copy upstream CSS values.
- Render every label as a separate `text` element with `fontFamily: 5` and `fontSize >= 16`.
- Use the 16/20/28 type hierarchy for annotations, labels or section headings, and the title.
- Give directional connectors explicit arrowheads. Use dashed connectors for asynchronous or return flows.
- Route off-axis connectors orthogonally. Keep fan-out anchors at least 12 px apart.
- Put connectors before nodes in element z-order so nodes visually cover connector ends.
- Do not route a connector through a non-endpoint node. Keep at least 8 px between connector labels and nearby shapes or lines.

Read `references/excalidraw-schema.md` when creating or changing raw JSON and `references/element-types.md` for element-specific fields and semantics. Read the full `references/template-authoring.md` only when the task is to create or maintain canonical templates.

### 5. Render, Read, And Fix

Render with the bundled renderer:

```bash
cd ~/.agents/skills/excalidraw-validated-diagram-generator/references
uv run python render_excalidraw.py <path-to-file.excalidraw> --output <path-to-file.png>
```

If dependencies are missing:

```bash
cd ~/.agents/skills/excalidraw-validated-diagram-generator/references
uv sync
uv run playwright install chromium
```

Read the PNG with the Read tool and check:

- text clipping, unreadable text, or weak hierarchy;
- unintended overlaps or connectors crossing non-endpoint nodes;
- incorrect arrow targets, arrowheads, or ambiguous labels;
- broken type-specific semantics such as missing decision labels, lifelines, keys, or cardinality;
- cramped regions, excessive empty space, or a lost dominant axis.

When a defect exists, edit the `.excalidraw` file, re-render, and read the new PNG. Repeat until the final render has no obvious defect. The last image read must correspond to the final source.

## Existing Diagram Validation

For an existing `.excalidraw` file:

1. Render and read it before editing.
2. Preserve its intent and structure unless the user asks for a redesign.
3. Apply fixes only when requested or clearly included in the task.
4. Re-render and re-read after every edit.

## Final Response

Report:

1. `.excalidraw` path.
2. `.png` path.
3. Selected catalog ID and style.
4. One-sentence content summary.
5. Confirmation that the final PNG was rendered and inspected.

Do not report intermediate renders as deliverables.
