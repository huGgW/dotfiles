# Template Authoring

Use this reference when creating or maintaining canonical templates and their catalog entries. Normal diagram generation should rely on the selected catalog entry and template rather than loading this full reference.

## Canonical Template Contract

Each template is an editable Excalidraw-native starter scene, not a screenshot or a layout suggestion. It must demonstrate the minimum semantics of its diagram type while remaining easy to replace with user content.

A template must:

- be valid Excalidraw version 2 JSON;
- use plain white (`#ffffff`) for `appState.viewBackgroundColor`;
- align positions and dimensions to a 4 px rhythm;
- establish one dominant axis;
- stay within its catalog `nodeBudget` and `edgeBudget`;
- use separate text elements with `fontFamily: 5` and sizes from 16, 20, and 28;
- fit shape labels inside a centered safe area with consistent padding and semantic line breaks;
- place connectors before nodes in element z-order;
- use explicit arrowheads for directional semantics;
- use dashed lines for asynchronous or return semantics;
- route off-axis connectors orthogonally;
- keep separate fan-out anchors at least 12 px apart;
- keep connectors out of non-endpoint nodes and labels at least 8 px clear;
- use no shadows and no embedded HTML, SVG, icon font, or product logo.

## Visual Grammar

Build an independent Excalidraw palette rather than copying literal CSS values from another project.

Recommended roles:

| Role | Treatment |
| --- | --- |
| Canvas | `#ffffff` |
| Ordinary node | White or very light neutral fill, dark neutral text |
| Ordinary connector | Muted neutral stroke |
| External actor or system | Blue accent |
| Focal node or path | Orange accent |
| Async or return flow | Dashed stroke |

Use one accent unless a second color communicates a distinct semantic role. Never exceed two accent colors.

## Type Contracts

The catalog remains authoritative. Keep each starter scene within both `nodeBudget`/`edgeBudget` and the named `limits` below. The minimum tokens mirror `semanticMinimums`; the authoring guidance states what must be visibly demonstrated.

### System And Flow

| Catalog ID | Semantic minimums | Starter scene must demonstrate | Named limits |
| --- | --- | --- | --- |
| `architecture` | `boundary`, `component`, `external-system`, `connection` | A named boundary, internal components, an external system, and labeled major connections. | `majorNodes: 9`, `edges: 12`, `boundaries: 3` |
| `deployment` | `node`, `artifact`, `connection` | Runtime or environment nodes, deployed artifacts inside them, and network connections. | `majorNodes: 9`, `edges: 12`, `environments: 3` |
| `relationship` | `entity`, `relationship` | Multiple entities and at least one relationship whose label and direction communicate its meaning. | `majorNodes: 8`, `edges: 12` |
| `data-flow` | `external-actor`, `process`, `data-store`, `data-flow` | An external source or sink, a transformation, a persistent store, and named data flows. | `majorNodes: 8`, `edges: 12`, `stores: 4` |
| `sankey` | `flow-band`, `node` | Source, intermediate, or destination nodes connected by variable-width bands whose widths encode quantity. | `majorNodes: 8`, `edges: 12`, `bands: 12` |
| `medallion` | `container`, `content`, `stage` | Distinct bronze, silver, and gold refinement stages with content and directional progression. | `majorNodes: 4`, `edges: 3`, `bands: 4` |

### Process And Lifecycle

| Catalog ID | Semantic minimums | Starter scene must demonstrate | Named limits |
| --- | --- | --- | --- |
| `flowchart` | `start`, `process`, `decision`, `outcome`, `flow` | A start, process step, decision, labeled branches, and terminal outcomes connected by flow. | `majorNodes: 8`, `edges: 10`, `decisions: 3` |
| `process` | `step`, `flow` | Ordered stages and directional flow without introducing decision grammar. | `majorNodes: 8`, `edges: 8` |
| `business-flow-swimlane` | `lane`, `activity`, `handoff` | Named actor lanes, ordered activities, and at least one visible cross-lane handoff. | `majorNodes: 9`, `edges: 12`, `lanes: 4` |
| `state` | `state`, `transition`, `initial-state`, `final-state` | An initial state, stable states, event-labeled transitions, and a final state. | `majorNodes: 8`, `edges: 10` |
| `loop` | `cycle`, `stage` | Recurring stages connected into a closed directional cycle. | `majorNodes: 7`, `edges: 7` |

