"""Render Excalidraw JSON to PNG using Playwright + headless Chromium.

Usage:
    cd ~/.agents/skills/excalidraw-validated-diagram-generator/references
    uv run python render_excalidraw.py <path-to-file.excalidraw> [--output path.png] [--scale 2] [--width 1920]

First-time setup:
    cd ~/.agents/skills/excalidraw-validated-diagram-generator/references
    uv sync
    uv run playwright install chromium
"""

from __future__ import annotations

import argparse
import json
import math
import sys
from pathlib import Path
from typing import Any, cast


REQUIRED_TOP_LEVEL_KEYS = ("type", "version", "source", "elements", "appState", "files")
REQUIRED_ELEMENT_KEYS = (
    "id",
    "type",
    "x",
    "y",
    "width",
    "height",
    "angle",
    "index",
    "opacity",
    "version",
)
GEOMETRY_KEYS = ("x", "y", "width", "height", "angle")


def _is_finite_number(value: object) -> bool:
    return isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value)


def _element_label(position: int, element: dict[str, Any]) -> str:
    element_id = element.get("id")
    if isinstance(element_id, str) and element_id:
        return f"Element {position} ('{element_id}')"
    return f"Element {position}"


def validate_excalidraw(data: object) -> list[str]:
    """Validate Excalidraw JSON structure. Returns list of errors (empty = valid)."""
    errors: list[str] = []

    if not isinstance(data, dict):
        return ["Top-level Excalidraw data must be an object"]
    data = cast(dict[str, Any], data)

    for key in REQUIRED_TOP_LEVEL_KEYS:
        if key not in data:
            errors.append(f"Missing top-level '{key}'")

    if data.get("type") != "excalidraw":
        errors.append(f"Expected type 'excalidraw', got '{data.get('type')}'")

    version = data.get("version")
    if not isinstance(version, int) or isinstance(version, bool) or version != 2:
        errors.append(f"Top-level 'version' must be integer 2, got {version!r}")

    if "source" in data and not isinstance(data["source"], str):
        errors.append("Top-level 'source' must be a string")
    if "appState" in data and not isinstance(data["appState"], dict):
        errors.append("Top-level 'appState' must be an object")
    if "files" in data and not isinstance(data["files"], dict):
        errors.append("Top-level 'files' must be an object")

    elements = data.get("elements")
    if not isinstance(elements, list):
        errors.append("'elements' must be an array")
        return errors
    if not elements:
        errors.append("'elements' array is empty - nothing to render")
        return errors

    ids: dict[str, int] = {}
    indexes: dict[str, int] = {}
    valid_elements: list[tuple[int, dict[str, Any]]] = []

    for position, element in enumerate(elements):
        if not isinstance(element, dict):
            errors.append(f"Element {position} must be an object")
            continue
        element = cast(dict[str, Any], element)

        valid_elements.append((position, element))
        label = _element_label(position, element)

        for key in REQUIRED_ELEMENT_KEYS:
            if key not in element:
                errors.append(f"{label} is missing required field '{key}'")

        element_id = element.get("id")
        if not isinstance(element_id, str) or not element_id:
            errors.append(f"Element {position} field 'id' must be a non-empty string")
        elif element_id in ids:
            errors.append(
                f"{label} duplicates id '{element_id}' from element {ids[element_id]}"
            )
        else:
            ids[element_id] = position

        element_type = element.get("type")
        if not isinstance(element_type, str) or not element_type:
            errors.append(f"{label} field 'type' must be a non-empty string")

        index = element.get("index")
        if not isinstance(index, str) or not index:
            errors.append(f"{label} field 'index' must be a non-empty string")
        elif index in indexes:
            errors.append(
                f"{label} duplicates index '{index}' from element {indexes[index]}"
            )
        else:
            indexes[index] = position

        for key in GEOMETRY_KEYS:
            if key in element and not _is_finite_number(element[key]):
                errors.append(f"{label} field '{key}' must be a finite number")

        if "opacity" in element:
            opacity = element["opacity"]
            if not _is_finite_number(opacity) or not 0 <= opacity <= 100:
                errors.append(f"{label} field 'opacity' must be a number from 0 to 100")

        if "version" in element:
            element_version = element["version"]
            if (
                not isinstance(element_version, int)
                or isinstance(element_version, bool)
                or element_version < 1
            ):
                errors.append(f"{label} field 'version' must be an integer of at least 1")

        if "isDeleted" in element and not isinstance(element["isDeleted"], bool):
            errors.append(f"{label} field 'isDeleted' must be a boolean")

        if element_type in ("line", "arrow"):
            points = element.get("points")
            if not isinstance(points, list) or len(points) < 2:
                errors.append(f"{label} field 'points' must contain at least two points")
            else:
                for point_position, point in enumerate(points):
                    if (
                        not isinstance(point, (list, tuple))
                        or len(point) != 2
                        or not all(_is_finite_number(coordinate) for coordinate in point)
                    ):
                        errors.append(
                            f"{label} point {point_position} must be a pair of finite numbers"
                        )

        if element_type == "text" and not isinstance(element.get("text"), str):
            errors.append(f"{label} text element field 'text' must be a string")

        if "originalText" in element:
            original_text = element["originalText"]
            if not isinstance(original_text, str):
                errors.append(f"{label} field 'originalText' must be a string")
            elif element.get("text") != original_text:
                errors.append(f"{label} fields 'text' and 'originalText' must be equal")

    for position, element in valid_elements:
        label = _element_label(position, element)

        for binding_name in ("startBinding", "endBinding"):
            if binding_name not in element or element[binding_name] is None:
                continue

            binding = element[binding_name]
            if not isinstance(binding, dict):
                errors.append(f"{label} field '{binding_name}' must be an object or null")
                continue

            target_id = binding.get("elementId")
            if not isinstance(target_id, str) or not target_id:
                errors.append(
                    f"{label} field '{binding_name}.elementId' must be a non-empty string"
                )
            elif target_id not in ids:
                errors.append(
                    f"{label} field '{binding_name}' targets missing element '{target_id}'"
                )

            for numeric_key in ("focus", "gap"):
                if numeric_key in binding and not _is_finite_number(binding[numeric_key]):
                    errors.append(
                        f"{label} field '{binding_name}.{numeric_key}' must be a finite number"
                    )

        if "boundElements" not in element or element["boundElements"] is None:
            continue

        bound_elements = element["boundElements"]
        if not isinstance(bound_elements, list):
            errors.append(f"{label} field 'boundElements' must be an array or null")
            continue

        for bound_position, bound_element in enumerate(bound_elements):
            if not isinstance(bound_element, dict):
                errors.append(
                    f"{label} boundElements[{bound_position}] must be an object"
                )
                continue

            target_id = bound_element.get("id")
            if not isinstance(target_id, str) or not target_id:
                errors.append(
                    f"{label} boundElements[{bound_position}].id must be a non-empty string"
                )
            elif target_id not in ids:
                errors.append(
                    f"{label} boundElements[{bound_position}] targets missing element "
                    f"'{target_id}'"
                )

    return errors


