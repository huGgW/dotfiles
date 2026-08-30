"""Validate the shared Excalidraw template catalog and canonical assets."""

from __future__ import annotations

import importlib.util
import hashlib
import json
import math
import re
import sys
from collections import Counter
from pathlib import Path, PurePosixPath, PureWindowsPath
from types import ModuleType
from typing import Any, Callable, cast


SKILL_ROOT = Path(__file__).resolve().parents[1]
REFERENCES_DIR = SKILL_ROOT / "references"


def _load_module(name: str, path: Path) -> ModuleType:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"Cannot load module from {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


_renderer = _load_module(
    "excalidraw_template_renderer", REFERENCES_DIR / "render_excalidraw.py"
)
validate_excalidraw = cast(Callable[[object], list[str]], _renderer.validate_excalidraw)


CATALOG_PATH = PurePosixPath("templates/catalog.json")
COVERAGE_PATH = PurePosixPath("references/upstream-coverage.json")
EVALS_PATH = PurePosixPath("evals/evals.json")
SKILL_NAME = "excalidraw-validated-diagram-generator"
CANONICAL_STYLE = "editorial-light"
CANONICAL_BACKGROUND = "#ffffff"
CANONICAL_GRID_SIZE = 20
CATALOG_VERSION = 2
COVERAGE_SCHEMA = "excalidraw-template-upstream-coverage"
COVERAGE_VERSION = 1
UPSTREAM_REPOSITORY = "cathrynlavery/diagram-design"
UPSTREAM_COMMIT = "648c2a597839301e06df1e7434a08bde9f42eed3"
UPSTREAM_TEMPLATE_COUNT = 39
SHA256_PATTERN = re.compile(r"^[0-9a-f]{64}$")

EXPECTED_TEMPLATE_IDS = frozenset(
    {
        "architecture",
        "flowchart",
        "relationship",
        "mind-map",
        "data-flow",
        "business-flow-swimlane",
        "class-diagram",
        "sequence-diagram",
        "er-diagram",
        "state",
        "timeline",
        "quadrant",
        "radar",
        "polar",
        "loop",
        "nested",
        "org-chart",
        "layers",
        "venn",
        "pyramid",
        "bar",
        "treemap",
        "line",
        "gantt",
        "scatter",
        "process",
        "medallion",
        "dp-security-matrix",
        "sankey",
        "fishbone",
        "wardley",
        "kanban",
        "journey",
        "deployment",
        "story-map",
        "db-schema",
    }
)

DIRECT_MAPPINGS = {
    "architecture": "architecture",
    "flowchart": "flowchart",
    "sequence": "sequence-diagram",
    "er": "er-diagram",
    "swimlane": "business-flow-swimlane",
    "data-flow": "data-flow",
    "uml-class": "class-diagram",
}
ALIAS_MAPPINGS = {
    "it-state": "architecture",
    "tree": "mind-map",
    "high-level": "architecture",
    "dp-integration": "data-flow",
    "dependency": "relationship",
}
TEMPLATE_EVAL_FIELDS = frozenset(
    {
        "id",
        "kind",
        "template_id",
        "prompt",
        "expected_output",
        "files",
        "expectations",
    }
)
ROUTING_EVAL_FIELDS = frozenset(
    {
        "id",
        "kind",
        "routing_alias",
        "expected_template_id",
        "prompt",
        "expected_output",
        "files",
        "expectations",
    }
)
NEW_MAPPINGS = {
    template_id: template_id
    for template_id in EXPECTED_TEMPLATE_IDS
    if template_id
    not in {
        "architecture",
        "flowchart",
        "relationship",
        "mind-map",
        "data-flow",
        "business-flow-swimlane",
        "class-diagram",
        "sequence-diagram",
        "er-diagram",
    }
}
EXPECTED_COVERAGE = {
    **{slug: (template_id, "direct") for slug, template_id in DIRECT_MAPPINGS.items()},
    **{slug: (template_id, "alias") for slug, template_id in ALIAS_MAPPINGS.items()},
    **{slug: (template_id, "new") for slug, template_id in NEW_MAPPINGS.items()},
}

GEOMETRY_PROFILES = frozenset(
    {
        "default",
        "cartesian",
        "radial",
        "containment",
        "matrix",
        "timeline",
        "ribbon",
        "schema",
        "freeform",
    }
)
PROFILE_REQUIRED_ROLES = {
    "cartesian": frozenset({"axes", "data"}),
    "radial": frozenset({"radial-axis", "cycle"}),
    "containment": frozenset({"container", "content"}),
    "matrix": frozenset({"row", "column", "cell"}),
    "timeline": frozenset({"time-axis", "time-item"}),
    "ribbon": frozenset({"flow-band"}),
    "schema": frozenset({"table", "column", "fk"}),
}
PROFILE_ALTERNATIVE_ROLES = {"radial": ("radial-axis", "cycle")}
PROFILE_ROLE_TYPES = {
    "cartesian": {
        "axes": frozenset({"arrow", "line"}),
        "data": frozenset({"diamond", "ellipse", "line", "rectangle"}),
    },
    "radial": {
        "radial-axis": frozenset({"ellipse", "line"}),
        "cycle": frozenset({"arrow"}),
        "data-series": frozenset({"ellipse", "line"}),
    },
    "containment": {
        "container": frozenset({"rectangle"}),
        "content": frozenset({"rectangle", "text"}),
    },
    "matrix": {
        "row": frozenset({"rectangle"}),
        "column": frozenset({"rectangle"}),
        "cell": frozenset({"rectangle"}),
        "card": frozenset({"rectangle"}),
        "story": frozenset({"rectangle"}),
    },
    "timeline": {
        "time-axis": frozenset({"arrow", "line"}),
        "time-item": frozenset({"diamond", "rectangle"}),
        "task": frozenset({"rectangle"}),
    },
    "ribbon": {"flow-band": frozenset({"arrow"})},
    "schema": {
        "table": frozenset({"rectangle"}),
        "column": frozenset({"text"}),
        "fk": frozenset({"arrow", "text"}),
    },
}
NAMED_LIMIT_ROLES = {
    "boundaries": "boundary",
    "decisions": "decision",
    "stores": "data-store",
    "bands": "flow-band",
}
EXEMPTION_OWNERS = {
    "curved-cycle": frozenset({"loop"}),
    "radial-series": frozenset({"radar", "polar"}),
    "overlap-sets": frozenset({"venn"}),
    "variable-width-band": frozenset({"sankey"}),
    "diagonal-spine": frozenset({"fishbone"}),
    "sentiment-curve": frozenset({"journey"}),
    "row-anchored-fk": frozenset({"db-schema"}),
}