### Models And Interaction

| Catalog ID | Semantic minimums | Starter scene must demonstrate | Named limits |
| --- | --- | --- | --- |
| `class-diagram` | `class`, `inheritance`, `association` | Compartmentalized classes with members, an inheritance relation, and an association with appropriate notation. | `majorNodes: 6`, `edges: 8`, `members: 24` |
| `sequence-diagram` | `participant`, `lifeline`, `message` | Participants, lifelines, ordered calls, and a dashed return; use activation spans where they clarify execution. | `majorNodes: 6`, `edges: 12`, `activations: 6` |
| `er-diagram` | `table`, `column`, `fk` | Relational entities with key fields, foreign keys, cardinality, and an explicit junction entity for any shown many-to-many relation. | `majorNodes: 7`, `edges: 10`, `columns: 32` |
| `db-schema` | `table`, `column`, `fk` | Physical tables with implementation-level columns, key markers, and row-anchored foreign-key references. | `majorNodes: 8`, `edges: 12`, `columns: 40` |

### Hierarchy And Containment

| Catalog ID | Semantic minimums | Starter scene must demonstrate | Named limits |
| --- | --- | --- | --- |
| `mind-map` | `central-topic`, `branch`, `topic`, `connection` | One central topic, visually distinct first-level branches, subordinate topics, and their connections. | `majorNodes: 9`, `edges: 8`, `levels: 3` |
| `org-chart` | `role`, `reporting-line` | Named roles or teams arranged by manager-report hierarchy with explicit reporting lines. | `majorNodes: 9`, `edges: 8`, `levels: 4` |
| `nested` | `container`, `content` | Successive nested regions whose placement unambiguously expresses containment. | `majorNodes: 8`, `edges: 0`, `levels: 4` |
| `layers` | `container`, `content`, `layer` | Ordered, labeled strata containing representative concepts; keep layers visually distinct and equally interpretable. | `majorNodes: 6`, `edges: 0`, `bands: 6` |
| `pyramid` | `container`, `content`, `level` | Labeled tiers whose ordering and changing width communicate hierarchy, rank, or accumulation. | `majorNodes: 5`, `edges: 0`, `bands: 5` |
| `treemap` | `container`, `content` | A whole divided into nested cells, with relative area carrying part-to-whole meaning. | `majorNodes: 12`, `edges: 0`, `cells: 12`, `levels: 3` |
| `venn` | `set`, `overlap` | Labeled sets with readable exclusive regions and at least one meaningful overlap. | `majorNodes: 4`, `edges: 0`, `sets: 4` |

### Time, Work, And Experience

| Catalog ID | Semantic minimums | Starter scene must demonstrate | Named limits |
| --- | --- | --- | --- |
| `timeline` | `time-axis`, `time-item` | A chronological axis and clearly anchored dated milestones or intervals. | `majorNodes: 8`, `edges: 2`, `bands: 2` |
| `gantt` | `time-axis`, `time-item`, `task`, `dependency` | A time scale, task rows with duration bars, at least one milestone or interval, and a dependency. | `majorNodes: 10`, `edges: 8`, `rows: 8`, `bands: 10` |
| `kanban` | `row`, `column`, `cell`, `card` | Named workflow columns, optional swimlane rows, usable cells, and work-item cards placed by status. | `majorNodes: 12`, `edges: 0`, `rows: 3`, `columns: 5`, `cells: 12`, `cards: 12` |
| `journey` | `time-axis`, `time-item`, `stage`, `touchpoint` | Ordered stages, user actions or touchpoints, and a readable sentiment progression over time. | `majorNodes: 8`, `edges: 7`, `columns: 8`, `points: 8` |
| `story-map` | `row`, `column`, `cell`, `story` | A user-activity backbone, story cells, priority ordering, and at least one release slice. | `majorNodes: 15`, `edges: 0`, `rows: 4`, `columns: 5`, `cells: 15`, `cards: 15` |

### Quantitative Comparison

