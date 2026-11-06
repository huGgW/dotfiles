"""Focused regression for transparent SVG screenshots."""

import importlib.util
import unittest
from pathlib import Path
from unittest import mock


SKILL_ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "transparency_renderer", SKILL_ROOT / "references/render_excalidraw.py"
)
renderer = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(renderer)


class RenderTransparencyTests(unittest.TestCase):
    def test_screenshot_preserves_scene_transparency(self):
        output = Path("transparent.png")

        with mock.patch("playwright.sync_api.sync_playwright") as playwright:
            browser = playwright.return_value.__enter__.return_value.chromium.launch.return_value
            page = browser.new_page.return_value
            page.evaluate.side_effect = [None, {"success": True}]

            result = renderer.render(
                SKILL_ROOT / "templates/architecture-template.excalidraw", output
            )

        self.assertEqual(result, output)
        page.query_selector.return_value.screenshot.assert_called_once_with(
            path=str(output), omit_background=True
        )


if __name__ == "__main__":
    unittest.main()
