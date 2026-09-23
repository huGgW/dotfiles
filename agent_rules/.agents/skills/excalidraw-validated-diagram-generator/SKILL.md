---
name: excalidraw-validated-diagram-generator
description: Generate validated Excalidraw diagrams and PNG exports from natural language descriptions. Use whenever the user asks to create, draw, visualize, diagram, make a flowchart, create an architecture diagram, generate an Excalidraw file, or export/validate a diagram as PNG. This skill combines canonical Excalidraw starter scenes with a mandatory render-read-fix validation loop.
---

# Excalidraw Validated Diagram Generator

Create a focused diagram from a canonical Excalidraw template, render it, inspect the rendered image, and fix visual and comprehension defects before delivery.

## Output Contract

Produce one matching source/render pair per resulting diagram unless the user explicitly requests otherwise:

1. One `.excalidraw` source file.
2. One `.png` rendered from that source file.

When the content must be split, define each diagram's primary question, exactly one catalog ID, and target display profile, then produce a matching `.excalidraw` and `.png` pair for every diagram. Keep vocabulary, semantic colors, and component names consistent across the set.

Do not claim validation is complete until the final PNG has been read with the image-capable Read tool.

## Workflow

### 1. Write The Visual Brief

Before selecting a template or editing a scene, translate the request into the compact visual brief defined in `references/visual-brief-and-comprehension.md`. It must cover the primary reader question, entities, relationships, stages, split and merge points, state/store ownership, keys and identifiers, boundaries, warnings or non-guarantees, omissions, and target display size.

One diagram owns one primary question. Split overview, partition/routing, idempotency, and atomicity questions when combining them would make any answer ambiguous or unreadable. Never shrink text to fit a content budget.

### 2. Select The Diagram Type

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

### 3. Select The Style And Template

After selecting the catalog ID:

1. Find that exact entry in `templates/catalog.json`.
2. Apply the user's requested style when the catalog supports it; otherwise use `defaultStyle`.
3. Read only the selected `templateFile`, not every template.
4. Read only the relevant reference sections and the JSON element guidance needed for the edit.

The selected template is the canonical starter scene. Use this exact model:

> Template = semantic grammar + style tokens + starter components  
> Template != fixed coordinates + fixed box count + fixed card layout

Default to adapting the selected template. Recompose from its grammar only when the visual brief provides evidence that the content structure does not fit the starter coordinates or component arrangement. Accuracy and the reader's primary question win over fixed coordinates, but recomposition is not permission for arbitrary blank-canvas drawing. Do not load every template or preview for comparison.

### 4. Extract Type-Specific Semantics

Use the selected catalog entry's `semanticMinimums`, `limits`, and canonical scene as the contract. Consult only that type's row in `references/template-selection.md`; when maintaining a canonical template, also consult its row in `references/template-authoring.md`.

Preserve every required semantic role, including labels or notation that distinguish the selected type from its nearest confusable types. Do not invent unsupported system facts. Use a short visible assumption only when proceeding without clarification is safe.

### 5. Adapt The Canonical Scene

Preserve the selected template's type grammar and replace its placeholders with the requested content. Add or remove elements only as needed to express the request within the catalog budgets.

Apply these rules:

- Use an optional 4 px coordinate rhythm and one dominant layout axis; preserve canonical `appState.gridSize: 20`.
- Stay within the selected entry's `nodeBudget` and `edgeBudget`. Split overview and detail into separate requested diagrams when the content exceeds a budget; do not create one unreadable scene.
- Use a plain white (`#ffffff`) canvas with no tinted background.
- Use color for semantic roles, not importance. For complex flows, distinguish transport/routing, business identity, state/merge, and warning/boundary roles with combinations of color, labels, shapes, and line treatments; these roles do not require four unique hues. Keep outer cards neutral when internal chips carry the semantics, preserve the restrained maximum-two-accent budget, and add redundant labels or shapes so meaning survives grayscale.
- Use no shadows. Use an independent Excalidraw palette; do not copy upstream CSS values.
- Render every label as a separate `text` element with `fontFamily: 5` and `fontSize >= 16`.
- Use the 16/20/28 type hierarchy for annotations, labels or section headings, and the title.
- Fit labels to their shapes before routing connectors. Keep at least 16 px of horizontal and 12 px of vertical padding inside rectangles, and use a smaller centered safe area inside ellipses and diamonds.
- Insert explicit semantic line breaks when a shape label does not fit comfortably on one line. Break at word or phrase boundaries, keep identifiers and short code tokens intact, and prefer balanced lines. Keep ordinary node labels to one or two lines; use three only in content-heavy cards or cells with enough height.
- For manually wrapped shape labels, put the same explicit `\n` characters in `text` and `originalText`, use `autoResize: false` and `lineHeight: 1.25`, recompute the text box, and center it in the shape.
- If a label still does not fit its safe area, shorten it without losing meaning, enlarge the shape and reflow nearby elements, or split the diagram. Never reduce the font below the 16/20/28 hierarchy to make text fit.
- Give directional connectors explicit arrowheads. Keep the default path or call solid. Async, return, and fallback connectors may be dashed, so distinguish them redundantly: add `ASYNC`; add `RETURN` when sequence context is not already unambiguous; and add the fallback condition, `FALLBACK`, and warning treatment.
- Route off-axis connectors orthogonally. Keep fan-out anchors at least 12 px apart.
- Put connectors before nodes in element z-order so nodes visually cover connector ends.
- Do not route a connector through a non-endpoint node. Keep at least 8 px between connector labels and nearby shapes or lines.