REQUIRED_CATALOG_KEYS = ("version", "defaultStyle", "templates")
REQUIRED_ENTRY_KEYS = (
    "id",
    "diagramType",
    "style",
    "description",
    "bestFor",
    "avoidWhen",
    "nodeBudget",
    "edgeBudget",
    "templateFile",
    "previewFile",
    "upstreamSlugs",
    "primaryQuestion",
    "confusableWith",
    "semanticMinimums",
    "limits",
    "geometryProfile",
    "geometryExemptions",
)


class JsonLoadError(ValueError):
    """Raised when a validation input cannot be loaded as JSON."""


CatalogLoadError = JsonLoadError


def _load_json(path: Path, label: PurePosixPath) -> dict[str, Any]:
    try:
        raw = path.read_text(encoding="utf-8")
    except OSError as error:
        raise JsonLoadError(f"Cannot read {label}: {error}") from error

    try:
        data = json.loads(raw)
    except json.JSONDecodeError as error:
        raise JsonLoadError(f"Invalid JSON in {label}: {error}") from error

    if not isinstance(data, dict):
        raise JsonLoadError(f"{label} must contain a JSON object")
    return data


def load_catalog(skill_root: Path = SKILL_ROOT) -> dict[str, Any]:
    """Load the catalog below skill_root."""
    return _load_json(skill_root / CATALOG_PATH, CATALOG_PATH)


def load_coverage(skill_root: Path = SKILL_ROOT) -> dict[str, Any]:
    """Load the upstream coverage map below skill_root."""
    return _load_json(skill_root / COVERAGE_PATH, COVERAGE_PATH)


def load_evals(skill_root: Path = SKILL_ROOT) -> dict[str, Any]:
    """Load the eval suite below skill_root."""
    return _load_json(skill_root / EVALS_PATH, EVALS_PATH)


def _safe_catalog_path(
    value: object,
    field_name: str,
    expected_directory: str,
    expected_suffix: str,
    skill_root: Path,
) -> tuple[Path | None, list[str]]:
    if not isinstance(value, str) or not value:
        return None, [f"field '{field_name}' must be a non-empty string"]
    if "\\" in value:
        return None, [f"field '{field_name}' must use skill-root-relative POSIX paths"]

    errors: list[str] = []
    relative_path = PurePosixPath(value)
    windows_path = PureWindowsPath(value)
    if relative_path.is_absolute() or windows_path.is_absolute() or windows_path.drive:
        errors.append(f"field '{field_name}' must be relative to the skill root")
    if ".." in relative_path.parts:
        errors.append(f"field '{field_name}' must not contain '..'")
    if not relative_path.parts or relative_path.parts[0] != expected_directory:
        errors.append(f"field '{field_name}' must be under {expected_directory}/")
    if relative_path.suffix != expected_suffix:
        errors.append(f"field '{field_name}' must end with '{expected_suffix}'")

    root = skill_root.resolve()
    resolved = (root / Path(*relative_path.parts)).resolve()
    if not resolved.is_relative_to(root):
        errors.append(f"field '{field_name}' resolves outside the skill root")
    return (None if errors else resolved), errors


def _is_non_negative_integer(value: object) -> bool:
    return isinstance(value, int) and not isinstance(value, bool) and value >= 0


def _validate_string_array(
    value: object,
    label: str,
    *,
    allow_empty: bool,
) -> list[str]:
    if not isinstance(value, list):
        return [f"{label} must be an array of strings"]
    if not allow_empty and not value:
        return [f"{label} must be a non-empty array of strings"]
    if any(not isinstance(item, str) or not item for item in value):
        return [f"{label} must contain only non-empty strings"]
    if len(value) != len(set(cast(list[str], value))):
        return [f"{label} must contain unique strings"]
    return []


def _required_roles_for_profile(profile: object) -> tuple[frozenset[str], tuple[str, ...]]:
    if not isinstance(profile, str):
        return frozenset(), ()
    required = PROFILE_REQUIRED_ROLES.get(profile, frozenset())
    alternatives = PROFILE_ALTERNATIVE_ROLES.get(profile, ())
    if alternatives:
        required = required - frozenset(alternatives)
    return required, alternatives


def _role_for_limit(limit_name: str) -> str:
    configured = NAMED_LIMIT_ROLES.get(limit_name)
    if configured is not None:
        return configured
    if limit_name == "series":
        return "series"
    if limit_name.endswith("ies"):
        return f"{limit_name[:-3]}y"
    if limit_name.endswith("s"):
        return limit_name[:-1]
    return limit_name