| Catalog ID | Semantic minimums | Starter scene must demonstrate | Named limits |
| --- | --- | --- | --- |
| `bar` | `axes`, `data` | Labeled quantitative and categorical axes with aligned bars representing data values. | `majorNodes: 8`, `edges: 2`, `series: 3`, `points: 16` |
| `line` | `axes`, `data` | Labeled axes and one or more connected series across an ordered domain. | `majorNodes: 12`, `edges: 3`, `series: 3`, `points: 24` |
| `scatter` | `axes`, `data` | Two labeled quantitative axes and observations positioned independently to expose distribution, clusters, or outliers. | `majorNodes: 12`, `edges: 2`, `series: 3`, `points: 24` |
| `quadrant` | `axes`, `data`, `quadrant` | Two meaningful axes, four interpreted regions, and items positioned by both dimensions. | `majorNodes: 12`, `edges: 2`, `points: 12` |
| `radar` | `radial-axis`, `data-series` | Shared labeled radial dimensions and comparable closed profiles for each series. | `majorNodes: 6`, `edges: 0`, `series: 3`, `points: 18` |
| `polar` | `radial-axis`, `data-series` | Angular category labels, a radial magnitude scale, and one or more category-magnitude series. | `majorNodes: 8`, `edges: 0`, `series: 2`, `points: 12` |
| `dp-security-matrix` | `row`, `column`, `cell` | Named row and column dimensions with cells that visibly encode control coverage or responsibility. | `majorNodes: 12`, `edges: 0`, `rows: 4`, `columns: 4`, `cells: 12` |

### Analysis And Strategy

| Catalog ID | Semantic minimums | Starter scene must demonstrate | Named limits |
| --- | --- | --- | --- |
| `fishbone` | `effect`, `cause`, `cause-branch` | One named effect at the head, a central spine, categorized cause branches, and individual causes. | `majorNodes: 10`, `edges: 9`, `branches: 6` |
| `wardley` | `value-chain`, `evolution-axis`, `component` | A user-facing value chain, component dependencies, and component positions across labeled evolution stages. | `majorNodes: 12`, `edges: 12`, `columns: 4` |

## Z-Order And Text

Order the `elements` array so background regions and connectors appear before nodes, then place standalone labels and titles above their visual containers. Keep shape labels separate; do not use shape-embedded `text`, `fontFamily`, or `fontSize` fields.

Set both `text` and `originalText` on text elements and keep them identical. Use 16 px for annotations, 20 px for primary node labels or section headings, and 28 px for the diagram title.

Fit internal labels before connector routing. Rectangles need at least 16 px of horizontal and 12 px of vertical padding; ellipses and diamonds need a smaller centered safe area that accounts for their tapered edges. Use explicit, balanced `\n` breaks at word or phrase boundaries when a label crowds one line. Keep ordinary node labels to one or two lines, use `lineHeight: 1.25` and `autoResize: false`, then recompute and center the text box. If the result still does not fit, enlarge the shape and reflow the scene rather than shrinking the font.

Do not split identifiers or short code tokens. In class and schema compartments, keep one member or row per semantic line and widen the compartment instead of wrapping a signature. Rendering remains authoritative: inspect internal padding and line-break quality at whole-diagram scale as well as checking for clipping.

Every `templateMetadata` object must include `counts`. Named limits beyond `majorNodes` and `edges` are counted from an explicit singular semantic role when one exists, including the configured `boundary`, `decision`, `data-store`, and `flow-band` aliases. Put every remaining named limit in `counts` as a list of one representative element ID per counted item; the key set must be exact. All metadata IDs must reference non-deleted scene elements.

## Catalog And Preview

For each template, keep one catalog entry with all required fields:

```text
id, diagramType, style, description, bestFor, avoidWhen,
nodeBudget, edgeBudget, templateFile, previewFile, upstreamSlugs,
primaryQuestion, confusableWith, semanticMinimums, limits,
geometryProfile, geometryExemptions, previewSourceSha256
```

IDs must be stable because selection and evals refer to them. Use a preview filename that matches the template stem under `previews/`.

After editing a template:

1. Parse the Excalidraw JSON.
2. Run `uv run python ../scripts/render_templates.py <template-id>` from `references/`; this renders the catalog preview and atomically updates `previewSourceSha256`.
3. Read the preview image.
4. Fix clipping, overlap, routing, hierarchy, or semantic defects.
5. Re-render and re-read until the final preview corresponds to the final template.

## Provenance Boundary

The visual grammar and type budgets were informed by the source documented in `THIRD_PARTY_NOTICES.md`, then reimplemented independently for Excalidraw. Do not copy upstream HTML, SVG, CSS values, icons, fonts, or product logos into templates or previews.
