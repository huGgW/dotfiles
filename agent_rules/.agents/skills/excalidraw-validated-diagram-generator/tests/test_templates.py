"""Tests for the shared catalog v2 and Excalidraw template policy."""

from __future__ import annotations

import copy
import hashlib
import importlib.util
import json
import shutil
import tempfile
import unittest
from pathlib import Path
from types import ModuleType
from typing import Any, Callable, cast
from unittest import mock


SKILL_ROOT = Path(__file__).resolve().parents[1]


def load_module(name: str, path: Path) -> ModuleType:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"Cannot load module from {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


renderer = load_module(
    "tested_excalidraw_renderer", SKILL_ROOT / "references/render_excalidraw.py"
)
validator = load_module(
    "tested_template_validator", SKILL_ROOT / "scripts/validate_templates.py"
)
batch_renderer = load_module(
    "tested_template_batch_renderer", SKILL_ROOT / "scripts/render_templates.py"
)
validate_excalidraw = cast(Callable[[object], list[str]], renderer.validate_excalidraw)
load_catalog = cast(Callable[[], dict[str, Any]], validator.load_catalog)
load_coverage = cast(Callable[[], dict[str, Any]], validator.load_coverage)
validate_catalog_contract = cast(
    Callable[[object], list[str]], validator.validate_catalog_contract
)
validate_catalog = cast(Callable[..., list[str]], validator.validate_catalog)
validate_asset_sets = cast(
    Callable[[object, Path], list[str]], validator.validate_asset_sets
)
validate_coverage = cast(
    Callable[[object, object], list[str]], validator.validate_coverage
)
validate_evals = cast(Callable[[object, object], list[str]], validator.validate_evals)
validate_template = cast(
    Callable[[object, object], list[str]], validator.validate_template
)
validate_template_metadata = cast(
    Callable[[object, object], list[str]], validator.validate_template_metadata
)
validate_templates = cast(Callable[[], dict[str, list[str]]], validator.validate_templates)
render_templates = cast(Callable[..., list[Path]], batch_renderer.render_templates)
ready_template_ids = cast(
    Callable[[object, Path], set[str]], validator.ready_template_ids
)
CANONICAL_STYLE = cast(str, validator.CANONICAL_STYLE)


