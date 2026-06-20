---
name: excalidraw-validated-diagram-generator
description: Generate validated Excalidraw diagrams and PNG exports from natural language descriptions. Use whenever the user asks to create, draw, visualize, diagram, make a flowchart, create an architecture diagram, generate an Excalidraw file, or export/validate a diagram as PNG. This skill combines generator-style Excalidraw JSON creation with a mandatory render-view-fix validation loop.
---

# Excalidraw Validated Diagram Generator

Generate `.excalidraw` JSON files from natural language descriptions, then render them to PNG and visually validate the result before delivery.

This skill intentionally combines two concerns:

1. Diagram generation follows the `excalidraw-diagram-generator` rules.
2. PNG export and visual validation follow the render-view-fix loop from `excalidraw-diagram`.

When these concerns conflict, generation rules win. In particular, keep `fontFamily: 5` for text elements unless the user explicitly asks for another font.

## Use This Skill When

Use this skill when the user asks for any of these outcomes:

- Create an Excalidraw diagram.
- Generate a `.excalidraw` file.
- Make a flowchart, workflow, relationship diagram, mind map, architecture diagram, data-flow diagram, swimlane, class diagram, sequence diagram, or ER diagram.
- Visualize a process, system, concept, dependency graph, or data model.
- Export an Excalidraw diagram to PNG.
- Validate a generated or existing Excalidraw diagram visually.

If the user only asks to inspect text or explain a concept without producing a diagram file, do not use this skill.

## Core Rule

Always produce both files unless the user explicitly opts out:

1. A `.excalidraw` file.
2. A rendered `.png` file generated from that `.excalidraw` file.

Do not claim visual validation is complete until you have rendered the PNG and viewed it with the Read tool.

## Workflow

### Step 1: Understand The Request

Identify:

1. Diagram type.
2. Key elements.
3. Relationships or flow.
4. Required level of detail.
5. Whether icons, templates, or an existing `.excalidraw` file are involved.

If essential information is missing and the diagram would be materially wrong without it, ask one concise clarification question. Otherwise, make a reasonable, visible choice and proceed.

### Step 2: Choose The Diagram Type

| User intent | Diagram type | Common signals |
| --- | --- | --- |
| Process, steps, decisions | Flowchart | workflow, process, steps, procedure |
| Entity or component relationships | Relationship diagram | relationship, connection, dependency, structure |
| Concept hierarchy | Mind map | mind map, concepts, ideas, breakdown |
| System components | Architecture diagram | architecture, service, module, infrastructure |
| Data movement | Data flow diagram | data flow, ETL, processing, transformation |
| Actor responsibilities | Business flow / swimlane | swimlane, roles, departments, handoff |
| Object-oriented structure | Class diagram | class, inheritance, interface, OOP |
| Messages over time | Sequence diagram | sequence, interaction, timeline, messages |
| Database model | ER diagram | entity, relationship, schema, data model |

### Step 3: Extract Structured Information

Use the structure that fits the chosen diagram type:

- Flowcharts: start, ordered steps, decision points, end states.
- Relationship diagrams: nodes, relationships, labels, directionality.
- Mind maps: central topic, main branches, sub-topics.
- Architecture diagrams: boundaries, components, protocols, external systems, data flow.
- Data flow diagrams: sources, destinations, processes, data stores, data flows.
- Swimlanes: actors, lanes, activities, handoffs.
- Class diagrams: classes, attributes, methods, inheritance, implementation, association, aggregation, composition, multiplicity.
- Sequence diagrams: actors, lifelines, messages, return values, activation boxes, time order.
- ER diagrams: entities, attributes, primary keys, foreign keys, cardinality, junction entities.

### Step 4: Generate The Excalidraw File

