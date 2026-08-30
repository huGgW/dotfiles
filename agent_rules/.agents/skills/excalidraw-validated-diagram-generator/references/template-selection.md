# Template Selection

Use this reference after identifying the user's primary question. The catalog is authoritative for available template IDs, styles, budgets, and paths.

## Selection Order

1. Read `templates/catalog.json`.
2. Map the request to exactly one catalog ID.
3. Filter that type by style.
4. Use the requested style when available; otherwise use the catalog's `defaultStyle`.
5. Read the selected entry's `templateFile` only.

Do not open every template or preview to choose visually. The type and style metadata are designed to make selection deterministic and keep context focused.

## Alias Normalization

Normalize these absorbed upstream names before selection. They are not separate local template IDs.

| Upstream alias | Canonical catalog ID |
| --- | --- |
| `it-state` | `architecture` |
| `tree` | `mind-map` |
| `high-level` | `architecture` |
| `dp-integration` | `data-flow` |
| `dependency` | `relationship` |

## System And Flow

| Select | Primary question | Choose this over the nearest alternatives when... |
| --- | --- | --- |
| `architecture` | What are the system boundaries, components, and major connections? | Logical boundaries and external integrations matter more than runtime placement (`deployment`), generic dependency meaning (`relationship`), or where data transforms and persists (`data-flow`). |
| `deployment` | Where do artifacts run and how do deployment nodes connect? | Environments, runtime nodes, deployed artifacts, and network paths matter more than logical system structure (`architecture`) or unlabeled runtime-independent relationships (`relationship`). |
| `relationship` | Which entities depend on or relate to one another, and how? | The labeled meaning and direction of links is the subject; do not use it when system boundaries (`architecture`), data transformations (`data-flow`), or runtime placement (`deployment`) are required. |
| `data-flow` | Where does data originate, transform, persist, and move? | Actors, transformations, stores, and named data are required; use `architecture` for topology, `process` for control stages, and `sankey` only when width encodes quantity. |
| `sankey` | How does a quantity split, combine, and move between stages? | Flow magnitude must be encoded by band width; use `data-flow` when semantic actor/process/store roles matter without quantitative widths, or `process` for unweighted stage order. |
| `medallion` | How does data become more refined across quality layers? | The specific bronze-silver-gold refinement progression is the meaning; use generic `layers` for arbitrary strata and `data-flow` for branching sources, stores, or transformations. |

## Process And Lifecycle

| Select | Primary question | Choose this over the nearest alternatives when... |
| --- | --- | --- |
| `flowchart` | What decisions and outcomes control this process? | Explicit decisions and labeled branches are essential; use `process` for a branch-free sequence, `state` for stable lifecycle states, and `business-flow-swimlane` for ownership lanes. |
| `process` | What ordered stages transform the input into the outcome? | A concise linear stage sequence is sufficient; use `flowchart` for branching decisions, `loop` for recurrence, and `business-flow-swimlane` for actor ownership. |
| `business-flow-swimlane` | Who owns each activity and where do handoffs occur? | Multiple actors or teams and cross-lane handoffs are primary; use `flowchart` for decision grammar, `process` for one owner, and `journey` for the user's experience. |
| `state` | Which events move the subject between stable states? | Persistent states and event-triggered transitions are primary; use `flowchart` for procedural branching and `loop` for recurring stages rather than lifecycle state. |
| `loop` | Which stages repeat and feed the next cycle? | The process is intentionally closed and recurring; use `process` for a terminal sequence and `state` for event-driven transitions between stable conditions. |

## Models And Interaction

| Select | Primary question | Choose this over the nearest alternatives when... |
| --- | --- | --- |
| `class-diagram` | What classes, members, and object relationships define the model? | Methods, visibility, inheritance, implementation, or associations are required; use `er-diagram` or `db-schema` for relational keys and tables. |
| `sequence-diagram` | In what order do participants exchange messages? | Participant lifelines and call/return order over time are primary; use `architecture` for static topology, `data-flow` for persistence and transformation, and `process` for participant-independent stages. |
| `er-diagram` | Which entities, keys, and cardinalities define the relational model? | A conceptual relational overview with keys and cardinality is enough; use `db-schema` for implementation-level columns and row-anchored foreign keys, and `class-diagram` for object behavior. |
| `db-schema` | Which physical tables, columns, and foreign keys define the database? | Physical implementation detail and row-anchored references matter; use `er-diagram` for a smaller conceptual model and `class-diagram` for object APIs. |

## Hierarchy And Containment

| Select | Primary question | Choose this over the nearest alternatives when... |
| --- | --- | --- |
| `mind-map` | How does one central topic branch into related ideas? | One concept radiates into topics; use `nested` for containment and `org-chart` for reporting authority. |
| `org-chart` | Who reports to whom in the organization? | Roles, teams, managers, and reporting lines are the meaning; use `mind-map` for conceptual branches and `deployment` for runtime nodes. |
| `nested` | What contains what across successive scopes? | Spatial containment itself carries meaning; use `layers` for ordered bands, `treemap` when area encodes part-to-whole size, and `mind-map` for connected topics. |
| `layers` | Which ordered layers contain the system concepts? | Ordered conceptual or technical strata matter, without `pyramid` rank or `medallion`-specific refinement; use `nested` for arbitrary containment. |
| `pyramid` | How are concepts ordered across hierarchical tiers? | Tier rank or accumulation is communicated by narrowing width; use `layers` for equal-width strata and `medallion` for bronze-silver-gold data refinement. |
| `treemap` | How is the whole divided across nested categories? | Nested area communicates hierarchical part-to-whole magnitude; use `nested` when size is irrelevant and `bar` when precise category comparison matters. |
| `venn` | What is unique to and shared between the sets? | Overlap and exclusive membership are primary; use `nested` for containment without intersection and `quadrant` for two-axis placement. |