EXPECTED_TEMPLATE_IDS = {
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
EXPECTED_DIRECT_MAPPINGS = {
    "architecture": "architecture",
    "flowchart": "flowchart",
    "sequence": "sequence-diagram",
    "er": "er-diagram",
    "swimlane": "business-flow-swimlane",
    "data-flow": "data-flow",
    "uml-class": "class-diagram",
}
EXPECTED_ROUTING_MAPPINGS = {
    "it-state": "architecture",
    "tree": "mind-map",
    "high-level": "architecture",
    "dp-integration": "data-flow",
    "dependency": "relationship",
}


def valid_evals(template_ids: set[str]) -> dict[str, Any]:
    cases: list[dict[str, Any]] = []
    for case_id, template_id in enumerate(sorted(template_ids), start=1):
        cases.append(
            {
                "id": case_id,
                "kind": "template",
                "template_id": template_id,
                "prompt": f"Create a {template_id} diagram.",
                "expected_output": f"A validated {template_id} diagram.",
                "files": [],
                "expectations": [f"The selected template is {template_id}."],
            }
        )
    for case_id, (routing_alias, template_id) in enumerate(
        sorted(EXPECTED_ROUTING_MAPPINGS.items()), start=len(cases) + 1
    ):
        cases.append(
            {
                "id": case_id,
                "kind": "routing",
                "routing_alias": routing_alias,
                "expected_template_id": template_id,
                "prompt": f"Route the {routing_alias} request.",
                "expected_output": f"The request uses {template_id}.",
                "files": [],
                "expectations": [f"The selected template is {template_id}."],
            }
        )
    return {
        "skill_name": "excalidraw-validated-diagram-generator",
        "evals": cases,
    }


def valid_entry() -> dict[str, Any]:
    return {
        "id": "example",
        "style": CANONICAL_STYLE,
        "semanticMinimums": ["node", "connection"],
        "limits": {"majorNodes": 2, "edges": 2},
        "nodeBudget": 2,
        "edgeBudget": 2,
        "geometryProfile": "default",
    }


def valid_scene() -> dict[str, Any]:
    return {
        "type": "excalidraw",
        "version": 2,
        "source": "https://excalidraw.com",
        "elements": [
            {
                "id": "box",
                "type": "rectangle",
                "x": 0,
                "y": 0,
                "width": 160,
                "height": 80,
                "angle": 0,
                "index": "a0",
                "opacity": 100,
                "version": 1,
                "boundElements": [{"type": "arrow", "id": "arrow"}],
            },
            {
                "id": "label",
                "type": "text",
                "x": 24,
                "y": 24,
                "width": 112,
                "height": 24,
                "angle": 0,
                "index": "a1",
                "opacity": 100,
                "version": 1,
                "text": "Example",
                "originalText": "Example",
                "fontFamily": 5,
                "fontSize": 16,
            },
            {
                "id": "arrow",
                "type": "arrow",
                "x": 160,
                "y": 40,
                "width": 120,
                "height": 0,
                "angle": 0,
                "index": "a2",
                "opacity": 100,
                "version": 1,
                "points": [[0, 0], [120, 0]],
                "startBinding": {"elementId": "box", "focus": 0, "gap": 0},
                "endBinding": None,
                "startArrowhead": None,
                "endArrowhead": "arrow",
            },
        ],
        "templateMetadata": {
            "templateId": "example",
            "majorNodeIds": ["box"],
            "edgeIds": ["arrow"],
            "counts": {},
            "semanticRoles": {
                "node": ["box"],
                "connection": ["arrow"],
            },
        },
        "appState": {"viewBackgroundColor": "#ffffff", "gridSize": 20},
        "files": {},
    }


class CatalogContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.catalog = load_catalog()
        cls.coverage = load_coverage()
        cls.entries = {entry["id"]: entry for entry in cls.catalog["templates"]}

    def test_catalog_v2_contract_and_exact_ids(self) -> None:
        self.assertEqual([], validate_catalog_contract(self.catalog))
        self.assertEqual(2, self.catalog["version"])
        self.assertEqual(CANONICAL_STYLE, self.catalog["defaultStyle"])
        self.assertEqual(EXPECTED_TEMPLATE_IDS, set(self.entries))

    def test_upstream_coverage_contract(self) -> None:
        self.assertEqual([], validate_coverage(self.coverage, self.catalog))
        mappings = {
            item["upstreamSlug"]: item["localTemplateId"]
            for item in self.coverage["coverage"]
            if item["status"] == "direct"
        }
        status_counts = {
            status: sum(
                item["status"] == status for item in self.coverage["coverage"]
            )
            for status in ("direct", "alias", "new")
        }
        self.assertEqual(EXPECTED_DIRECT_MAPPINGS, mappings)
        self.assertEqual({"direct": 7, "alias": 5, "new": 27}, status_counts)

    def test_ready_set_contains_all_36_catalog_assets(self) -> None:
        self.assertEqual(
            EXPECTED_TEMPLATE_IDS, ready_template_ids(self.catalog, SKILL_ROOT)
        )

    def test_all_templates_have_valid_metadata_and_policy(self) -> None:
        for template_id in sorted(EXPECTED_TEMPLATE_IDS):
            entry = self.entries[template_id]
            data = json.loads(
                (SKILL_ROOT / entry["templateFile"]).read_text(encoding="utf-8")
            )
            with self.subTest(template=template_id):
                self.assertEqual([], validate_template(data, entry))

    def test_integrated_validation_passes(self) -> None:
        self.assertEqual({}, validate_templates())


class EvalContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.catalog = load_catalog()

    def assert_has_error(self, errors: list[str], expected: str) -> None:
        self.assertTrue(
            any(expected in error for error in errors),
            f"Expected an error containing {expected!r}, got: {errors}",
        )

    def test_complete_template_and_routing_fixture_passes(self) -> None:
        evals = valid_evals(EXPECTED_TEMPLATE_IDS)

        self.assertEqual([], validate_evals(evals, self.catalog))
        self.assertEqual(
            36, sum(case["kind"] == "template" for case in evals["evals"])
        )
        self.assertEqual(
            5, sum(case["kind"] == "routing" for case in evals["evals"])
        )

    def test_duplicate_and_missing_template_evals_are_rejected(self) -> None:
        evals = valid_evals(EXPECTED_TEMPLATE_IDS)
        template_cases = [
            case for case in evals["evals"] if case["kind"] == "template"
        ]
        duplicate_id = template_cases[0]["template_id"]
        missing_id = template_cases[-1]["template_id"]
        template_cases[-1]["template_id"] = duplicate_id

        errors = validate_evals(evals, self.catalog)

        self.assert_has_error(
            errors,
            f"Template ID '{duplicate_id}' must have exactly one template eval; found 2",
        )
        self.assert_has_error(
            errors,
            f"Template ID '{missing_id}' must have exactly one template eval; found 0",
        )

    def test_wrong_routing_alias_mapping_is_rejected(self) -> None:
        evals = valid_evals(EXPECTED_TEMPLATE_IDS)
        routing_case = next(
            case
            for case in evals["evals"]
            if case.get("routing_alias") == "dependency"
        )
        routing_case["expected_template_id"] = "architecture"

        errors = validate_evals(evals, self.catalog)

        self.assert_has_error(
            errors,
            "Routing alias 'dependency' must map to 'relationship', found 'architecture'",
        )

    def test_malformed_eval_fields_are_rejected(self) -> None:
        evals = valid_evals(EXPECTED_TEMPLATE_IDS)
        template_case = evals["evals"][0]
        template_case["id"] = True
        template_case["prompt"] = ""
        template_case["files"] = [""]
        template_case["expectations"] = []
        template_case["template_id"] = "unknown"
        routing_case = evals["evals"][-1]
        routing_case["alias"] = routing_case.pop("routing_alias")
        routing_case["files"] = ["fixture.txt"]
        evals["evals"][2]["id"] = evals["evals"][1]["id"]

        errors = validate_evals(evals, self.catalog)

        for expected in (
            "field 'id' must be an integer",
            "duplicates id from evals[1]",
            "field 'prompt' must be a non-empty string",
            "field 'files' must contain only non-empty strings",
            "field 'expectations' must be a non-empty array of strings",
            "references unknown template_id 'unknown'",
            "unexpected=['alias']",
            "field 'routing_alias' must be a non-empty string",
            "routing field 'files' must be []",
        ):
            self.assert_has_error(errors, expected)


class InvalidContractTests(unittest.TestCase):
    def assert_has_error(self, errors: list[str], expected: str) -> None:
        self.assertTrue(
            any(expected in error for error in errors),
            f"Expected an error containing {expected!r}, got: {errors}",
        )

    def test_bad_metadata_reference_is_rejected(self) -> None:
        scene = valid_scene()
        scene["templateMetadata"]["majorNodeIds"] = ["missing"]

        errors = validate_template_metadata(scene, valid_entry())

        self.assert_has_error(errors, "references missing element ID 'missing'")

    def test_deleted_metadata_reference_is_rejected(self) -> None:
        scene = valid_scene()
        scene["elements"][0]["isDeleted"] = True

        errors = validate_template_metadata(scene, valid_entry())

        self.assert_has_error(errors, "references deleted element ID 'box'")

    def test_non_boolean_deleted_metadata_reference_is_rejected(self) -> None:
        for value in (1, "true", "false"):
            with self.subTest(value=value):
                scene = valid_scene()
                scene["elements"][0]["isDeleted"] = value

                errors = validate_template_metadata(scene, valid_entry())

                self.assert_has_error(errors, "references deleted element ID 'box'")

    def test_missing_semantic_role_is_rejected(self) -> None:
        scene = valid_scene()
        del scene["templateMetadata"]["semanticRoles"]["connection"]

        errors = validate_template_metadata(scene, valid_entry())

        self.assert_has_error(errors, "missing semantic role 'connection'")

    def test_budget_overflow_is_rejected(self) -> None:
        entry = valid_entry()
        entry["limits"]["majorNodes"] = 0
        entry["nodeBudget"] = 0

        errors = validate_template_metadata(valid_scene(), entry)

        self.assert_has_error(errors, "exceeding limits.majorNodes")
        self.assert_has_error(errors, "exceeding nodeBudget")

    def test_named_limit_overflow_is_rejected(self) -> None:
        entry = valid_entry()
        entry["limits"]["points"] = 0
        scene = valid_scene()
        scene["templateMetadata"]["counts"] = {"points": ["box"]}

        errors = validate_template_metadata(scene, entry)

        self.assert_has_error(errors, "exceeding limits.points")

    def test_configured_named_limit_roles_are_counted(self) -> None:
        cases = (
            ("boundaries", "boundary", "box"),
            ("decisions", "decision", "box"),
            ("stores", "data-store", "box"),
            ("bands", "flow-band", "arrow"),
        )
        for limit_name, role, element_id in cases:
            with self.subTest(limit=limit_name, role=role):
                entry = valid_entry()
                entry["limits"][limit_name] = 0
                scene = valid_scene()
                scene["templateMetadata"]["semanticRoles"][role] = [element_id]

                errors = validate_template_metadata(scene, entry)

                self.assert_has_error(errors, f"exceeding limits.{limit_name}")

    def test_named_limit_alias_cannot_mask_canonical_role_overflow(self) -> None:
        entry = valid_entry()
        entry["semanticMinimums"] = ["flow-band"]
        entry["geometryProfile"] = "ribbon"
        entry["limits"]["bands"] = 1
        scene = valid_scene()
        second_band = copy.deepcopy(scene["elements"][2])
        second_band["id"] = "flow-band-2"
        second_band["index"] = "a3"
        scene["elements"].append(second_band)
        scene["templateMetadata"]["semanticRoles"] = {
            "band": ["box"],
            "flow-band": ["arrow", "flow-band-2"],
        }

        errors = validate_template_metadata(scene, entry)

        self.assert_has_error(errors, "exceeding limits.bands")

    def test_profile_required_roles_are_rejected(self) -> None:
        entry = valid_entry()
        entry["semanticMinimums"] = []
        entry["geometryProfile"] = "matrix"

        errors = validate_template_metadata(valid_scene(), entry)

        for role in ("row", "column", "cell"):
            self.assert_has_error(errors, f"requires semantic role '{role}'")

    def test_profile_role_type_spoofing_is_rejected(self) -> None:
        entry = valid_entry()
        entry["semanticMinimums"] = ["axes", "data"]
        entry["geometryProfile"] = "cartesian"
        scene = valid_scene()
        scene["templateMetadata"]["semanticRoles"] = {
            "axes": ["label"],
            "data": ["box"],
        }

        errors = validate_template_metadata(scene, entry)

        self.assert_has_error(errors, "semantic role 'axes' element 'label'")

    def test_orphan_preview_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "templates").mkdir()
            (root / "previews").mkdir()
            (root / "previews/orphan.png").write_bytes(b"\x89PNG\r\n\x1a\n")

            errors = validate_asset_sets({"templates": []}, root)

        self.assert_has_error(errors, "Preview file is not cataloged: previews/orphan.png")

    def test_stale_preview_digest_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "templates").mkdir()
            (root / "previews").mkdir()
            source = root / "templates/example.excalidraw"
            preview = root / "previews/example.png"
            source.write_text("{}", encoding="utf-8")
            preview.write_bytes(b"\x89PNG\r\n\x1a\n")
            catalog = {
                "templates": [
                    {
                        "id": "example",
                        "templateFile": "templates/example.excalidraw",
                        "previewFile": "previews/example.png",
                        "previewSourceSha256": "0" * 64,
                    }
                ]
            }

            errors = validate_asset_sets(catalog, root)

        self.assert_has_error(errors, "Preview source digest is stale")

    def test_invalid_coverage_count_and_mapping_are_rejected(self) -> None:
        catalog = load_catalog()
        coverage = load_coverage()

        bad_count = copy.deepcopy(coverage)
        bad_count["coverage"].pop()
        self.assert_has_error(
            validate_coverage(bad_count, catalog), "must contain exactly 39 entries"
        )

        bad_mapping = copy.deepcopy(coverage)
        architecture = next(
            item
            for item in bad_mapping["coverage"]
            if item["upstreamSlug"] == "architecture"
        )
        architecture["localTemplateId"] = "flowchart"
        self.assert_has_error(
            validate_coverage(bad_mapping, catalog),
            "Coverage mapping for 'architecture'",
        )


