# Excalidraw Element Types Guide

Use the smallest set of native Excalidraw elements that communicates the selected diagram type. Labels are always separate text elements.

## Overview

| Type | Primary use | Directional | Label rule |
| --- | --- | --- | --- |
| `rectangle` | Components, steps, entities, stores, class compartments | No | Separate `text` |
| `ellipse` | Start or end terminals, actors, emphasis | No | Separate `text` |
| `diamond` | Flowchart decisions | No | Separate `text` |
| `arrow` | Directed flow, calls, dependencies, associations | Yes | Separate `text` |
| `line` | Lifelines, dividers, hierarchy, non-directional links | No | Separate `text` when needed |
| `text` | Titles, labels, annotations, members, keys | N/A | `fontFamily: 5`, at least 16 px |

## Rectangle

Use rectangles for most semantic nodes. Rounded rectangles work well for components and process steps; square corners help structured records such as classes and entities.

```json
{
  "type": "rectangle",
  "x": 120,
  "y": 120,
  "width": 200,
  "height": 80,
  "backgroundColor": "#ffffff",
  "strokeColor": "#64748b",
  "roundness": { "type": 3 }
}
```

Do not add `text` or font fields to the rectangle. Place a text element after the rectangle in z-order.

Common uses:

- architecture component or boundary;
- flowchart process;
- data-flow process or store;
- swimlane activity;
- class or ER compartment.

## Ellipse

Use ellipses sparingly for terminals, external actors, or a focal concept when the selected template uses that grammar.

```json
{
  "type": "ellipse",
  "x": 120,
  "y": 120,
  "width": 120,
  "height": 64,
  "backgroundColor": "#ffffff",
  "strokeColor": "#64748b"
}
```

Prefer a wide terminal ellipse over forcing text into a small circle.

## Diamond

Use diamonds only for control-flow decisions. Phrase the separate label as a concise question and label every outgoing branch.

```json
{
  "type": "diamond",
  "x": 120,
  "y": 120,
  "width": 160,
  "height": 120,
  "backgroundColor": "#ffffff",
  "strokeColor": "#64748b"
}
```

Keep the decision on the dominant axis and route branches orthogonally when they leave that axis.

## Arrow

Use arrows for directional semantics. Set arrowheads explicitly rather than depending on renderer defaults.

```json
{
  "type": "arrow",
  "x": 120,
  "y": 160,
  "width": 240,
  "height": 80,
  "points": [[0, 0], [120, 0], [120, 80], [240, 80]],
  "strokeStyle": "solid",
  "startArrowhead": null,
  "endArrowhead": "arrow",
  "startBinding": null,
  "endBinding": null
}
```

Connector rules:

- Use solid muted arrows for ordinary flow.
- Use blue for a flow whose external-system role needs emphasis.
- Use orange only for the focal path.
- Use dashed arrows for asynchronous or return flows.
- Use orthogonal points for off-axis routes.
- Keep fan-out anchors at least 12 px apart.
- Keep the route outside non-endpoint nodes.
- Place arrows before endpoint nodes in z-order.

Add labels as separate text elements at least 8 px from the arrow and nearby shapes. Use at least 16 px text.

## Line

Use lines when direction would be misleading:

- sequence lifelines;
- swimlane separators;
- class or ER compartment dividers;
- mind-map hierarchy branches;
- explicitly non-directional relationships.

```json
{
  "type": "line",
  "x": 120,
  "y": 120,
  "width": 0,
  "height": 240,
  "points": [[0, 0], [0, 240]],
  "strokeStyle": "dashed",
  "startArrowhead": null,
  "endArrowhead": null
}
```

Do not substitute a plain line when the relationship has direction.

## Text

All visible words belong in standalone text elements.

```json
{
  "type": "text",
  "x": 152,
  "y": 148,
  "width": 136,
  "height": 24,
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
```

Use this hierarchy:

| Purpose | Size |
| --- | --- |
| Annotation, branch label, multiplicity | 16 |
| Primary node label, participant, section heading | 20 |
| Diagram title | 28 |

Do not use smaller text to fit an overloaded scene. Shorten content, enlarge the node, or split overview and detail.

## Composite Patterns

### Labeled Node

Order the shape before its label:

```json
[
  { "id": "service-shape", "type": "rectangle" },
  {
    "id": "service-label",
    "type": "text",
    "text": "Order Service",
    "originalText": "Order Service",
    "fontFamily": 5,
    "fontSize": 20,
    "containerId": null
  }
]
```

### Connected Nodes

Order the connector before both nodes so the node fills cover its endpoints:

```json
[
  {
    "id": "request-arrow",
    "type": "arrow",
    "startArrowhead": null,
    "endArrowhead": "arrow"
  },
  { "id": "client-shape", "type": "rectangle" },
  { "id": "api-shape", "type": "rectangle" },
  {
    "id": "request-label",
    "type": "text",
    "text": "HTTPS",
    "originalText": "HTTPS",
    "fontFamily": 5,
    "fontSize": 16,
    "containerId": null
  }
]
```

### Structured Class Or Entity

Use one outer rectangle, separate divider lines, and separate text blocks for the name and each member section. Class diagrams use attributes, methods, visibility, and OOP connectors. ER diagrams use attributes, PK/FK markers, and cardinality. Do not blur the two notations.

### Sequence Interaction

Use participant nodes at the top, dashed plain lines for lifelines, solid arrows for calls, and dashed arrows for returns. Place messages in chronological top-to-bottom order and keep labels clear of lifelines and arrow strokes.

## Final Element Checks

- Every label is a separate text element.
- Every text element uses font family 5 and size 16, 20, or 28.
- Every directional connector has an explicit arrowhead.
- Async and return connectors are dashed.
- Off-axis connectors are orthogonal.
- Connectors do not pass through unrelated nodes.
- Connector labels have at least 8 px clearance.
- Connector elements precede nodes in z-order.
