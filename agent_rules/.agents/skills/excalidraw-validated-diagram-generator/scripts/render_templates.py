"""Render cataloged Excalidraw templates to their preview paths."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import stat
import sys
import tempfile
from pathlib import Path
from types import ModuleType
from typing import Any, Callable, cast


SKILL_ROOT = Path(__file__).resolve().parents[1]
REFERENCES_DIR = SKILL_ROOT / "references"
SCRIPTS_DIR = SKILL_ROOT / "scripts"


def _load_module(name: str, path: Path) -> ModuleType:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"Cannot load module from {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


_renderer = _load_module("excalidraw_batch_renderer", REFERENCES_DIR / "render_excalidraw.py")
_validator = _load_module("excalidraw_template_validator", SCRIPTS_DIR / "validate_templates.py")
render = cast(Callable[[Path, Path], Path], _renderer.render)
load_catalog = cast(Callable[..., dict[str, Any]], _validator.load_catalog)
validate_catalog = cast(Callable[..., list[str]], _validator.validate_catalog)
validate_source_templates = cast(
    Callable[..., dict[str, list[str]]], _validator.validate_source_templates
)


def _format_issues(issues: dict[str, list[str]]) -> str:
    return "\n".join(
        f"  - {path}: {error}"
        for path, errors in issues.items()
        for error in errors
    )


def _write_catalog_atomic(catalog: dict[str, Any], catalog_path: Path) -> None:
    temporary_path: Path | None = None
    catalog_mode = stat.S_IMODE(catalog_path.stat().st_mode)
    try:
        with tempfile.NamedTemporaryFile(
            "w",
            encoding="utf-8",
            dir=catalog_path.parent,
            prefix=f".{catalog_path.name}.",
            suffix=".tmp",
            delete=False,
        ) as temporary:
            json.dump(catalog, temporary, indent=2, ensure_ascii=True)
            temporary.write("\n")
            temporary_path = Path(temporary.name)
        temporary_path.chmod(catalog_mode)
        os.replace(temporary_path, catalog_path)
    finally:
        if temporary_path is not None and temporary_path.exists():
            temporary_path.unlink()


def render_templates(
    template_ids: list[str] | None = None, *, skill_root: Path = SKILL_ROOT
) -> list[Path]:
    """Render all templates, or only the requested catalog IDs."""
    catalog = load_catalog(skill_root)
    catalog_errors = validate_catalog(catalog, skill_root, strict=False)
    if catalog_errors:
        details = "\n".join(f"  - {error}" for error in catalog_errors)
        raise ValueError(f"Template catalog is invalid:\n{details}")
    source_issues = validate_source_templates(catalog, skill_root)
    if source_issues:
        raise ValueError(f"Template sources are invalid:\n{_format_issues(source_issues)}")

    entries = catalog["templates"]
    entries_by_id = {entry["id"]: entry for entry in entries}
    selected_ids = template_ids if template_ids else list(entries_by_id)
    unknown_ids = sorted(set(selected_ids) - entries_by_id.keys())
    if unknown_ids:
        raise ValueError(f"Unknown template ID(s): {', '.join(unknown_ids)}")

    rendered_paths: list[Path] = []
    for template_id in selected_ids:
        entry = entries_by_id[template_id]
        template_path = skill_root / entry["templateFile"]
        preview_path = skill_root / entry["previewFile"]
        preview_path.parent.mkdir(parents=True, exist_ok=True)
        rendered_paths.append(render(template_path, preview_path))
        entry["previewSourceSha256"] = hashlib.sha256(template_path.read_bytes()).hexdigest()

    _write_catalog_atomic(catalog, skill_root / "templates/catalog.json")
    final_errors = validate_catalog(catalog, skill_root, strict=True)
    if final_errors:
        details = "\n".join(f"  - {error}" for error in final_errors)
        raise ValueError(f"Rendered template catalog is invalid:\n{details}")

    return rendered_paths


def main() -> int:
    parser = argparse.ArgumentParser(description="Render cataloged Excalidraw templates")
    parser.add_argument("template_ids", nargs="*", help="Optional catalog template IDs")
    args = parser.parse_args()

    try:
        rendered_paths = render_templates(args.template_ids or None)
    except (ImportError, OSError, ValueError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 1
    except SystemExit as error:
        return error.code if isinstance(error.code, int) else 1
    except Exception as error:
        print(f"ERROR: Template rendering failed: {error}", file=sys.stderr)
        return 1

    for path in rendered_paths:
        print(path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
