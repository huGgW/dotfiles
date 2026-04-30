# Go Project Tips for Dependabot Review

## Core Dependency Examples

- Web framework: `gin-gonic/gin`
- DI: `go.uber.org/fx`
- AWS: `aws/aws-sdk-go-v2/*`
- DB driver: `lib/pq`, `jackc/pgx`
- ORM: `volatiletech/sqlboiler`, `go-gorm/gorm`
- Redis: `go-redis/redis`, `redis/go-redis`

## Dependency File

`go.mod` (version), `go.sum` (checksum)

## Usage Search

```bash
# import search
grep -r "github.com/{package}" --include="*.go" -l

# structural search (ast-grep)
# Use ast-grep MCP for syntax-aware search when available
```

## Go Version Compatibility

- Check `go` directive in `go.mod`
- Compare with the minimum Go version required by the library

## Go Toolchain & Transitive Dependency Behavior (CRITICAL)

When Dependabot runs `go get`, the `go` directive in `go.mod` can be **automatically bumped**
if any transitive dependency requires a higher Go version. This happens even when the direct
dependency itself requires a lower version.

**Example**: A library states minimum Go 1.24, but its transitive dependency (e.g., `quic-go`)
requires Go 1.25 → `go get` bumps the project's `go.mod` from `go 1.24.0` to `go 1.25.0`.

### PR Diff Inspection (Mandatory for Every PR)

Always check the PR diff for `go.mod` changes:
```bash
gh pr diff {N} | grep -A1 "^-go 1\."
```

Look for:
1. **go directive change** (e.g., `go 1.24.0` → `go 1.25.0`) — highest impact signal
2. **New indirect dependencies added** — may indicate large transitive dependency tree changes
3. **Large version jumps in indirect deps** (e.g., `quic-go` 0.54→0.59) — risk indicator

### Classification Rules for go Directive Changes

If a PR changes the `go` directive in `go.mod`:
- **⛔ Hold** (always): A go directive change upgrades the project's minimum Go version requirement,
  affecting all developers, CI/CD pipelines, and production build environments. This is a
  team-wide infrastructure decision, not a library-level concern. Classify as ⛔ Hold regardless
  of whether CI passes (CI may use a newer Go via setup-go action while local/production
  environments still run the older version).

### Output Field

When reporting, always include:
```
| go directive change | No change / go 1.24.0 → go 1.25.0 |
```

### Agent Prompt Variable

Use `{pr_diff_inspection_instructions}` in the agent prompt template:
```
Check if the `go` directive in go.mod changed (e.g., `go 1.24.0` → `go 1.25.0`).
Run: `gh pr diff {N} | grep -A1 "^-go 1\."`.
This is critical — `go get` can auto-bump the go directive when transitive dependencies
require a higher Go version, even if the direct library does not.
Also note any new indirect dependencies or large version jumps in transitive deps.
If the go directive changed, classify as ⛔ Hold — this is a project-wide runtime version
upgrade that requires team decision, regardless of CI pass status.
```

## Changelog Access

- General: GitHub releases page or `CHANGELOG.md`
- AWS SDK: `curl "https://raw.githubusercontent.com/aws/aws-sdk-go-v2/refs/heads/main/{library_path}/CHANGELOG.md"`

## Verification Commands

```bash
go build ./...
go test ./...
go vet ./...
```

If Makefile exists:
```bash
make build
make test
```

## Dependency Group Patterns

- `aws-sdk-go-v2` + `aws-sdk-go-v2/config` + `aws-sdk-go-v2/service/*` → merge together
- `sentry-go` + `sentry-go/{integration}` → merge together
- `grpc` + `protobuf` → check compatibility, merge together
