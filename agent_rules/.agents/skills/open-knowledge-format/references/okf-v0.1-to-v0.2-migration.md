# OKF v0.1 To v0.2 Migration

Use this reference to read legacy concepts, plan a migration, or migrate a
touched concept without losing metadata or source coverage.

## Compatibility Contract

- v0.1 is valid legacy input, not malformed OKF.
- New concepts use v0.2.
- Read-only tasks do not modify or require migration of a valid v0.1 bundle.
- Small edits do not force unrelated concepts or fields to migrate.
- Explicit conversion tasks produce v0.2 unless the user requests another
  target.
- A missing root version declaration does not identify the version. Detect
  supported features per concept.

## Feature Detection And Precedence

Use field presence instead of guessing one version for an entire bundle.

| Information | Preferred form | Legacy fallback |
| --- | --- | --- |
| Last meaningful content change | `generated.at` | `timestamp` when `generated` is absent |
| Producer identity | `generated.by` | Not represented by v0.1 |
| Provenance | `sources` | `# Citations` when `sources` is absent |
| Claim attribution | Footnotes keyed to `sources[].id` | Unstructured citation list or inline link |
| Trust | `verified` and derived tier | Not represented by v0.1 |
| Lifecycle | `status`, `stale_after` | Not represented by v0.1 |

When both forms exist, consume the v0.2 form first. Do not delete the legacy
form merely because it is lower precedence.

## Migration Modes

### Read Or Review

- Parse `timestamp` and `# Citations` as compatibility data.
- Do not report them as baseline conformance failures.
- Mention migration only when it matters to the user's requested outcome.
- Do not synthesize missing trust, lifecycle, or actor data.

### Focused Edit Or Enrichment

- Preserve the concept's current version unless migration is requested or the
  requested edit directly targets a legacy field.
- Prefer a complete per-concept migration over a half-rewritten source model.
- Treat complete, safe conversion as a requirement after migration is in scope,
  not as permission to expand an unrelated edit.
- If provenance mapping is uncertain, preserve legacy citations and report the
  unresolved mapping.
- Never broaden a one-concept edit into a bundle-wide migration.

### Explicit Migration

- Inventory every legacy and hybrid concept first.
- Convert one concept at a time while preserving unknown metadata and body
  structure.
- Record unresolved producer identity and claim attribution instead of
  inventing them.
- Validate both v0.2 contracts and preservation after conversion.

## Migrating `timestamp`

v0.2 supersedes `timestamp` with `generated.at`, but `generated` also requires
a producer identity. A timestamp alone is not enough to reconstruct that
identity.

Use this decision order:

1. If the original producer and meaningful-change time are known, write both
   as `generated.by` and `generated.at`.
2. If the migration process intentionally becomes the producer of the current
   representation, use its real actor and current migration time. Report that
   this records migration production, not the original authorship event.
3. If the producer is unknown, do not invent one. Preserve the legacy
   `timestamp` as fallback or omit `generated`; the concept remains conformant
   because the family is optional.

Do not pair a newly invented actor with an old timestamp. That would assert a
production event that never happened.

When a trusted mapping is available:

```yaml
# v0.1
timestamp: 2026-06-01T09:30:00Z
```

```yaml
# v0.2
generated:
  by: process:catalog-export
  at: 2026-06-01T09:30:00Z
```

Every migrated datetime must include an explicit UTC offset.

## Migrating `# Citations`

The v0.1 list is unstructured provenance. v0.2 records sources in frontmatter
and joins individual claims to them through stable IDs.

### Safe Mechanical Extraction

- Convert a concrete URL or bundle path into `sources[].resource`.
- Derive a concise stable ID from a known source identity, not list position.
- Preserve an existing citation label as `title` when useful.
- Deduplicate identical resources without dropping distinct source metadata.
- Keep source order stable when it carries useful human context.

Example:

```markdown
# Citations

- [Revenue policy](https://example.com/revenue-policy)
```

```yaml
sources:
  - id: revenue-policy
    resource: https://example.com/revenue-policy
    title: Revenue Policy
```

### Claim Mapping

- Add `[^source-id]` only when the cited source actually supports that claim.
- Never assign footnotes by citation-list position.
- Do not assume every source supports every body paragraph.
- When the flat list proves that sources informed the concept but not which
  claims they support, populate `sources` only if that derivation is still
  reliable and leave claim attribution unresolved.
- Preserve the legacy section until its source coverage is represented safely.

## Hybrid Concepts

A concept may legitimately contain both generations during gradual migration.

- Prefer `generated.at` over `timestamp` for current-change decisions.
- Prefer `sources` over `# Citations` for structured provenance.
- Compare rather than silently merge conflicting values.
- Report contradictions, missing legacy coverage, duplicate resources, and
  source IDs with no matching footnotes.
- Do not call the concept invalid solely because both generations appear.

## Optional v0.2 Families

Migration does not require filling every new field.

- Add `verified` only from real verification evidence.
- Add `status` when lifecycle state is known; omission means stable.
- For migrated agent-generated content awaiting review, use `draft` only when
  that state accurately reflects the owner's policy.
- Add `stale_after` only from a known freshness policy.
- Add source credibility signals only from objective evidence.
- Never manufacture data to make a migration look complete.

## Root Version Declaration

After a complete bundle migration, the root `index.md` may declare:

```yaml
---
okf_version: "0.2"
---
```

Do not add this declaration when the bundle still intentionally targets v0.1
or when the user requested only a focused concept edit. A hybrid bundle may
omit the declaration and rely on feature detection.

## Preservation Checklist

- Unknown frontmatter keys remain unchanged.
- Canonical `resource`, title, description, and tags remain unless a source
  proves a correction.
- Existing headings, schema fields, examples, links, and source coverage do not
  shrink.
- Legacy timestamps or citations are removed only after their information is
  represented safely.
- No actor, verification, credibility, lifecycle, or freshness value was
  invented.
- The migrated concept passes baseline and conditional v0.2 checks.

## Migration Report

Report:

- Concepts fully migrated.
- Concepts left in v0.1 form and why.
- Hybrid concepts and precedence decisions.
- Citations without reliable claim mapping.
- Unknown producer identities.
- Trust or lifecycle fields intentionally omitted.
- Any legacy content retained to prevent information loss.