def validate_catalog_contract(
    catalog: object, skill_root: Path = SKILL_ROOT, *, strict: bool = True
) -> list[str]:
    """Validate the v2 catalog schema without requiring asset files."""
    if not isinstance(catalog, dict):
        return ["Catalog must be a JSON object"]
    catalog = cast(dict[str, Any], catalog)

    errors: list[str] = []
    for key in REQUIRED_CATALOG_KEYS:
        if key not in catalog:
            errors.append(f"Missing top-level field '{key}'")

    if catalog.get("version") != CATALOG_VERSION or isinstance(
        catalog.get("version"), bool
    ):
        errors.append(f"Top-level 'version' must be exactly {CATALOG_VERSION}")
    if catalog.get("defaultStyle") != CANONICAL_STYLE:
        errors.append(f"Top-level 'defaultStyle' must be '{CANONICAL_STYLE}'")

    entries = catalog.get("templates")
    if not isinstance(entries, list):
        errors.append("Top-level 'templates' must be an array")
        return errors
    if len(entries) != len(EXPECTED_TEMPLATE_IDS):
        errors.append(
            f"Top-level 'templates' must contain exactly {len(EXPECTED_TEMPLATE_IDS)} entries"
        )

    ids: dict[str, int] = {}
    template_paths: dict[str, int] = {}
    preview_paths: dict[str, int] = {}
    upstream_owners: dict[str, str] = {}
    confusable_references: list[tuple[str, str, str]] = []

    for position, entry in enumerate(entries):
        label = f"templates[{position}]"
        if not isinstance(entry, dict):
            errors.append(f"{label} must be an object")
            continue
        entry = cast(dict[str, Any], entry)

        entry_id = entry.get("id")
        if isinstance(entry_id, str) and entry_id:
            label = f"templates[{position}] ('{entry_id}')"
        for key in REQUIRED_ENTRY_KEYS:
            if key not in entry:
                errors.append(f"{label} is missing required field '{key}'")

        digest = entry.get("previewSourceSha256")
        if strict and (not isinstance(digest, str) or SHA256_PATTERN.fullmatch(digest) is None):
            errors.append(
                f"{label} field 'previewSourceSha256' must be a lowercase 64-hex SHA-256 digest"
            )

        for key in ("id", "diagramType", "style", "description", "primaryQuestion"):
            value = entry.get(key)
            if not isinstance(value, str) or not value:
                errors.append(f"{label} field '{key}' must be a non-empty string")

        if entry.get("diagramType") != entry_id:
            errors.append(f"{label} fields 'id' and 'diagramType' must be equal")
        if entry.get("style") != CANONICAL_STYLE:
            errors.append(f"{label} field 'style' must be '{CANONICAL_STYLE}'")

        for key in ("bestFor", "avoidWhen", "upstreamSlugs", "semanticMinimums"):
            errors.extend(
                _validate_string_array(
                    entry.get(key), f"{label} field '{key}'", allow_empty=False
                )
            )
        for key in ("confusableWith", "geometryExemptions"):
            errors.extend(
                _validate_string_array(
                    entry.get(key), f"{label} field '{key}'", allow_empty=True
                )
            )

        for key in ("nodeBudget", "edgeBudget"):
            if not _is_non_negative_integer(entry.get(key)):
                errors.append(f"{label} field '{key}' must be a non-negative integer")

        limits = entry.get("limits")
        if not isinstance(limits, dict) or not limits:
            errors.append(f"{label} field 'limits' must be a non-empty object")
        else:
            limits = cast(dict[Any, Any], limits)
            for key, value in limits.items():
                if not isinstance(key, str) or not key:
                    errors.append(f"{label} field 'limits' keys must be non-empty strings")
                if not _is_non_negative_integer(value):
                    errors.append(
                        f"{label} field 'limits.{key}' must be a non-negative integer"
                    )
            for key in ("majorNodes", "edges"):
                if key not in limits:
                    errors.append(f"{label} field 'limits' must include '{key}'")
            if entry.get("nodeBudget") != limits.get("majorNodes"):
                errors.append(
                    f"{label} field 'nodeBudget' must equal 'limits.majorNodes'"
                )
            if entry.get("edgeBudget") != limits.get("edges"):
                errors.append(f"{label} field 'edgeBudget' must equal 'limits.edges'")

        profile = entry.get("geometryProfile")
        if profile not in GEOMETRY_PROFILES:
            errors.append(
                f"{label} field 'geometryProfile' must be one of {sorted(GEOMETRY_PROFILES)}"
            )

        semantic_minimums = entry.get("semanticMinimums")
        if isinstance(semantic_minimums, list) and all(
            isinstance(role, str) for role in semantic_minimums
        ):
            role_set = set(cast(list[str], semantic_minimums))
            required_roles, alternatives = _required_roles_for_profile(profile)
            for role in sorted(required_roles - role_set):
                errors.append(
                    f"{label} semanticMinimums is missing profile-required role '{role}'"
                )
            if alternatives and not role_set.intersection(alternatives):
                errors.append(
                    f"{label} semanticMinimums must include one of profile roles {list(alternatives)}"
                )

        exemptions = entry.get("geometryExemptions")
        if isinstance(exemptions, list):
            for exemption in exemptions:
                if not isinstance(exemption, str):
                    continue
                owners = EXEMPTION_OWNERS.get(exemption)
                if owners is None:
                    errors.append(
                        f"{label} geometry exemption '{exemption}' is not recognized"
                    )
                elif entry_id not in owners:
                    errors.append(
                        f"{label} geometry exemption '{exemption}' is not valid for this type"
                    )

        if isinstance(entry_id, str) and entry_id:
            if entry_id in ids:
                errors.append(f"{label} duplicates id from templates[{ids[entry_id]}]")
            else:
                ids[entry_id] = position

        upstream_slugs = entry.get("upstreamSlugs")
        if isinstance(upstream_slugs, list) and isinstance(entry_id, str):
            for slug in upstream_slugs:
                if not isinstance(slug, str) or not slug:
                    continue
                if slug in upstream_owners:
                    errors.append(
                        f"{label} upstream slug '{slug}' is already owned by "
                        f"'{upstream_owners[slug]}'"
                    )
                else:
                    upstream_owners[slug] = entry_id

        confusable = entry.get("confusableWith")
        if isinstance(confusable, list) and isinstance(entry_id, str):
            for reference in confusable:
                if isinstance(reference, str):
                    confusable_references.append((label, entry_id, reference))

        for field_name, directory, suffix, known_paths in (
            ("templateFile", "templates", ".excalidraw", template_paths),
            ("previewFile", "previews", ".png", preview_paths),
        ):
            value = entry.get(field_name)
            _, path_errors = _safe_catalog_path(
                value, field_name, directory, suffix, skill_root
            )
            errors.extend(f"{label} {error}" for error in path_errors)
            if not path_errors and isinstance(value, str):
                normalized = PurePosixPath(value).as_posix()
                if normalized in known_paths:
                    errors.append(
                        f"{label} field '{field_name}' duplicates "
                        f"templates[{known_paths[normalized]}]"
                    )
                else:
                    known_paths[normalized] = position

    actual_ids = set(ids)
    missing_ids = sorted(EXPECTED_TEMPLATE_IDS - actual_ids)
    unexpected_ids = sorted(actual_ids - EXPECTED_TEMPLATE_IDS)
    if missing_ids:
        errors.append(f"Catalog is missing expected template IDs: {missing_ids}")
    if unexpected_ids:
        errors.append(f"Catalog has unexpected template IDs: {unexpected_ids}")

    for label, entry_id, reference in confusable_references:
        if reference == entry_id:
            errors.append(f"{label} field 'confusableWith' must not reference itself")
        elif reference not in actual_ids:
            errors.append(
                f"{label} field 'confusableWith' references unknown ID '{reference}'"
            )

    expected_slugs = set(EXPECTED_COVERAGE)
    actual_slugs = set(upstream_owners)
    if actual_slugs != expected_slugs:
        errors.append(
            "Catalog upstreamSlugs must exactly match the 39 upstream slugs; "
            f"missing={sorted(expected_slugs - actual_slugs)}, "
            f"unexpected={sorted(actual_slugs - expected_slugs)}"
        )
    return errors


