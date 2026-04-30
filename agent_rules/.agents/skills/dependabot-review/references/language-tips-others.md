# Other Ecosystem Tips for Dependabot Review

Minimal reference for non-Go/Java ecosystems. If a project heavily uses one of these, consider creating a dedicated `language-tips-{lang}.md` file.

## Node.js (npm/yarn/pnpm)

- **Dependency files**: `package.json`, `package-lock.json` / `yarn.lock` / `pnpm-lock.yaml`
- **Usage search**: `grep -r "require\|import.*{package}" --include="*.js" --include="*.ts" -l`
- **Version compatibility**: Check `engines.node` in `package.json`
- **Version change classification**: If `engines.node` is bumped → **⛔ Hold** (team-wide Node.js runtime upgrade decision)
- **Verification**: `npm test && npm run build`
- **Group patterns**: `@aws-sdk/*` together, `@types/{pkg}` + `{pkg}` together

## Python (pip/poetry/uv)

- **Dependency files**: `pyproject.toml`, `requirements.txt`, `poetry.lock`, `uv.lock`
- **Usage search**: `grep -r "import {package}\|from {package}" --include="*.py" -l`
- **Version compatibility**: Check `requires-python` in `pyproject.toml`
- **Version change classification**: If `requires-python` is bumped → **⛔ Hold** (team-wide Python runtime upgrade decision)
- **Verification**: `pytest`
- **Group patterns**: `boto3` + `botocore` together (version-locked)

## Rust (cargo)

- **Dependency files**: `Cargo.toml`, `Cargo.lock`
- **Usage search**: `grep -r "use {crate}" --include="*.rs" -l`
- **Version compatibility**: Check `rust-version` in `Cargo.toml` (MSRV)
- **Version change classification**: If `rust-version` (MSRV) is bumped → **⛔ Hold** (team-wide Rust toolchain upgrade decision)
- **Verification**: `cargo build && cargo test`
- **Group patterns**: `tokio` + `tokio-*` together, `aws-sdk-*` + `aws-config` together

## Cross-Ecosystem Rule: Language/Runtime Version Upgrade

Any PR that changes the project's minimum language or runtime version requirement is **always ⛔ Hold**, regardless of CI status. This applies to:
- Go: `go` directive in `go.mod`
- Java: `sourceCompatibility` / `targetCompatibility` / `jvmTarget` in build files
- Node.js: `engines.node` in `package.json`
- Python: `requires-python` in `pyproject.toml`
- Rust: `rust-version` in `Cargo.toml`

CI may pass because CI environments often install the latest runtime automatically, but local development and production environments may not be ready.
