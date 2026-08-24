# OKF v0.2 Review And Validation

Use this reference when reviewing an existing bundle, checking generated
output, or producing a remediation plan. The review must accept valid v0.1
input while applying v0.2 contracts to fields that are present.

## Contents

- Review Procedure and Finding Categories
- v0.1 Compatibility
- Reserved Files and Baseline Concepts
- Provenance, Trust, Time, and Lifecycle
- Attested Computation
- Links, Grounding, and Rewrite Risks
- Severity and Review Output

## Review Procedure

1. Identify the bundle root and any declared `okf_version`.
2. List Markdown concept documents, reserved files, and referenced artifacts.
3. Parse frontmatter in every non-reserved concept document.
4. Check baseline conformance independently of version-specific metadata.
5. Detect v0.1, v0.2, and hybrid features per concept.
6. Validate each v0.2 family that is present.
7. Resolve internal Markdown links and path-valued fields where applicable.
8. Review sources, claim attribution, trust, lifecycle, and freshness.
9. Check Attested Computation contracts when present.
10. Report findings by category, severity, file, evidence, and concrete fix.

## Finding Categories

| Category | Meaning | Examples |
| --- | --- | --- |
| Baseline conformance failure | Violates the minimum bundle or reserved-file structure. | Missing concept frontmatter, empty `type`, frontmatter on a non-root index. |
| v0.2 contract violation | A present v0.2 family or specialized type has an invalid shape. | Source without `resource`, invalid actor, Attested Computation without `runtime`. |
| Migration issue | Valid legacy input that should not be emitted as new v0.2 content. | `timestamp`, body-only `# Citations`, incomplete hybrid migration. |
| Quality or trust issue | Consumable content that weakens retrieval, grounding, or trust decisions. | Unsupported claim, stale concept, verification older than generation. |

Do not turn migration opportunities or optional metadata gaps into baseline
conformance failures.

## v0.1 Compatibility

- Accept a parseable concept with non-empty `type`, legacy `timestamp`, and a
  body `# Citations` section.
- Use `generated.at` instead of `timestamp` when both exist.
- Use `sources` instead of `# Citations` as structured provenance when both
  exist.
- Do not infer the version solely from an absent root declaration.
- Report legacy forms as migration information only when migration is relevant
  to the user's task.
- A read-only review must not rewrite or require migration of an otherwise
  valid v0.1 bundle.

## Reserved File Checks

Baseline failures:

- An `index.md` is treated as a concept document.
- A non-root `index.md` has frontmatter.
- A root `index.md` frontmatter block contains concept metadata instead of the
  optional `okf_version` declaration.
- A `log.md` is treated as a concept document or has concept frontmatter.
- A `log.md` date heading is not ISO `YYYY-MM-DD`.
- `log.md` date groups are not newest first.

Quality checks:

- An index omits important immediate child concepts or subdirectories.
- Index entries omit available concept descriptions.
- An index duplicates full concept content instead of enabling progressive
  disclosure.

## Baseline Concept Checks

Baseline failures:

- Missing, unterminated, or unparseable frontmatter.
- Frontmatter that parses to a list or scalar rather than a mapping.
- Missing, empty, or non-string `type`.

Quality checks:

- Missing or weak `title` or `description`.
- `tags` is not a list of short strings.
- A resource-backed concept lacks a canonical `resource`.
- The body lacks enough context to explain the concept's scope or grain.
- An edit would drop unknown producer-defined keys.

Unknown types and unknown additional fields are valid and must not cause
rejection.

## Provenance Contract Checks

When `sources` is present:

- It is a list of source mappings.
- Every entry has a non-empty `resource`.
- Footnotes used for source attribution have labels that resolve
  unambiguously to source IDs. Ordinary explanatory Markdown footnotes do not
  need matching `sources` entries.
- Duplicate source IDs are reported because claim attribution becomes
  ambiguous.
- `author`, `usage_count`, `last_modified`, and `usage_window` are not treated
  as required.
- Every `usage_count` has a shared `usage_window` or a source-specific override.
- A scope descriptor is not incorrectly validated as a filesystem path.
- Source signals are objective facts, not a producer-authored credibility
  score.

When only `# Citations` exists, treat it as valid v0.1 provenance and report
weak claim mapping as a compatibility limitation rather than a malformed
bundle.

## Actor, Trust, And Time Checks

- `generated` is a mapping and has a non-empty required `by` when present.
- `verified` is either one `{ by, at }` mapping or a list of such events.
- Normalize a bare `verified` mapping to a one-element list for analysis.
- Agent and tool actors use `<producer>/<version>`; people use `human:<id>`;
  automated processes use `process:<id>`.
