# OKF Review And Validation

Use this reference when reviewing an existing OKF bundle, checking a generated bundle, or writing a remediation plan.

## Review Procedure

1. Identify the bundle root.
2. List Markdown files and separate concept docs from reserved files.
3. Parse frontmatter in every non-reserved concept doc.
4. Check hard conformance requirements.
5. Check practical compatibility and authoring quality.
6. Extract internal Markdown links and identify broken targets.
7. Review citations for source grounding.
8. Check enrichment safety risks if edits are planned.
9. Report findings by severity with file paths and concrete fixes.

## Reserved Filename Checks

- `index.md` should provide navigation, not a normal concept document.
- `log.md` should provide chronological updates, not a normal concept document.
- If `index.md` has frontmatter, verify whether it is intentional bundle-root metadata. Otherwise flag it as confusing.
- Date headings in `log.md` should use `YYYY-MM-DD` when present.
- Directory-level `index.md` should link to immediate child concepts or subdirectories rather than becoming a full duplicate of the bundle.

## Frontmatter Checks

Hard failures:

- Missing frontmatter on a non-reserved concept doc.
- Unterminated frontmatter.
- YAML that does not parse to a mapping.
- Missing or empty `type`.

Practical issues:

- Missing `title`.
- Missing `description`.
- Missing or non-ISO `timestamp`.
- `tags` is not a list.
- `resource` is missing for a concept that clearly represents an external asset.
- Description is too vague to help search or navigation.
- Type is too generic for the concept's role.

## Link Checks

- Resolve relative links from the source file's directory.
- Resolve absolute bundle-relative links from the bundle root.
- Ignore external URLs for broken-internal-link checks.
- Report broken internal links with source file, link text, and target.
- Broken links are not necessarily invalid OKF, but they should be visible to the user.
- Flag links in headings, code blocks, and schema field-name lists when they reduce readability.
- Flag self-links.

## Citation Checks

- Verify that cited sources are actually used by claims in the body.
- Flag source-backed claims with no citation.
- Flag generic homepage citations when a precise source is available.
- Flag citations that point to inaccessible, invented, or unrelated sources.
- Check that metric formulas, enum mappings, and join conditions have citations.

## Destructive Rewrite Risk Checks

Flag a proposed edit as risky when it would:

- Drop unknown frontmatter keys.
- Replace tags instead of merging them.
- Rename or reorder existing top-level headings without a clear reason.
- Reduce schema field coverage.
- Remove examples that explain usage.
- Remove or reduce citations.
- Replace a focused concept with generic source-page summary.
- Convert `index.md` or `log.md` into normal concept docs.

## Severity Model

Use these categories in review output.

| Severity | Meaning | Examples |
| --- | --- | --- |
| Critical | Breaks basic OKF consumption or risks data loss during edits. | Missing `type`, invalid YAML, destructive rewrite. |
| Warning | Works but weakens agent retrieval or trust. | Missing citations, broken links, missing titles, weak indexes. |
| Suggestion | Quality improvement with lower urgency. | Better tags, clearer descriptions, improved directory grouping. |

## Review Output Template

```markdown
# OKF Review

## Summary

- Bundle root: `path/to/bundle`
- Concept docs checked: N
- Reserved files checked: N
- Critical: N
- Warning: N
- Suggestion: N

## Findings

### Critical

1. `path/file.md` - Finding title
   Impact: Why this blocks or risks OKF consumption.
   Fix: Concrete remediation.

### Warning

1. `path/file.md` - Finding title
   Impact: Why this weakens the bundle.
   Fix: Concrete remediation.

### Suggestion

1. `path/file.md` - Finding title
   Fix: Optional improvement.

## Remediation Order

1. Fix hard conformance failures.
2. Fix destructive rewrite risks before enrichment.
3. Fix missing citations for metrics, joins, and definitions.
4. Improve navigation and descriptions.

## Notes

- Broken links may be intentional placeholders; confirm with the bundle owner.
- Optional fields are practical compatibility recommendations, not strict OKF spec requirements.
```