def _catalog_paths(catalog: object, field_name: str) -> set[str]:
    if not isinstance(catalog, dict):
        return set()
    catalog_data = cast(dict[str, Any], catalog)
    entries = catalog_data.get("templates")
    if not isinstance(entries, list):
        return set()
    paths: set[str] = set()
    for entry in entries:
        if isinstance(entry, dict) and isinstance(entry.get(field_name), str):
            paths.add(PurePosixPath(entry[field_name]).as_posix())
    return paths


def validate_asset_sets(
    catalog: object, skill_root: Path = SKILL_ROOT, *, strict: bool = True
) -> list[str]:
    """Validate exact source assets and, in strict mode, preview provenance."""
    errors: list[str] = []
    catalog_templates = _catalog_paths(catalog, "templateFile")
    catalog_previews = _catalog_paths(catalog, "previewFile")

    templates_directory = skill_root / "templates"
    previews_directory = skill_root / "previews"
    disk_templates = (
        {
            path.relative_to(skill_root).as_posix()
            for path in templates_directory.rglob("*.excalidraw")
            if path.is_file()
        }
        if templates_directory.is_dir()
        else set()
    )
    disk_previews = (
        {
            path.relative_to(skill_root).as_posix()
            for path in previews_directory.rglob("*.png")
            if path.is_file()
        }
        if previews_directory.is_dir()
        else set()
    )

    if not templates_directory.is_dir():
        errors.append("templates/ directory does not exist")
    if strict and not previews_directory.is_dir():
        errors.append("previews/ directory does not exist")
    for path in sorted(catalog_templates - disk_templates):
        errors.append(f"Catalog templateFile does not exist: {path}")
    for path in sorted(disk_templates - catalog_templates):
        errors.append(f"Template file is not cataloged: {path}")
    if strict:
        for path in sorted(catalog_previews - disk_previews):
            errors.append(f"Catalog previewFile does not exist: {path}")
        for path in sorted(disk_previews - catalog_previews):
            errors.append(f"Preview file is not cataloged: {path}")

    if not isinstance(catalog, dict):
        return errors
    catalog_data = cast(dict[str, Any], catalog)
    entries = catalog_data.get("templates")
    if not isinstance(entries, list):
        return errors
    for entry in entries:
        if not isinstance(entry, dict):
            continue
        source_value = entry.get("templateFile")
        preview_value = entry.get("previewFile")
        if not isinstance(source_value, str) or not isinstance(preview_value, str):
            continue
        source_path, source_path_errors = _safe_catalog_path(
            source_value, "templateFile", "templates", ".excalidraw", skill_root
        )
        preview_path, preview_path_errors = _safe_catalog_path(
            preview_value, "previewFile", "previews", ".png", skill_root
        )
        if source_path_errors or preview_path_errors:
            continue
        if source_path is None or preview_path is None:
            continue
        if not strict or not source_path.is_file() or not preview_path.is_file():
            continue
        try:
            source_digest = hashlib.sha256(source_path.read_bytes()).hexdigest()
            signature = preview_path.read_bytes()[:8]
        except OSError as error:
            errors.append(f"Cannot inspect asset pair for '{entry.get('id')}': {error}")
            continue
        if signature != b"\x89PNG\r\n\x1a\n":
            errors.append(f"Preview file is not a valid PNG: {preview_value}")
        if entry.get("previewSourceSha256") != source_digest:
            errors.append(
                f"Preview source digest is stale for '{entry.get('id')}': "
                f"previewSourceSha256 does not match {source_value}"
            )
    return errors


def ready_template_ids(catalog: object, skill_root: Path = SKILL_ROOT) -> set[str]:
    """Return catalog IDs whose source and preview assets both exist."""
    if not isinstance(catalog, dict):
        return set()
    catalog_data = cast(dict[str, Any], catalog)
    entries = catalog_data.get("templates")
    if not isinstance(entries, list):
        return set()
    ready: set[str] = set()
    for entry in entries:
        if not isinstance(entry, dict):
            continue
        entry_id = entry.get("id")
        source = entry.get("templateFile")
        preview = entry.get("previewFile")
        if (
            isinstance(entry_id, str)
            and isinstance(source, str)
            and isinstance(preview, str)
            and (skill_root / source).is_file()
            and (skill_root / preview).is_file()
        ):
            ready.add(entry_id)
    return ready