- Treat `sources[].author` as an authority signal. Accept the actor convention
  and producer-defined authority identifiers such as `team:<id>`; do not use
  source authors to derive the concept's verification trust tier.
- Every timestamp-valued field is an ISO 8601 datetime with an explicit UTC
  offset. A date-only frontmatter timestamp is a v0.2 contract violation.
- Derive trust as unverified, machine-confirmed, or human-reviewed from
  `verified`; do not store or infer access control from the tier.
- Report when `generated.at` is later than every `verified.at`, because current
  content has no later confirmation.

## Lifecycle Checks

- `status` is one of `draft`, `stable`, or `deprecated`; absence means stable.
- `stale_after` is an absolute explicit-offset datetime.
- A concept is stale when `now >= stale_after`.
- Missing lifecycle metadata is not a conformance failure.
- Flag active links to deprecated concepts and stale concepts when they may
  affect the requested use case.

## Attested Computation Checks

For `type: Attested Computation`:

- `runtime` is present and non-empty.
- Every parameter has `name`, `type`, and `required`.
- The computation is supplied either by one fenced block under
  `# Computation` or by the `computation` path, not both.
- `executor.resource` identifies run instructions or code and
  `executor.receipt` declares evidence fields.
- `attester.resource` identifies deterministic, no-LLM checking code.
- Referenced files exist when the bundle claims to include them; missing paths
  remain tolerable links but are reported.
- Runtime receipts and verdicts are not stored as bundle trust metadata.
- `verified` is not presented as proof that a specific execution attested.

Read `okf-attested-computation.md` for the complete semantic contract.

## Link And Path Checks

- Resolve file-relative links from the source file's directory.
- Resolve absolute bundle-relative links from the bundle root.
- Apply the same path forms to `resource`, `sources[].resource`, `computation`,
  `executor.resource`, and `attester.resource` when their values are paths.
- Ignore external URLs and source scope descriptors for internal broken-link
  checks.
- Report broken internal targets with source file, link text or field, and
  target.
- Do not classify broken links as baseline conformance failures.
- Flag self-links and links in headings, code blocks, or schema field-name
  listings when they reduce readability.
- Treat absolute versus relative style as a consumer compatibility decision,
  not a conformance verdict.

## Grounding Checks

- Verify that source-backed claims have a corresponding source entry and keyed
  footnote where per-claim attribution matters.
- Flag source entries that do not support any derived content.
- Flag factual claims imported from a source but absent from structured
  provenance.
- Flag generic homepage sources when a precise primary source is available.
- Check that metric formulas, enum mappings, join conditions, and sanctioned
  computations have authoritative provenance.
- Never claim a source is accessible or correct unless it was actually read.

## Destructive Rewrite Risks

Flag a proposed edit when it would:

- Drop unknown frontmatter keys or prior verification events.
- Replace tags or sources instead of merging them.
- Remove legacy citations before their coverage is mapped.
- Rename or reorder existing top-level headings without a clear reason.
- Reduce schema fields, examples, computation contract details, or source
  coverage.
- Replace a focused concept with a generic source-page summary.
- Convert `index.md` or `log.md` into a normal concept document.
- Force an unrelated v0.1 migration.

## Severity

Use severity independently of finding category.

| Severity | Meaning |
| --- | --- |
| Critical | Blocks baseline consumption, creates materially misleading trust, or risks data loss. |
| Warning | Violates a present v0.2 contract or materially weakens grounding, lifecycle, or compatibility. |
| Suggestion | Optional improvement with lower operational impact. |

## Review Output

```markdown
# OKF Review

## Summary

- Bundle root: `path/to/bundle`
- Declared version: `0.2`, `0.1`, or not declared
- Concept docs checked: N
- Reserved files checked: N
- Baseline failures: N
- v0.2 contract violations: N
- Migration issues: N
- Quality or trust issues: N

## Findings

1. [Severity] [Category] `path/file.md` - Finding title
   Evidence: Exact field, section, or relationship.
   Impact: Why it matters.
   Fix: Smallest safe remediation.

## Compatibility

- v0.1 fallback behavior observed.
- Hybrid precedence decisions.
- Consumer-specific link considerations.

## Trust And Freshness

- Trust tiers and stale concepts relevant to the task.
- Content changed after its latest verification.

## Unverified Areas

- Sources, paths, actors, or runtime contracts that could not be confirmed.
```
