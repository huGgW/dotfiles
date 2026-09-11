# Excalidraw JSON Schema Reference

Use this reference when editing `.excalidraw` JSON directly. Start from the selected canonical template and preserve fields that Excalidraw already emitted unless a change requires updating them.

## Top-Level Structure

```typescript
interface ExcalidrawFile {
  type: "excalidraw";
  version: 2;
  source: "https://excalidraw.com";
  elements: ExcalidrawElement[];
  appState: {
    viewBackgroundColor: "#ffffff";
    gridSize: 4;
  };
  files: Record<string, unknown>;
}
```

Keep `files` empty unless the scene intentionally embeds a supported asset. Canonical templates do not redistribute HTML, SVG, icon fonts, or product logos.

## Common Element Fields

```typescript
interface BaseElement {
  id: string;
  type: "rectangle" | "ellipse" | "diamond" | "arrow" | "line" | "text";
  x: number;
  y: number;
  width: number;
  height: number;
  angle: number;
  strokeColor: string;
  backgroundColor: string;
  fillStyle: "solid" | "hachure" | "cross-hatch";
  strokeWidth: number;
  strokeStyle: "solid" | "dashed" | "dotted";
  roughness: number;
  opacity: number;
  groupIds: string[];
  frameId: string | null;
  index: string;
  roundness: { type: number } | null;
  seed: number;
  version: number;
  versionNonce: number;
  isDeleted: boolean;
  boundElements: Array<{ id: string; type: string }> | null;
  updated: number;
  link: string | null;
  locked: boolean;
}
```

All IDs must be unique. Keep positions, dimensions, and connector bend points on a 4 px rhythm when practical. Use `opacity` from 0 through 100 and positive integer versions.

## Shape Elements

Rectangles, ellipses, and diamonds are visual containers only. Labels are independent text elements.

```typescript
interface RectangleElement extends BaseElement {
  type: "rectangle";
  roundness: { type: 3 } | null;
}

interface EllipseElement extends BaseElement {
  type: "ellipse";
}

interface DiamondElement extends BaseElement {
  type: "diamond";
}
```

Do not put `text`, `originalText`, `fontFamily`, or `fontSize` on a shape. A separate text element avoids exporter-dependent shape-label behavior and makes z-order explicit.

## Text Elements

```typescript
interface TextElement extends BaseElement {
  type: "text";
  text: string;
  originalText: string;
  fontSize: 16 | 20 | 28;
  fontFamily: 5;
  textAlign: "left" | "center" | "right";
  verticalAlign: "top" | "middle";
  lineHeight: number;
  containerId: null;
  autoResize: boolean;
}
```

Keep `text` and `originalText` identical. Use 16 px for annotations, 20 px for primary labels or section headings, and 28 px for the title. Do not use text smaller than 16 px. Unbounded titles and annotations may use `autoResize: true`. Shape labels use an explicitly sized safe-area text box with `autoResize: false`; insert the same manual `\n` characters in both text fields instead of depending on exporter-side wrapping.

Approximate text bounds before rendering. Latin letters average roughly 0.6 em, while Korean and other CJK glyphs are commonly close to 1 em:

```text
line_width ~= fontSize * (latin_like_characters * 0.6 + cjk_or_wide_characters)
height     ~= line_count * fontSize * lineHeight
```

For a rectangle, reserve at least 16 px on the left and right and 12 px at the top and bottom. Use a smaller centered inscribed area for ellipses and diamonds because their edges taper toward the label. After inserting or removing a line break, update `width`, `height`, `x`, and `y` together so the complete text block remains centered. Rendering is authoritative; enlarge or reposition text after reading the PNG when these estimates clip or leave uncomfortably narrow padding.

## Arrow And Line Elements

```typescript
interface Binding {
  elementId: string;
  focus: number;
  gap: number;
}

interface ArrowElement extends BaseElement {
  type: "arrow";
  points: Array<[number, number]>;
  startBinding: Binding | null;
  endBinding: Binding | null;
  startArrowhead: "arrow" | "bar" | "dot" | "triangle" | null;
  endArrowhead: "arrow" | "bar" | "dot" | "triangle" | null;
  elbowed?: boolean;
}

interface LineElement extends BaseElement {
  type: "line";
  points: Array<[number, number]>;
  startBinding: Binding | null;
  endBinding: Binding | null;
  startArrowhead: null;
  endArrowhead: null;
}
```