def validate_catalog(
    catalog: object, skill_root: Path = SKILL_ROOT, *, strict: bool = True
) -> list[str]:
    """Validate the catalog contract and its local asset sets."""
    return validate_catalog_contract(catalog, skill_root, strict=strict) + validate_asset_sets(
        catalog, skill_root, strict=strict
    )


def validate_coverage(coverage: object, catalog: object) -> list[str]:
    """Validate exact upstream provenance, mappings, statuses, and counts."""
    if not isinstance(coverage, dict):
        return ["Coverage map must be a JSON object"]
    coverage = cast(dict[str, Any], coverage)
    errors: list[str] = []

    if coverage.get("schema") != COVERAGE_SCHEMA:
        errors.append(f"Coverage 'schema' must be '{COVERAGE_SCHEMA}'")
    if coverage.get("version") != COVERAGE_VERSION or isinstance(
        coverage.get("version"), bool
    ):
        errors.append(f"Coverage 'version' must be exactly {COVERAGE_VERSION}")

    upstream = coverage.get("upstream")
    if not isinstance(upstream, dict):
        errors.append("Coverage 'upstream' must be an object")
    else:
        expected_upstream = {
            "repository": UPSTREAM_REPOSITORY,
            "commit": UPSTREAM_COMMIT,
            "templateCount": UPSTREAM_TEMPLATE_COUNT,
        }
        for key, expected in expected_upstream.items():
            if upstream.get(key) != expected or (
                key == "templateCount" and isinstance(upstream.get(key), bool)
            ):
                errors.append(f"Coverage upstream.{key} must be {expected!r}")

    items = coverage.get("coverage")
    if not isinstance(items, list):
        errors.append("Coverage 'coverage' must be an array")
        return errors
    if len(items) != UPSTREAM_TEMPLATE_COUNT:
        errors.append(
            f"Coverage must contain exactly {UPSTREAM_TEMPLATE_COUNT} entries"
        )

    catalog_ids: set[str] = set()
    catalog_owners: dict[str, str] = {}
    if isinstance(catalog, dict):
        catalog_data = cast(dict[str, Any], catalog)
        entries = catalog_data.get("templates")
        if not isinstance(entries, list):
            entries = []
        for entry in entries:
            if not isinstance(entry, dict) or not isinstance(entry.get("id"), str):
                continue
            entry_id = cast(str, entry["id"])
            catalog_ids.add(entry_id)
            if isinstance(entry.get("upstreamSlugs"), list):
                for slug in entry["upstreamSlugs"]:
                    if isinstance(slug, str):
                        catalog_owners[slug] = entry_id

    seen: dict[str, tuple[str, str]] = {}
    statuses: Counter[str] = Counter()
    for position, item in enumerate(items):
        label = f"coverage[{position}]"
        if not isinstance(item, dict):
            errors.append(f"{label} must be an object")
            continue
        item = cast(dict[str, Any], item)
        for key in ("upstreamSlug", "localTemplateId", "status", "rationale"):
            value = item.get(key)
            if not isinstance(value, str) or not value:
                errors.append(f"{label} field '{key}' must be a non-empty string")

        slug = item.get("upstreamSlug")
        local_id = item.get("localTemplateId")
        status = item.get("status")
        if status not in {"direct", "alias", "new"}:
            errors.append(f"{label} field 'status' must be direct, alias, or new")
        elif isinstance(status, str):
            statuses[status] += 1
        if isinstance(local_id, str) and local_id not in catalog_ids:
            errors.append(f"{label} references unknown localTemplateId '{local_id}'")
        if isinstance(slug, str) and isinstance(local_id, str) and isinstance(status, str):
            if slug in seen:
                errors.append(f"{label} duplicates upstreamSlug '{slug}'")
            else:
                seen[slug] = (local_id, status)

    expected_counts = {"direct": 7, "alias": 5, "new": 27}
    for status, expected in expected_counts.items():
        if statuses[status] != expected:
            errors.append(
                f"Coverage status '{status}' must have exactly {expected} entries; "
                f"found {statuses[status]}"
            )

    actual_slugs = set(seen)
    expected_slugs = set(EXPECTED_COVERAGE)
    if actual_slugs != expected_slugs:
        errors.append(
            "Coverage upstreamSlug set is not exact; "
            f"missing={sorted(expected_slugs - actual_slugs)}, "
            f"unexpected={sorted(actual_slugs - expected_slugs)}"
        )
    for slug in sorted(expected_slugs & actual_slugs):
        expected = EXPECTED_COVERAGE[slug]
        if seen[slug] != expected:
            errors.append(
                f"Coverage mapping for '{slug}' must be localTemplateId={expected[0]!r}, "
                f"status={expected[1]!r}"
            )
        owner = catalog_owners.get(slug)
        if owner != seen[slug][0]:
            errors.append(
                f"Coverage mapping for '{slug}' disagrees with catalog owner {owner!r}"
            )
    return errors


