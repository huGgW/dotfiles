# Visual Brief And Comprehension

Use this reference before template selection and again during final validation. A diagram can render cleanly and still fail because it does not answer the reader's question, uses inconsistent taxonomy, becomes unreadable at delivery size, or lacks enough context to stand alone.

## Compact Visual Brief

Write a compact brief with every field below before opening a template or editing a scene. Use `none` only when the request truly has no instance of that field.

```text
Primary reader question:
Must-see entities:
Must-see relationships:
Stages:
Split points:
Merge points:
State/store ownership:
Keys and identifiers:
Boundaries:
Warnings/non-guarantees:
What can be omitted:
Target display size:
```

Derive facts from the user prompt and supplied sources. Do not invent missing guarantees, ownership, technology, or identifiers. Ask one focused question only when the missing fact would materially change the diagram; otherwise use a concise visible assumption.

## One Primary Question Per Diagram

Assign one primary reader question to each diagram. Overview, partition/routing, idempotency, and atomicity are often related but distinct questions. Split them when one scene would require dense prose, ambiguous legends, or tiny labels. Do not reduce text below the established 16/20/28 hierarchy to preserve a single canvas.

Before drawing a split set, write a split plan with one row per resulting diagram: primary reader question, exactly one catalog ID, and target display profile. Every split result needs its own matching `.excalidraw` source and PNG. Across the set, reuse the same vocabulary, semantic colors, and component names so readers can move between views without relearning the taxonomy.

## Reader Questions Become Tests

Turn the user's prompt into mandatory comprehension questions before drawing. Include:

1. The primary reader question in direct question form.
2. One question for every must-see relationship, split, merge, ownership claim, boundary, and warning.
3. For each key or identifier: what role does it serve, where is it created or used, and what does it not guarantee?
4. For transaction or idempotency claims: what is protected, at which point, and where does the guarantee stop?
5. What the title, legend, cards, or numbered labels count.

Answer each question using only the final rendered image, without relying on the source JSON or prior conversation. If an answer is difficult, ambiguous, or requires guessing, the image does not pass. Long explanatory prose does not compensate for missing geometry.

Keep taxonomy axes separate. Identifier role count does not have to equal duplicate-defense point count. A routing key is not an idempotency key. State these distinctions wherever a reader could otherwise infer equivalence.

## Legibility Versus Comprehension

Legibility asks whether text and symbols can be perceived. Comprehension asks whether the reader can correctly explain the system and its limits. Validate both independently:

- **Legibility:** text size, contrast, clipping, overlap, padding, connector clearance, and distinguishable line styles.
- **Comprehension:** reader questions, semantic geometry, consistent terms, explicit counts, ownership, boundaries, and non-guarantees.

Passing JSON checks, rendering successfully, avoiding clipping, generating a large PNG, or using fonts at least 16 px proves neither target-size legibility nor comprehension.

## Target Display Profiles

Choose the profile in the visual brief and inspect the final PNG at that intended whole-image presentation:

| Profile | Default validation box | Validation intent |
| --- | --- | --- |
| `doc-inline` | 720x900 | Readable as an inline figure in a normal document column without zoom. |
| `doc-wide` | 1200x900 | Readable across a full document page or wide content region without zoom. |
| `screen-share` | 1440x900 | Main structure, labels, and warnings readable while the whole image is shared in a typical meeting window. |
| `slide` | 1920x1080 | Readable as one whole slide from presentation distance, with no dependence on presenter zoom. |

Use the user's supplied pixel target when present; otherwise use the profile's default bounding box. Validate reproducibly:

1. Render the final source to its intended final PNG path.
2. Create a temporary validation raster by aspect-ratio-preserving downscaling the final PNG to fit entirely inside the target bounding box. Letterbox any unused area; never crop or stretch.
3. Read the temporary raster with the image-capable Read tool and evaluate overview, details, and every comprehension question at that size.
4. Read the original final PNG after the temporary raster to confirm source/render detail and consistency.
5. Delete or ignore the temporary raster for delivery; it is validation evidence, not a deliverable.

Require both:

1. a useful whole-image overview at the target size; and
2. readable required detail without zoom, or an explicit detail-view strategy using separate paired diagrams.

If either fails, the diagram fails regardless of source or PNG dimensions. Simplify the scene, split it into overview and detail pairs, or omit nonessential prose. Move supporting prose to companion documentation only when the user explicitly requested or allowed companion docs. Do not claim PASS based only on source dimensions, PNG dimensions, or nominal font size.

## Standalone Pass Gate

Before delivery, verify that each final PNG:

- names its subject and primary question clearly enough to stand alone;
- uses geometry for stages, components, split/merge, ownership, and boundaries;
- uses consistent vocabulary and semantic color, with redundant labels or shapes for no-color reading;
- states warnings and non-guarantees visibly;
- distinguishes routing, business identity, state/merge, and duplicate-defense concepts where present;
- answers every mandatory comprehension question at the target display size.

Any difficult answer means no visual PASS. Fix, simplify, or split, then render and read again.
