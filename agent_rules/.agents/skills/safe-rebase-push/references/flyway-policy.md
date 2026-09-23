# Flyway Migration Policy

Apply this policy whenever a rebase touches Flyway migration files or their
configuration, even when Git reports no textual conflict.

## Detect Semantic Collisions

Inspect configured migration locations and naming rules rather than assuming a
default path or filename format. Detect duplicate versioned migration versions across
the configured locations after the rebase. A duplicate version is a semantic
collision even if the files merge cleanly. Stop and ask; do not rename or renumber a
migration automatically.

Inspect repeatable migrations as well. Their descriptions and file names identify
the migration while their content can change checksum behavior. Treat duplicate,
ambiguous, reordered, or behaviorally overlapping repeatables as a decision point,
not a text-merging exercise.

## Preserve History and Ordering

Versioned migrations are ordered by version. Determine whether each affected
migration may already be applied in any relevant environment before proposing a
resolution. Applied migration files are immutable because Flyway validates their
checksums against schema history. Do not edit, rename, renumber, delete, or reorder
an applied migration to make a rebase easier.

If history or environment status is uncertain, stop and ask for the relevant
environment facts. Do not assume development-only status from a branch name or a
clean local database. Never automatically run repair or edit schema-history data.

When a new migration must be renamed or renumbered, require an explicit decision
that identifies which migration is unpublished and why the new ordering is correct.
Preserve the intended dependency order; numeric uniqueness alone is insufficient.

## Validation

When practical and authorized, validate both:

1. a fresh database migration from an empty schema; and
2. an upgrade path from a representative existing schema/history.

Use the repository's configured Flyway command, locations, placeholders, and
environment setup. If either validation cannot run, report the missing evidence and
do not claim migration safety. A clean Git rebase or a successful compilation is not
enough evidence for migration ordering or history compatibility.