def validate_evals(evals: object, catalog: object) -> list[str]:
    """Validate exact template coverage and routing eval contracts."""
    if not isinstance(evals, dict):
        return ["Eval suite must be a JSON object"]
    evals = cast(dict[str, Any], evals)

    errors: list[str] = []
    expected_top_level_fields = {"skill_name", "evals"}
    actual_top_level_fields = set(evals)
    if actual_top_level_fields != expected_top_level_fields:
        errors.append(
            "Eval suite fields must be exactly "
            f"{sorted(expected_top_level_fields)}; "
            f"missing={sorted(expected_top_level_fields - actual_top_level_fields)}, "
            f"unexpected={sorted(actual_top_level_fields - expected_top_level_fields)}"
        )
    if evals.get("skill_name") != SKILL_NAME:
        errors.append(f"Eval suite 'skill_name' must be '{SKILL_NAME}'")

    cases = evals.get("evals")
    if not isinstance(cases, list):
        errors.append("Eval suite 'evals' must be an array")
        return errors
    if not cases:
        errors.append("Eval suite 'evals' must be a non-empty array")

    catalog_ids: set[str] = set()
    catalog_data = cast(dict[str, Any], catalog) if isinstance(catalog, dict) else {}
    catalog_entries = catalog_data.get("templates")
    if isinstance(catalog_entries, list):
        for entry in catalog_entries:
            if isinstance(entry, dict) and isinstance(entry.get("id"), str):
                catalog_ids.add(entry["id"])

    seen_ids: dict[int, int] = {}
    template_counts: Counter[str] = Counter()
    routing_cases: dict[str, list[str]] = {}
    routing_count = 0

    for position, case in enumerate(cases):
        label = f"evals[{position}]"
        if not isinstance(case, dict):
            errors.append(f"{label} must be an object")
            continue
        case = cast(dict[str, Any], case)

        case_id = case.get("id")
        if not isinstance(case_id, int) or isinstance(case_id, bool):
            errors.append(f"{label} field 'id' must be an integer")
        elif case_id in seen_ids:
            errors.append(f"{label} duplicates id from evals[{seen_ids[case_id]}]")
        else:
            seen_ids[case_id] = position

        kind = case.get("kind")
        if kind == "template":
            expected_fields = TEMPLATE_EVAL_FIELDS
        elif kind == "routing":
            expected_fields = ROUTING_EVAL_FIELDS
            routing_count += 1
        else:
            errors.append(f"{label} field 'kind' must be 'template' or 'routing'")
            continue

        actual_fields = set(case)
        if actual_fields != expected_fields:
            errors.append(
                f"{label} fields for kind '{kind}' must be exactly "
                f"{sorted(expected_fields)}; "
                f"missing={sorted(expected_fields - actual_fields)}, "
                f"unexpected={sorted(actual_fields - expected_fields)}"
            )

        for field_name in ("prompt", "expected_output"):
            value = case.get(field_name)
            if not isinstance(value, str) or not value:
                errors.append(
                    f"{label} field '{field_name}' must be a non-empty string"
                )
        errors.extend(
            _validate_string_array(
                case.get("files"), f"{label} field 'files'", allow_empty=True
            )
        )
        errors.extend(
            _validate_string_array(
                case.get("expectations"),
                f"{label} field 'expectations'",
                allow_empty=False,
            )
        )

        if kind == "template":
            template_id = case.get("template_id")
            if not isinstance(template_id, str) or not template_id:
                errors.append(
                    f"{label} field 'template_id' must be a non-empty string"
                )
            else:
                template_counts[template_id] += 1
                if template_id not in catalog_ids:
                    errors.append(
                        f"{label} references unknown template_id '{template_id}'"
                    )
            continue

        routing_alias = case.get("routing_alias")
        expected_template_id = case.get("expected_template_id")
        if not isinstance(routing_alias, str) or not routing_alias:
            errors.append(
                f"{label} field 'routing_alias' must be a non-empty string"
            )
        if not isinstance(expected_template_id, str) or not expected_template_id:
            errors.append(
                f"{label} field 'expected_template_id' must be a non-empty string"
            )
        elif expected_template_id not in catalog_ids:
            errors.append(
                f"{label} references unknown expected_template_id "
                f"'{expected_template_id}'"
            )
        if case.get("files") != []:
            errors.append(f"{label} routing field 'files' must be []")
        if isinstance(routing_alias, str) and routing_alias and isinstance(
            expected_template_id, str
        ):
            routing_cases.setdefault(routing_alias, []).append(expected_template_id)

    for template_id in sorted(catalog_ids):
        count = template_counts[template_id]
        if count != 1:
            errors.append(
                f"Template ID '{template_id}' must have exactly one template eval; "
                f"found {count}"
            )

    if routing_count != len(ALIAS_MAPPINGS):
        errors.append(
            f"Eval suite must have exactly {len(ALIAS_MAPPINGS)} routing cases; "
            f"found {routing_count}"
        )
    for routing_alias in sorted(set(routing_cases) - set(ALIAS_MAPPINGS)):
        errors.append(f"Routing eval has unexpected routing_alias '{routing_alias}'")
    for routing_alias, expected_template_id in sorted(ALIAS_MAPPINGS.items()):
        mappings = routing_cases.get(routing_alias, [])
        if len(mappings) != 1:
            errors.append(
                f"Routing alias '{routing_alias}' must have exactly one routing eval; "
                f"found {len(mappings)}"
            )
        elif mappings[0] != expected_template_id:
            errors.append(
                f"Routing alias '{routing_alias}' must map to "
                f"'{expected_template_id}', found '{mappings[0]}'"
            )
    return errors


def _validate_metadata_id_list(
    value: object,
    label: str,
    elements_by_id: dict[str, dict[str, Any]],
    *,
    allow_empty: bool,
    allowed_types: frozenset[str] | None = None,
) -> list[str]:
    errors = _validate_string_array(value, label, allow_empty=allow_empty)
    if errors or not isinstance(value, list):
        return errors
    for element_id in cast(list[str], value):
        element = elements_by_id.get(element_id)
        if element is None:
            errors.append(f"{label} references missing element ID '{element_id}'")
        elif element.get("isDeleted", False) is not False:
            errors.append(f"{label} references deleted element ID '{element_id}'")
        elif allowed_types is not None and element.get("type") not in allowed_types:
            allowed = ", ".join(sorted(allowed_types))
            errors.append(
                f"{label} element '{element_id}' must have one of types: {allowed}"
            )
    return errors