Points are relative to the element's `(x, y)`. Use an arrow with an explicit `endArrowhead` for directional semantics. Reserve plain lines for lifelines, dividers, hierarchy branches, or genuinely non-directional relationships.

For off-axis routing, use orthogonal bend points rather than a diagonal crossing. Separate fan-out anchors by at least 12 px. A connector must not cross a non-endpoint node, and a separate connector label must remain at least 8 px from lines and shapes.

## Z-Order

Array order controls stacking. Use this order:

1. Background regions, boundaries, lane fills, or separators.
2. Lines and arrows.
3. Node shapes.
4. Standalone labels and annotations.
5. Section headings and title.

In particular, place connectors before their endpoint nodes so node fills cover connector ends cleanly.

## Palette Roles

Use semantic roles rather than copying a product palette:

| Role | Guidance |
| --- | --- |
| Canvas | `#ffffff` |
| Ordinary elements | Neutral surface, dark text, muted border |
| Ordinary connectors | Muted neutral stroke |
| External systems | Blue accent |
| Focal path or node | Orange accent |
| Async or return flow | Dashed stroke |

Use one accent by default and at most two. Do not add shadows.

## Minimal Example

The shape and its label are separate, and the title uses the required font family:

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://excalidraw.com",
  "elements": [
    {
      "id": "component-shape",
      "type": "rectangle",
      "x": 120,
      "y": 120,
      "width": 200,
      "height": 80,
      "angle": 0,
      "strokeColor": "#64748b",
      "backgroundColor": "#ffffff",
      "fillStyle": "solid",
      "strokeWidth": 2,
      "strokeStyle": "solid",
      "roughness": 1,
      "opacity": 100,
      "groupIds": [],
      "frameId": null,
      "index": "a0",
      "roundness": { "type": 3 },
      "seed": 123456789,
      "version": 1,
      "versionNonce": 987654321,
      "isDeleted": false,
      "boundElements": null,
      "updated": 0,
      "link": null,
      "locked": false
    },
    {
      "id": "component-label",
      "type": "text",
      "x": 152,
      "y": 148,
      "width": 136,
      "height": 24,
      "angle": 0,
      "strokeColor": "#1f2937",
      "backgroundColor": "transparent",
      "fillStyle": "solid",
      "strokeWidth": 1,
      "strokeStyle": "solid",
      "roughness": 0,
      "opacity": 100,
      "groupIds": [],
      "frameId": null,
      "index": "a1",
      "roundness": null,
      "seed": 246813579,
      "version": 1,
      "versionNonce": 975318642,
      "isDeleted": false,
      "boundElements": null,
      "updated": 0,
      "link": null,
      "locked": false,
      "text": "API Gateway",
      "originalText": "API Gateway",
      "fontSize": 20,
      "fontFamily": 5,
      "textAlign": "center",
      "verticalAlign": "top",
      "lineHeight": 1.2,
      "containerId": null,
      "autoResize": true
    }
  ],
  "appState": {
    "viewBackgroundColor": "#ffffff",
    "gridSize": 4
  },
  "files": {}
}
```

## Validation Checklist

- Top-level type and version are correct.
- IDs are unique and referenced bindings exist.
- Shapes contain no embedded text fields.
- Every text element uses `fontFamily: 5` and `fontSize >= 16`.
- Every shape label fits a centered safe area with consistent padding and semantic line breaks where needed.
- Manually wrapped shape labels use matching explicit `\n` characters in `text` and `originalText`, `lineHeight: 1.25`, and `autoResize: false`.
- Directional connectors have explicit arrowheads.
- Connectors precede nodes in z-order and avoid non-endpoint nodes.
- The scene respects the selected template budgets.
- The final JSON renders, and the final PNG has been read after the last edit.