Read `references/excalidraw-schema.md` when creating or changing raw JSON and `references/element-types.md` for element-specific fields and semantics. Read the full `references/template-authoring.md` only when the task is to create or maintain canonical templates.

For staged pipelines or event flows, encode meaning as geometry rather than prose: numbered grouped stages, independent component nodes, owned state/store inside or adjacent to its owner, true fan-out and fan-in, routing and business-ID chips, cursor/checkpoint markers, transaction zones, and warning strips where applicable. Long prose cannot substitute for these relationships. Use technology badges only when they clarify responsibility; otherwise use text or a generic badge, and use role badges for internal components. Use a verified official asset only when its provenance is known.

Audit the taxonomy before rendering: identifier role count and duplicate-defense point count are different axes and need not match; a routing key is not an idempotency key; and the title, legend, and cards must each say exactly what they count.

### 6. Run The Visual And Comprehension Loop

Treat the first render as a draft, not as a deliverable. Use this loop after adapting the canonical scene:

1. Render the current `.excalidraw` source to PNG.
2. Read the PNG with the image-capable Read tool.
3. Inspect the rendered image in this order:
   - shape labels that are clipped, overflow their safe area, lack consistent padding, use awkward line breaks, or become unreadable at whole-diagram scale;
   - overlapping labels, shapes, connectors, or decorations;
   - connectors crossing non-endpoint nodes, wrong arrow targets, or ambiguous labels;
   - inconsistent alignment, spacing, hierarchy, or excessive empty space;
   - broken type-specific semantics such as missing decision labels, lifelines, keys, or cardinality;
   - whether the target display size supports a whole-image overview and readable details without zoom, or uses an explicit detail-view strategy;
   - every comprehension question derived from the user's prompt.
4. If any defect exists, fix the `.excalidraw` source. Correct all obvious defects found in that pass together rather than making one render per defect. Do not patch or post-process the PNG.
5. Re-render to the intended final PNG path and read that PNG again.

Repeat steps 3-5 until the latest render has no obvious visual, semantic, legibility, or comprehension defect. Legibility is not comprehension: if any mandatory reader question is difficult to answer from the image, the diagram cannot receive a visual PASS. A large source PNG or `fontSize >= 16` alone is insufficient. If target-size detail fails, simplify, split, or omit nonessential prose; move supporting prose to companion documentation only when the user explicitly requested or allowed it. The loop is complete only after reading both the temporary target-size validation raster and the original final PNG rendered from the final source; never infer visual correctness from JSON alone. Follow `references/visual-brief-and-comprehension.md` for target-size profiles, raster procedure, and the pass gate.

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

## Existing Diagram Validation

For an existing `.excalidraw` file:

1. Render and read it before editing.
2. Preserve its intent and structure unless the user asks for a redesign.
3. Apply fixes only when requested or clearly included in the task.
4. After editing, run the same visual correction loop before delivery.

## Final Response

Report:

For each resulting diagram, report:

1. `.excalidraw` source path and matching `.png` path.
2. Selected catalog ID and style.
3. Primary reader question.
4. Target display profile.
5. One-sentence content summary and confirmation that the target-size raster and original final PNG were inspected and passed the comprehension questions.

Do not report intermediate renders as deliverables.
