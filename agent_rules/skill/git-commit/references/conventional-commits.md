# Conventional Commits v1.0.0 Reference

Full specification for commit message formatting. Read this when you need detailed rules
beyond the quick reference in SKILL.md.

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Type Definitions

| Type | Description | SemVer | Example |
|------|-------------|--------|---------|
| feat | New feature or capability | MINOR | `feat: add dark mode toggle` |
| fix | Bug fix | PATCH | `fix: resolve null pointer on login` |
| docs | Documentation only changes | - | `docs: update API usage examples` |
| style | Formatting, whitespace, semicolons (no logic change) | - | `style: fix indentation in config` |
| refactor | Code restructuring without behavior change | - | `refactor: extract validation into helper` |
| perf | Performance improvement | - | `perf: cache database query results` |
| test | Adding or correcting tests | - | `test: add unit tests for auth module` |
| build | Build system or external dependency changes | - | `build: upgrade webpack to v5` |
| ci | CI/CD configuration changes | - | `ci: add GitHub Actions workflow` |
| chore | Maintenance tasks (no src/test change) | - | `chore: update .gitignore` |

## Type Selection Decision Tree

Use this when the boundary between types is unclear:

1. **Did behavior change from the user's perspective?**
   - Yes, it's a new capability → `feat`
   - Yes, it fixes broken behavior → `fix`
   - No → continue below

2. **Is the change only about code structure/readability?**
   - Yes → `refactor`

3. **Is the change only formatting (whitespace, semicolons, quotes)?**
   - Yes → `style`

4. **Does it make something faster without changing behavior?**
   - Yes → `perf`

5. **Is it only tests?**
   - Yes → `test`

6. **Is it only documentation?**
   - Yes → `docs`

7. **Is it build config or dependencies?**
   - Yes → `build`

8. **Is it CI/CD pipeline config?**
   - Yes → `ci`

9. **None of the above?**
   - → `chore`

### Common Ambiguous Cases

- **fix vs refactor**: Did the old code produce wrong results? → `fix`. Did it work correctly but was hard to maintain? → `refactor`.
- **feat vs refactor**: Does the user gain a new capability or option? → `feat`. Is it invisible restructuring? → `refactor`.
- **style vs refactor**: Did you only change formatting? → `style`. Did you rename variables or reorganize code? → `refactor`.
- **build vs ci**: Does it affect how code compiles/bundles locally? → `build`. Does it affect the CI/CD pipeline? → `ci`.

## Scope Guidelines

- Use a lowercase noun describing the affected module or component
- Use hyphens for multi-word scopes: `feat(user-api): ...`
- Omit scope when the change is cross-cutting or the project has no clear modules
- Common scopes: component names, module names, layer names (api, db, ui)

Examples:
```
fix(parser): handle escaped quotes in strings
feat(auth): add OAuth2 provider support
refactor(db): simplify connection pooling logic
```

## Description Rules

- Start with lowercase letter (not capitalized)
- Use imperative mood: "add" not "added" or "adds"
- No period at end
- Keep concise — ideally under 50 characters, hard limit at 72

## Body Rules

- Separate from description by one blank line
- Free-form text, can be multiple paragraphs separated by blank lines
- Explain **what** changed and **why**, not how (the code shows how)
- Wrap lines at 72 characters

Example:
```
fix(auth): prevent session fixation on login

Regenerate session ID after successful authentication to prevent
session fixation attacks. The previous implementation reused the
pre-authentication session ID, which could be exploited by an
attacker who sets a known session ID before the victim logs in.

Closes #1234
```

## Footer Rules

- Separate from body by one blank line
- Format: `token: value` or `token #value`
- Tokens use `-` instead of spaces (e.g., `Acked-by`, `Reviewed-by`)
- Exception: `BREAKING CHANGE` uses a space (not `BREAKING-CHANGE`), though both are valid
- Footer values may contain spaces and newlines
- Parsing of a footer value terminates when the next valid footer token/separator pair is observed

Common footers:
```
Closes #123
Refs #456, #789
Reviewed-by: Name <email>
Co-authored-by: Name <email>
BREAKING CHANGE: description of what broke
```

## Breaking Changes

Breaking changes indicate incompatible API changes and correlate with MAJOR in SemVer.

Two ways to indicate:

### 1. `!` before the colon
```
feat!: remove deprecated /users endpoint
feat(api)!: redesign authentication flow
```

### 2. `BREAKING CHANGE` footer
```
feat: redesign configuration format

BREAKING CHANGE: environment variables now take precedence over
config file values. Previously, config file values had higher
priority. Update your deployment scripts if you rely on config
file overrides.
```

### 3. Both combined (most explicit)
```
feat(config)!: switch to YAML configuration format

Migrate from JSON to YAML for all configuration files.
JSON configs are no longer supported.

BREAKING CHANGE: all .json config files must be converted to .yaml
format. Run `npx migrate-config` to convert automatically.
```

When `!` is used, the `BREAKING CHANGE:` footer may be omitted — but including both
provides maximum clarity for automated tooling and human readers.