Create valid Excalidraw JSON with this top-level shape:

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://excalidraw.com",
  "elements": [],
  "appState": {
    "viewBackgroundColor": "#ffffff",
    "gridSize": 20
  },
  "files": {}
}
```

Generation requirements:

- Use unique IDs for all elements.
- Use readable text and keep `text` / `originalText` consistent.
- Use `fontFamily: 5` for text elements by default.
- For reliable PNG export, render labels as separate `text` elements. Do not rely only on non-standard `text` fields embedded directly in rectangle, ellipse, or diamond elements; those labels may not appear in exported PNGs. If you use a shape as a visual container, add a matching text element positioned inside or near the shape.
- Use font sizes of at least 16 for readability.
- Keep spacing consistent enough that labels and arrows are readable after PNG export.
- Prefer fewer, clearer elements over dense diagrams.
- Keep typical diagrams under 20 major elements unless the user asks for detail.

Reference files:

- `references/excalidraw-schema.md`: Excalidraw JSON structure.
- `references/element-types.md`: Element type details.
- `templates/*.excalidraw`: Starter templates for common diagram types.

If a reference or template uses older shape-embedded text or a different font family, treat it as a layout hint only. Preserve this skill's generation requirements: separate visible text elements and `fontFamily: 5` by default.

### Step 5: Use Icon Scripts When Helpful

If the user requests cloud, infrastructure, product, or icon-based diagrams, check for available icon libraries under `libraries/` if present. Prefer deterministic scripts over manually loading large icon JSON into context.

Available scripts:

```bash
python scripts/split-excalidraw-library.py <library-directory>
python scripts/add-icon-to-diagram.py <diagram-path> <icon-name> <x> <y> [--label "Text"] [--library-path PATH]
python scripts/add-arrow.py <diagram-path> <from-x> <from-y> <to-x> <to-y> [--label "Text"] [--style solid|dashed|dotted] [--color HEX]
```

Use script paths relative to this skill directory, or use the absolute installed path:

```bash
python ~/.agents/skills/excalidraw-validated-diagram-generator/scripts/add-icon-to-diagram.py <diagram-path> <icon-name> <x> <y> --label "Text"
python ~/.agents/skills/excalidraw-validated-diagram-generator/scripts/add-arrow.py <diagram-path> <from-x> <from-y> <to-x> <to-y> --label "Text"
```

If no icon library is available, create a clear basic-shape diagram and mention that icons can be added later.

### Step 6: Render To PNG

Render the `.excalidraw` file with the bundled renderer:

```bash
cd ~/.agents/skills/excalidraw-validated-diagram-generator/references
uv run python render_excalidraw.py <path-to-file.excalidraw>
```

This writes a PNG next to the `.excalidraw` file by default. To choose the PNG path:

```bash
cd ~/.agents/skills/excalidraw-validated-diagram-generator/references
uv run python render_excalidraw.py <path-to-file.excalidraw> --output <path-to-file.png>
```

First-time setup if rendering fails because dependencies or Chromium are missing:

```bash
cd ~/.agents/skills/excalidraw-validated-diagram-generator/references
uv sync
uv run playwright install chromium
```

### Step 7: View And Validate The PNG

Use the Read tool on the generated PNG. Do not skip this step.

Check for:

- Text clipped by containers.
- Text too small to read.
- Overlapping shapes, labels, or arrows.
- Arrows crossing through important elements.
- Arrows pointing to the wrong target or empty space.
- Labels floating ambiguously.
- Uneven spacing or lopsided composition.
- Large empty voids next to cramped sections.
- Missing relationships that should be shown with arrows or lines.

### Step 8: Fix And Repeat

If you find a visual defect:

1. Edit the `.excalidraw` JSON.
2. Re-render the PNG.
3. Read the new PNG.
4. Repeat until the diagram is good enough to show without caveats.

Typical fixes:

- Increase container width or height.
- Move text or shapes to restore spacing.
- Increase font size.
- Re-route arrows with better points.
- Move arrow labels closer to their arrows.
- Remove unnecessary boxes around text.
- Split a crowded diagram into multiple regions or files if the user asked for a large scope.

Stop only when:

- The JSON is valid and renders successfully.
- The PNG has no obvious clipping, unreadable text, or unintended overlap.
- Arrows and labels communicate the intended relationships.
- The final response can provide both file paths confidently.

## Existing Diagram Validation

If the user provides or points to an existing `.excalidraw` file:

1. Render it to PNG.
2. Read the PNG.
3. Identify visual defects.
4. Edit the JSON only if the user asked you to fix it, or if fixing is clearly part of the task.
5. Re-render and re-read after every edit.
6. Return the final `.excalidraw` and `.png` paths.

Do not rewrite the diagram from scratch unless the file is invalid, unrecoverable, or the user asks for a redesign.

## Output Format

Final responses should include:

1. Created or updated `.excalidraw` path.
2. Rendered `.png` path.
3. Diagram type.
4. Brief summary of what the diagram shows.
5. Validation status, including whether you rendered and viewed the PNG.

Example:

```text
Created: user-registration-flow.excalidraw
Rendered PNG: user-registration-flow.png
Type: Flowchart
Summary: Shows email entry, verification, password setup, and completion.
Validation: Rendered to PNG and inspected; no text clipping or major overlap found.
```

## Quality Checklist

Before delivering:

- [ ] `.excalidraw` file exists.
- [ ] PNG file exists.
- [ ] Render command succeeded.
- [ ] PNG was viewed with the Read tool.
- [ ] Text is readable and not clipped.
- [ ] Important elements do not overlap unintentionally.
- [ ] Arrows connect the intended elements.
- [ ] Layout spacing is balanced enough for the diagram's purpose.
- [ ] Generator rules were preserved, including `fontFamily: 5` by default.
- [ ] Final response includes both file paths.