## Time, Work, And Experience

| Select | Primary question | Choose this over the nearest alternatives when... |
| --- | --- | --- |
| `timeline` | What happened when, and in what chronological order? | Dated milestones or intervals are sufficient; use `gantt` when task duration and dependencies matter, and `journey` when touchpoints and sentiment matter. |
| `gantt` | When do tasks run, overlap, and depend on each other? | Scheduled durations, milestones, overlap, and dependencies are required; use `timeline` for chronology only and `kanban` for current workflow status. |
| `kanban` | Where is each work item in the delivery workflow? | Cards grouped by current workflow columns or swimlanes are primary; use `gantt` for schedule/dependency planning and `story-map` for product slicing. |
| `journey` | What does the user experience at each stage over time? | User actions, touchpoints, and sentiment across stages are primary; use `timeline` for neutral chronology and `business-flow-swimlane` for internal ownership. |
| `story-map` | How do user activities break into prioritized stories and releases? | A user-activity backbone with priority or release slices is required; use `kanban` for work status and `journey` for experience and sentiment. |

## Quantitative Comparison

| Select | Primary question | Choose this over the nearest alternatives when... |
| --- | --- | --- |
| `bar` | How do values compare across discrete categories? | Aligned bar length supports category magnitude comparison; use `line` for ordered change and `polar` only for cyclical angular categories. |
| `line` | How do one or more values change across an ordered axis? | Trend across time or another ordered axis is primary; use `bar` for unordered categories, `scatter` for independent observations, `radar` for multi-dimension profiles, and `journey` for staged user experience. |
| `scatter` | What relationship, clusters, or outliers appear between two variables? | Observation distribution on two continuous variables is primary; use `quadrant` when regions have fixed interpretations and `line` for ordered trends. |
| `quadrant` | Where do items fall across two meaningful dimensions? | Two axes divide the space into four interpreted regions; use `scatter` for statistical distribution and `dp-security-matrix` for categorical intersections. |
| `radar` | How do series compare across the same radial dimensions? | Each series forms a multi-attribute profile across shared dimensions; use `polar` for category magnitudes and `line` when exact ordered values matter. |
| `polar` | How do category magnitudes compare around a radial scale? | Angular categories encode cyclical magnitude; use `radar` for multi-dimension item profiles and `bar` for easier linear category comparison. |
| `dp-security-matrix` | Which controls or responsibilities apply at each matrix intersection? | Rows and columns are categorical dimensions and cells carry control/responsibility meaning; use `quadrant` for continuous axes and `story-map` for stories and releases. |

## Analysis And Strategy

| Select | Primary question | Choose this over the nearest alternatives when... |
| --- | --- | --- |
| `fishbone` | Which categories and causes contribute to the observed effect? | A single effect, cause categories, and contributing cause branches are required; use `mind-map` for neutral ideation and `relationship` for general network links. |
| `wardley` | How do value-chain components depend on and evolve relative to users? | Both value-chain dependency and justified evolution position are required; use `relationship` when evolution position is absent and `quadrant` for independent two-axis comparison. |

Prefer the notation that answers the user's main question. If the deciding information is absent and the alternatives would communicate materially different claims, ask one concise clarification question.

## Style Selection

The current catalog provides `editorial-light`. Use it when the user gives no style. If the user requests an unavailable style, retain the selected canonical template and adapt only the explicitly requested visual traits that do not violate the core design contract. Do not silently switch diagram type to obtain a style.

The editorial-light grammar uses:

- plain white (`#ffffff`) canvas with no tinted background;
- neutral surfaces and muted ordinary connectors;
- blue for external actors or systems;
- orange for the focal path or node;
- one accent by default and no more than two;
- no shadows and no imported product styling.

## Budget Decisions

Treat `nodeBudget` as the maximum count of major semantic nodes, participants, classes, entities, lanes plus activities where applicable. Treat `edgeBudget` as the maximum count of semantic connectors or messages.

When the requested content exceeds a budget:

1. Keep the overview at or below the budget.
2. Group low-level details behind a clearly named overview node when that preserves meaning.
3. If grouping would hide required semantics, split the request into overview and detail diagrams instead of shrinking text or crowding the scene.

Do not evade budgets by converting required nodes into tiny annotations.

## Canonical Starter Scene

Copy the selected template and replace its placeholder content. Preserve its diagram-specific grammar, dominant axis, element ordering, and routing strategy. It is not merely an image to imitate.

Adding or removing elements is allowed when the request requires it, but the resulting scene must still satisfy the selected type semantics and catalog budgets. Never combine unrelated template scenes into one output.

The templates are native Excalidraw scenes. Do not replace editable elements with embedded HTML, SVG, CSS-rendered content, copied coordinates, icons, fonts, or upstream assets.
