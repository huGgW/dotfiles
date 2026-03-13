# Java/Gradle Project Tips for Dependabot Review

## Core Dependency Examples

- Web framework: Dropwizard, Spring Boot
- DI: Guice, Guicey, Spring
- AWS: `software.amazon.awssdk:*` (BOM managed)
- DB: PostgreSQL JDBC, JooQ, Flyway
- Messaging: Kafka, gRPC
- Monitoring: Sentry, DataDog, Micrometer

## Dependency Files

- `build.gradle` or `build.gradle.kts`
- Version management: `gradle.properties`, `buildSrc/`, `gradle/libs.versions.toml`, or separate `dependencies.gradle`
- BOM usage: `platform()` or `enforcedPlatform()` for unified version management

## Usage Search

```bash
# import search
grep -r "import.*{package}" --include="*.java" -l

# structural search (ast-grep)
# Use ast-grep MCP for syntax-aware search when available
```

## Java Version Compatibility

- Check `sourceCompatibility` / `targetCompatibility` in `build.gradle`
- Compare with the minimum Java version required by the library

### PR Diff Inspection (Mandatory for Every PR)

Always check the PR diff for build file changes:
```bash
gh pr diff {N} | grep -A2 "sourceCompatibility\|targetCompatibility\|JavaVersion\|jvmTarget"
```

Look for:
1. **Java version directive change** (e.g., `JavaVersion.VERSION_17` → `JavaVersion.VERSION_21`) — highest impact signal
2. **New transitive dependencies added** — may indicate large dependency tree changes
3. **Gradle plugin version changes** — may require newer Gradle or Java version

### Classification Rules for Java Version Changes

If a PR changes `sourceCompatibility`, `targetCompatibility`, `jvmTarget`, or requires a newer Java version:
- **⛔ Hold** (always): A Java version change upgrades the project's minimum JDK requirement,
  affecting all developers, CI/CD pipelines, and production runtime environments. This is a
  team-wide infrastructure decision. Classify as ⛔ Hold regardless of whether CI passes.

## Changelog Access

- GitHub releases page
- Maven Central release notes
- Project-specific CHANGELOG.md

## Verification Commands

```bash
./gradlew clean build
./gradlew test
```

## Notable Considerations

- BOM-based dependencies (e.g., AWS SDK BOM): only upgrade the BOM version and sub-modules follow
- Gradle version catalogs: check `libs.versions.toml`
- Multi-module projects: verify impact per sub-module

## Dependency Group Patterns

- AWS SDK BOM + individual service modules → merge BOM first
- Dropwizard core + sub-modules → merge together
- Jackson core + Jackson modules → merge together