def _validate_profile_roles(
    semantic_roles: dict[str, Any], profile: object, elements_by_id: dict[str, dict[str, Any]]
) -> list[str]:
    errors: list[str] = []
    required_roles, alternatives = _required_roles_for_profile(profile)
    for role in sorted(required_roles):
        if not isinstance(semantic_roles.get(role), list) or not semantic_roles[role]:
            errors.append(f"geometry profile '{profile}' requires semantic role '{role}'")
    if alternatives and not any(
        isinstance(semantic_roles.get(role), list) and semantic_roles[role]
        for role in alternatives
    ):
        errors.append(
            f"geometry profile '{profile}' requires one of semantic roles {list(alternatives)}"
        )
    if isinstance(profile, str):
        for role, allowed_types in PROFILE_ROLE_TYPES.get(profile, {}).items():
            references = semantic_roles.get(role)
            if not isinstance(references, list):
                continue
            for element_id in references:
                if not isinstance(element_id, str):
                    continue
                element = elements_by_id.get(element_id)
                if element is None or element.get("isDeleted", False) is not False:
                    continue
                if element.get("type") not in allowed_types:
                    allowed = ", ".join(sorted(allowed_types))
                    errors.append(
                        f"geometry profile '{profile}' semantic role '{role}' element "
                        f"'{element_id}' must have one of types: {allowed}"
                    )
    return errors


def validate_template_metadata(data: object, entry: object) -> list[str]:
    """Validate one scene's metadata references, roles, and budgets."""
    if not isinstance(data, dict):
        return ["Scene must be a JSON object"]
    if not isinstance(entry, dict):
        return ["Catalog entry must be an object"]
    data = cast(dict[str, Any], data)
    entry = cast(dict[str, Any], entry)

    elements = data.get("elements")
    elements_by_id: dict[str, dict[str, Any]] = {}
    if isinstance(elements, list):
        for element in elements:
            if isinstance(element, dict) and isinstance(element.get("id"), str):
                elements_by_id[element["id"]] = cast(dict[str, Any], element)

    metadata = data.get("templateMetadata")
    if not isinstance(metadata, dict):
        return ["Top-level 'templateMetadata' must be an object"]
    metadata = cast(dict[str, Any], metadata)
    errors: list[str] = []

    if metadata.get("templateId") != entry.get("id"):
        errors.append("templateMetadata.templateId must exactly match catalog id")
    errors.extend(
        _validate_metadata_id_list(
            metadata.get("majorNodeIds"),
            "templateMetadata.majorNodeIds",
            elements_by_id,
            allow_empty=False,
        )
    )
    errors.extend(
        _validate_metadata_id_list(
            metadata.get("edgeIds"),
            "templateMetadata.edgeIds",
            elements_by_id,
            allow_empty=True,
            allowed_types=frozenset({"arrow", "line"}),
        )
    )

    semantic_roles = metadata.get("semanticRoles")
    if not isinstance(semantic_roles, dict):
        errors.append("templateMetadata.semanticRoles must be an object")
        semantic_roles = {}
    else:
        semantic_roles = cast(dict[str, Any], semantic_roles)
        for role, references in semantic_roles.items():
            if not isinstance(role, str) or not role:
                errors.append(
                    "templateMetadata.semanticRoles keys must be non-empty strings"
                )
                continue
            errors.extend(
                _validate_metadata_id_list(
                    references,
                    f"templateMetadata.semanticRoles.{role}",
                    elements_by_id,
                    allow_empty=False,
                )
            )

    semantic_minimums = entry.get("semanticMinimums")
    if isinstance(semantic_minimums, list):
        for role in semantic_minimums:
            if isinstance(role, str) and (
                not isinstance(semantic_roles.get(role), list)
                or not semantic_roles[role]
            ):
                errors.append(f"templateMetadata is missing semantic role '{role}'")

    profile = entry.get("geometryProfile")
    if profile not in GEOMETRY_PROFILES:
        errors.append("Catalog entry has an invalid geometryProfile")
    else:
        errors.extend(_validate_profile_roles(semantic_roles, profile, elements_by_id))

    major_nodes = metadata.get("majorNodeIds")
    edge_ids = metadata.get("edgeIds")
    major_count = len(major_nodes) if isinstance(major_nodes, list) else 0
    edge_count = len(edge_ids) if isinstance(edge_ids, list) else 0
    limits = entry.get("limits")
    if isinstance(limits, dict):
        if _is_non_negative_integer(limits.get("majorNodes")) and major_count > limits[
            "majorNodes"
        ]:
            errors.append(
                f"templateMetadata has {major_count} major nodes, exceeding limits.majorNodes "
                f"of {limits['majorNodes']}"
            )
        if _is_non_negative_integer(limits.get("edges")) and edge_count > limits["edges"]:
            errors.append(
                f"templateMetadata has {edge_count} edges, exceeding limits.edges "
                f"of {limits['edges']}"
            )

        named_limits = {
            key: value
            for key, value in limits.items()
            if key not in {"majorNodes", "edges"} and isinstance(key, str)
        }
        counts = metadata.get("counts")
        if not isinstance(counts, dict):
            errors.append("templateMetadata.counts must be an object")
            counts = {}
        else:
            counts = cast(dict[str, Any], counts)

        role_counts: dict[str, tuple[str, list[str]]] = {}
        for limit_name in named_limits:
            role = _role_for_limit(limit_name)
            references = semantic_roles.get(role)
            if isinstance(references, list) and references:
                role_counts[limit_name] = (role, references)

        expected_count_keys = set(named_limits) - set(role_counts)
        actual_count_keys = set(counts)
        if actual_count_keys != expected_count_keys:
            errors.append(
                "templateMetadata.counts keys must exactly match named limits not encoded "
                f"by semantic roles; missing={sorted(expected_count_keys - actual_count_keys)}, "
                f"unexpected={sorted(actual_count_keys - expected_count_keys)}"
            )

        for limit_name, limit in named_limits.items():
            role_count = role_counts.get(limit_name)
            references = role_count[1] if role_count is not None else counts.get(limit_name)
            label = f"templateMetadata.counts.{limit_name}"
            if role_count is not None:
                label = f"templateMetadata.semanticRoles.{role_count[0]}"
            reference_errors = _validate_metadata_id_list(
                references,
                label,
                elements_by_id,
                allow_empty=True,
            )
            errors.extend(reference_errors)
            if (
                not reference_errors
                and isinstance(references, list)
                and _is_non_negative_integer(limit)
                and len(references) > limit
            ):
                errors.append(
                    f"templateMetadata has {len(references)} {limit_name}, exceeding "
                    f"limits.{limit_name} of {limit}"
                )
    if _is_non_negative_integer(entry.get("nodeBudget")) and major_count > entry[
        "nodeBudget"
    ]:
        errors.append(
            f"templateMetadata has {major_count} major nodes, exceeding nodeBudget "
            f"of {entry['nodeBudget']}"
        )
    if _is_non_negative_integer(entry.get("edgeBudget")) and edge_count > entry[
        "edgeBudget"
    ]:
        errors.append(
            f"templateMetadata has {edge_count} edges, exceeding edgeBudget "
            f"of {entry['edgeBudget']}"
        )
    return errors