def compute_bounding_box(elements: list[dict]) -> tuple[float, float, float, float]:
    """Compute bounding box (min_x, min_y, max_x, max_y) across all elements."""
    min_x = float("inf")
    min_y = float("inf")
    max_x = float("-inf")
    max_y = float("-inf")

    for el in elements:
        if el.get("isDeleted"):
            continue
        x = el.get("x", 0)
        y = el.get("y", 0)
        w = el.get("width", 0)
        h = el.get("height", 0)

        # For arrows/lines, points array defines the shape relative to x,y
        if el.get("type") in ("arrow", "line") and "points" in el:
            for px, py in el["points"]:
                min_x = min(min_x, x + px)
                min_y = min(min_y, y + py)
                max_x = max(max_x, x + px)
                max_y = max(max_y, y + py)
        else:
            min_x = min(min_x, x)
            min_y = min(min_y, y)
            max_x = max(max_x, x + abs(w))
            max_y = max(max_y, y + abs(h))

    if min_x == float("inf"):
        return (0, 0, 800, 600)

    return (min_x, min_y, max_x, max_y)


def render(
    excalidraw_path: Path,
    output_path: Path | None = None,
    scale: int = 2,
    max_width: int = 1920,
) -> Path:
    """Render an .excalidraw file to PNG. Returns the output PNG path."""
    # Import playwright here so validation errors show before import errors
    try:
        from playwright.sync_api import TimeoutError as PlaywrightTimeoutError
        from playwright.sync_api import sync_playwright
    except ImportError:
        print("ERROR: playwright not installed.", file=sys.stderr)
        print("Run: cd ~/.agents/skills/excalidraw-validated-diagram-generator/references && uv sync && uv run playwright install chromium", file=sys.stderr)
        sys.exit(1)

    # Read and validate
    raw = excalidraw_path.read_text(encoding="utf-8")
    try:
        data = json.loads(raw)
    except json.JSONDecodeError as e:
        print(f"ERROR: Invalid JSON in {excalidraw_path}: {e}", file=sys.stderr)
        sys.exit(1)

    errors = validate_excalidraw(data)
    if errors:
        print(f"ERROR: Invalid Excalidraw file:", file=sys.stderr)
        for err in errors:
            print(f"  - {err}", file=sys.stderr)
        sys.exit(1)

    # Compute viewport size from element bounding box
    elements = [e for e in data["elements"] if not e.get("isDeleted")]
    min_x, min_y, max_x, max_y = compute_bounding_box(elements)
    padding = 80
    diagram_w = max_x - min_x + padding * 2
    diagram_h = max_y - min_y + padding * 2

    # Cap viewport width, let height be natural
    vp_width = min(int(diagram_w), max_width)
    vp_height = max(int(diagram_h), 600)

    # Output path
    if output_path is None:
        output_path = excalidraw_path.with_suffix(".png")

    # Template path (same directory as this script)
    template_path = Path(__file__).parent / "render_template.html"
    if not template_path.exists():
        print(f"ERROR: Template not found at {template_path}", file=sys.stderr)
        sys.exit(1)

    template_url = template_path.as_uri()

    with sync_playwright() as p:
        try:
            browser = p.chromium.launch(headless=True)
        except Exception as e:
            if "Executable doesn't exist" in str(e) or "browserType.launch" in str(e):
                print("ERROR: Chromium not installed for Playwright.", file=sys.stderr)
                print("Run: cd ~/.agents/skills/excalidraw-validated-diagram-generator/references && uv run playwright install chromium", file=sys.stderr)
                sys.exit(1)
            raise

        page = browser.new_page(
            viewport={"width": vp_width, "height": vp_height},
            device_scale_factor=scale,
        )
        browser_messages: list[str] = []
        page.on("console", lambda msg: browser_messages.append(f"console.{msg.type}: {msg.text}"))
        page.on("pageerror", lambda err: browser_messages.append(f"pageerror: {err}"))
        page.on("requestfailed", lambda req: browser_messages.append(f"requestfailed: {req.url} ({req.failure})"))
        page.on("response", lambda res: browser_messages.append(f"response.{res.status}: {res.url}") if res.status >= 400 else None)

        # Load the template
        page.goto(template_url)

        # Wait for the ES module to load (imports from esm.sh)
        try:
            page.wait_for_function("window.__moduleReady === true || window.__moduleError", timeout=120000)
        except PlaywrightTimeoutError:
            print("ERROR: Timed out waiting for the Excalidraw browser module to load.", file=sys.stderr)
            if browser_messages:
                print("Browser messages:", file=sys.stderr)
                for message in browser_messages[-20:]:
                    print(f"  - {message}", file=sys.stderr)
            browser.close()
            sys.exit(1)

        module_error = page.evaluate("window.__moduleError")
        if module_error:
            print(f"ERROR: Excalidraw browser module failed to load: {module_error}", file=sys.stderr)
            if browser_messages:
                print("Browser messages:", file=sys.stderr)
                for message in browser_messages[-20:]:
                    print(f"  - {message}", file=sys.stderr)
            browser.close()
            sys.exit(1)

        # Inject the diagram data and render
        json_str = json.dumps(data)
        result = page.evaluate(f"window.renderDiagram({json_str})")

        if not result or not result.get("success"):
            error_msg = result.get("error", "Unknown render error") if result else "renderDiagram returned null"
            print(f"ERROR: Render failed: {error_msg}", file=sys.stderr)
            browser.close()
            sys.exit(1)

        # Wait for render completion signal
        page.wait_for_function("window.__renderComplete === true", timeout=15000)

        # Screenshot the SVG element
        svg_el = page.query_selector("#root svg")
        if svg_el is None:
            print("ERROR: No SVG element found after render.", file=sys.stderr)
            browser.close()
            sys.exit(1)

        svg_el.screenshot(path=str(output_path))
        browser.close()

    return output_path


def main() -> None:
    parser = argparse.ArgumentParser(description="Render Excalidraw JSON to PNG")
    parser.add_argument("input", type=Path, help="Path to .excalidraw JSON file")
    parser.add_argument("--output", "-o", type=Path, default=None, help="Output PNG path (default: same name with .png)")
    parser.add_argument("--scale", "-s", type=int, default=2, help="Device scale factor (default: 2)")
    parser.add_argument("--width", "-w", type=int, default=1920, help="Max viewport width (default: 1920)")
    args = parser.parse_args()

    if not args.input.exists():
        print(f"ERROR: File not found: {args.input}", file=sys.stderr)
        sys.exit(1)

    png_path = render(args.input, args.output, args.scale, args.width)
    print(str(png_path))


if __name__ == "__main__":
    main()