class RenderingWorkflowTests(unittest.TestCase):
    def copy_assets(self, root: Path) -> None:
        shutil.copytree(SKILL_ROOT / "templates", root / "templates")
        shutil.copytree(SKILL_ROOT / "previews", root / "previews")

    def fake_render(self, source: Path, destination: Path) -> Path:
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(b"\x89PNG\r\n\x1a\n")
        return destination

    def test_missing_preview_is_repaired_without_chromium(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.copy_assets(root)
            catalog = json.loads((root / "templates/catalog.json").read_text())
            entry = next(item for item in catalog["templates"] if item["id"] == "bar")
            (root / entry["previewFile"]).unlink()

            with mock.patch.object(
                batch_renderer, "render", side_effect=self.fake_render
            ) as mocked_render:
                rendered = render_templates(["bar"], skill_root=root)

            repaired_catalog = json.loads(
                (root / "templates/catalog.json").read_text(encoding="utf-8")
            )
            strict_errors = validate_catalog(repaired_catalog, root, strict=True)

        self.assertEqual([root / entry["previewFile"]], rendered)
        mocked_render.assert_called_once()
        self.assertEqual([], strict_errors)

    def test_stale_digest_is_repaired_without_chromium(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.copy_assets(root)
            catalog_path = root / "templates/catalog.json"
            catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
            selected = next(item for item in catalog["templates"] if item["id"] == "line")
            untouched = next(item for item in catalog["templates"] if item["id"] == "bar")
            untouched_digest = untouched["previewSourceSha256"]
            source_path = root / selected["templateFile"]
            source_path.write_bytes(source_path.read_bytes() + b"\n")
            expected_digest = hashlib.sha256(source_path.read_bytes()).hexdigest()

            with mock.patch.object(
                batch_renderer, "render", side_effect=self.fake_render
            ) as mocked_render:
                render_templates(["line"], skill_root=root)

            repaired_catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
            repaired_selected = next(
                item for item in repaired_catalog["templates"] if item["id"] == "line"
            )
            repaired_untouched = next(
                item for item in repaired_catalog["templates"] if item["id"] == "bar"
            )
            strict_errors = validate_catalog(repaired_catalog, root, strict=True)

        mocked_render.assert_called_once()
        self.assertEqual(
            expected_digest,
            repaired_selected["previewSourceSha256"],
        )
        self.assertEqual(untouched_digest, repaired_untouched["previewSourceSha256"])
        self.assertEqual([], strict_errors)


class InvalidSceneTests(unittest.TestCase):
    def load_temporary_scene(self, scene: dict[str, Any]) -> dict[str, Any]:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "invalid.excalidraw"
            path.write_text(json.dumps(scene), encoding="utf-8")
            return json.loads(path.read_text(encoding="utf-8"))

    def assert_has_error(self, errors: list[str], expected: str) -> None:
        self.assertTrue(
            any(expected in error for error in errors),
            f"Expected an error containing {expected!r}, got: {errors}",
        )

    def test_valid_scene_passes_both_validation_layers(self) -> None:
        scene = self.load_temporary_scene(valid_scene())

        self.assertEqual([], validate_excalidraw(scene))
        self.assertEqual([], validate_template(scene, valid_entry()))

    def test_duplicate_ids_are_rejected(self) -> None:
        scene = valid_scene()
        scene["elements"][1]["id"] = "box"

        errors = validate_excalidraw(self.load_temporary_scene(scene))

        self.assert_has_error(errors, "duplicates id 'box'")

    def test_duplicate_indexes_are_rejected(self) -> None:
        scene = valid_scene()
        scene["elements"][1]["index"] = "a0"

        errors = validate_excalidraw(self.load_temporary_scene(scene))

        self.assert_has_error(errors, "duplicates index 'a0'")

    def test_non_boolean_is_deleted_values_are_rejected(self) -> None:
        for value in (1, "true", "false"):
            with self.subTest(value=value):
                scene = valid_scene()
                scene["elements"][0]["isDeleted"] = value

                errors = validate_excalidraw(self.load_temporary_scene(scene))

                self.assert_has_error(errors, "field 'isDeleted' must be a boolean")

    def test_dangling_bindings_are_rejected(self) -> None:
        scenes = []

        arrow_binding = valid_scene()
        arrow_binding["elements"][2]["endBinding"] = {
            "elementId": "missing",
            "focus": 0,
            "gap": 8,
        }
        scenes.append(arrow_binding)

        bound_element = valid_scene()
        bound_element["elements"][0]["boundElements"][0]["id"] = "missing"
        scenes.append(bound_element)

        for scene in scenes:
            with self.subTest(scene=scene):
                errors = validate_excalidraw(self.load_temporary_scene(scene))
                self.assert_has_error(errors, "targets missing element 'missing'")

    def test_embedded_shape_text_is_rejected(self) -> None:
        scene = valid_scene()
        scene["elements"][0]["text"] = "Embedded"

        errors = validate_template(self.load_temporary_scene(scene), valid_entry())

        self.assert_has_error(errors, "must not embed a 'text' field")

    def test_tinted_canvas_background_is_rejected(self) -> None:
        scene = valid_scene()
        scene["appState"]["viewBackgroundColor"] = "#f8f9fb"

        errors = validate_template(self.load_temporary_scene(scene), valid_entry())

        self.assert_has_error(
            errors, "appState.viewBackgroundColor must be '#ffffff'"
        )

    def test_noncanonical_text_fonts_are_rejected(self) -> None:
        cases = (("fontSize", 15, "fontSize"), ("fontFamily", 1, "fontFamily"))
        for field, value, expected in cases:
            with self.subTest(field=field):
                scene = copy.deepcopy(valid_scene())
                scene["elements"][1][field] = value

                errors = validate_template(
                    self.load_temporary_scene(scene), valid_entry()
                )

                self.assert_has_error(errors, expected)


if __name__ == "__main__":
    unittest.main()