def validate_source_templates(
    catalog: object, skill_root: Path = SKILL_ROOT
) -> dict[str, list[str]]:
    """Validate every cataloged source scene that is safely available."""
    issues: dict[str, list[str]] = {}
    if not isinstance(catalog, dict):
        return issues
    catalog = cast(dict[str, Any], catalog)
    entries = catalog.get("templates")
    if not isinstance(entries, list):
        return issues
    for entry in entries:
        if not isinstance(entry, dict):
            continue
        template_value = entry.get("templateFile")
        template_path, path_errors = _safe_catalog_path(
            template_value, "templateFile", "templates", ".excalidraw", skill_root
        )
        if path_errors or template_path is None or not template_path.is_file():
            continue
        relative_path = template_path.relative_to(skill_root.resolve()).as_posix()
        try:
            data = json.loads(template_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as error:
            issues.setdefault(relative_path, []).append(f"Cannot load template: {error}")
            continue
        template_errors = validate_template(data, entry)
        if template_errors:
            issues[relative_path] = template_errors
    return issues


def validate_template(data: object, entry: object) -> list[str]:
    """Validate one scene with generic, editorial-light, and metadata policy."""
    errors = validate_excalidraw(data)
    if not isinstance(data, dict):
        return errors
    data = cast(dict[str, Any], data)
    if not isinstance(entry, dict):
        return errors + ["Catalog entry must be an object"]
    entry = cast(dict[str, Any], entry)

    if entry.get("style") != CANONICAL_STYLE:
        errors.append(f"Catalog entry style must be '{CANONICAL_STYLE}'")

    elements = data.get("elements")
    if isinstance(elements, list):
        for position, element in enumerate(elements):
            if not isinstance(element, dict):
                continue
            element = cast(dict[str, Any], element)
            element_id = element.get("id")
            label = f"Element {position}"
            if isinstance(element_id, str) and element_id:
                label = f"Element {position} ('{element_id}')"

            if element.get("type") == "text":
                if element.get("fontFamily") != 5:
                    errors.append(f"{label} text field 'fontFamily' must be 5")
                font_size = element.get("fontSize")
                if (
                    not isinstance(font_size, (int, float))
                    or isinstance(font_size, bool)
                    or not math.isfinite(font_size)
                    or font_size < 16
                ):
                    errors.append(f"{label} text field 'fontSize' must be at least 16")
                if "originalText" not in element:
                    errors.append(f"{label} text element is missing 'originalText'")
                elif element.get("text") != element.get("originalText"):
                    errors.append(f"{label} fields 'text' and 'originalText' must be equal")
            elif "text" in element:
                errors.append(f"{label} must not embed a 'text' field in a shape")

            if element.get("type") == "arrow":
                for arrowhead in ("startArrowhead", "endArrowhead"):
                    if arrowhead not in element:
                        errors.append(f"{label} arrow is missing explicit '{arrowhead}'")

    app_state = data.get("appState")
    if not isinstance(app_state, dict):
        errors.append("Top-level 'appState' must be an object for canonical policy")
    else:
        if app_state.get("viewBackgroundColor") != CANONICAL_BACKGROUND:
            errors.append(
                f"appState.viewBackgroundColor must be '{CANONICAL_BACKGROUND}'"
            )
        if app_state.get("gridSize") != CANONICAL_GRID_SIZE:
            errors.append(f"appState.gridSize must be {CANONICAL_GRID_SIZE}")

    errors.extend(validate_template_metadata(data, entry))
    return errors


def validate_templates(skill_root: Path = SKILL_ROOT) -> dict[str, list[str]]:
    """Validate catalog, coverage, evals, and every available canonical scene."""
    issues: dict[str, list[str]] = {}
    try:
        catalog = load_catalog(skill_root)
    except JsonLoadError as error:
        return {CATALOG_PATH.as_posix(): [str(error)]}

    catalog_errors = validate_catalog(catalog, skill_root)
    if catalog_errors:
        issues[CATALOG_PATH.as_posix()] = catalog_errors

    try:
        coverage = load_coverage(skill_root)
    except JsonLoadError as error:
        issues[COVERAGE_PATH.as_posix()] = [str(error)]
    else:
        coverage_errors = validate_coverage(coverage, catalog)
        if coverage_errors:
            issues[COVERAGE_PATH.as_posix()] = coverage_errors

    try:
        evals = load_evals(skill_root)
    except JsonLoadError as error:
        issues[EVALS_PATH.as_posix()] = [str(error)]
    else:
        eval_errors = validate_evals(evals, catalog)
        if eval_errors:
            issues[EVALS_PATH.as_posix()] = eval_errors

    issues.update(validate_source_templates(catalog, skill_root))
    return issues


def main() -> int:
    issues = validate_templates()
    if issues:
        error_count = sum(len(errors) for errors in issues.values())
        for path, errors in issues.items():
            print(f"{path}:", file=sys.stderr)
            for error in errors:
                print(f"  - {error}", file=sys.stderr)
        print(f"Validation failed with {error_count} error(s).", file=sys.stderr)
        return 1

    catalog = load_catalog()
    print(f"Validated {len(catalog['templates'])} template(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
