---
name: notion-formatter
description: >
  This skill should be used when the user asks to create or update Notion pages
  using Notion MCP tools with enhanced readability and visual formatting.
  Common requests include "노션 페이지 만들어줘", "노션에 정리해줘",
  "노션에 예쁘게 정리", "노션 문서 작성", "노션 페이지 업데이트",
  "create a Notion page", "write to Notion", "update Notion page",
  "format Notion page nicely".
  It guides AI agents to leverage Notion-native blocks (callouts, toggles,
  columns, colored headings, etc.) for maximum readability instead of
  writing plain markdown.
---

# Notion Formatter Guide

Guide for AI agents to write Notion pages with enhanced readability using Notion-native blocks via MCP tools.

## When to Use

- Creating or updating Notion pages via `notion-create-pages` / `notion-update-page`
- When the user asks for visually well-structured Notion content

## When NOT to Use

- Writing plain Markdown files → use `document-writer` skill instead
- Only reading/searching Notion content (no formatting needed)

## Prerequisite

Before writing content, read the official Notion-flavored Markdown spec:
1. Fetch the MCP resource `notion://docs/enhanced-markdown-spec` from the Notion MCP server
2. Refer to `references/block-syntax-guide.md` in this skill for readability-focused patterns and examples

## Workflow

1. **Understand** — Identify whether this is a new page or an update, the document type, and the target audience
2. **Fetch context** — For updates: `notion-fetch` to read current page content. For database pages: check schema first
3. **Structure** — Design the document skeleton with heading hierarchy and section flow
4. **Format** — Apply Notion-native blocks per the Block Selection Guide below
5. **Execute** — Use `notion-create-pages` or `notion-update-page` to write
6. **Verify** — `notion-fetch` to confirm the result renders as expected

## Block Selection Guide

Choose blocks based on the content situation, not arbitrarily.

| Situation | Use | Avoid |
|---|---|---|
| Major section titles | Colored heading: `# Title {color="blue_bg"}` | Plain headings without color |
| Long content that should be collapsible | Toggle heading: `## Title {toggle="true"}` with indented children | Displaying all content expanded |
| Semantic emphasis (tip, warning, danger) | `<callout>` with appropriate emoji + color | Bold text only |
| Side-by-side comparison | `<columns>` with 2-3 columns | Sequential lists |
| Document navigation (long pages) | `<table_of_contents/>` at the top | Manual link lists |
| Optional/verbose detail | `<callout>` containing `<details>` toggle | Everything at top level |
| Structured data comparison | `<table header-row="true">` | Bullet list sequences |
| Short citation or attribution | `> Quote {color="gray_bg"}` | Overusing callouts for quotes |
| Reusable content across pages | `<synced_block>` | Copy-paste duplication |
| Code examples | ` ```language ` with language specified | Code blocks without language |
| Keyword/status highlighting | `<span color="red">text</span>` | Unstyled inline text |
| Section breaks between H1s | `---` divider | Excessive empty lines |

> See `references/block-syntax-guide.md` for exact syntax and examples of each block.

## Color Convention

Maintain consistent color semantics across the document.

### Callout Colors

| Semantic | Color | Icon |
|---|---|---|
| Info / Tip | `blue_bg` | 💡 |
| Success / Recommendation | `green_bg` | ✅ |
| Warning / Caution | `yellow_bg` | ⚠️ |
| Danger / Error | `red_bg` | 🚨 |
| Note / Reference | `gray_bg` | 📝 |
| Important / Key point | `purple_bg` | 📌 |

### Heading Background Hierarchy

- **H1**: Strong background (e.g., `blue_bg`) — major section dividers
- **H2**: Light background (e.g., `gray_bg`) — sub-section dividers
- **H3**: No background — detail items

### Inline Color Semantics

- Status: `red` = incomplete/danger, `green` = complete/safe, `yellow` = in-progress
- Technical terms: `gray_bg` for inline-code feel
- Limit to **2-3 color rules per document** — excessive colors reduce readability

## Anti-Patterns

Avoid these common mistakes:

| Mistake | Why it breaks | Fix |
|---|---|---|
| Toggle children not indented with tabs | Content renders outside the toggle | Indent all children with tabs |
| Backslash escaping inside code blocks | Code blocks are literal — escapes render as `\` | Write literal content in code blocks |
| Empty blockquote (`>` with no text) | Renders as awkward empty block | Always include text in quotes |
| Using `\n\n` for spacing | Notion strips empty lines automatically | Use `<empty-block/>` if spacing is truly needed |
| HTML tags inside callouts | Notion uses its own Markdown, not HTML | Use `**bold**` not `<strong>` |
| Excessive color usage | Visual noise reduces readability | Stick to 2-3 color rules per document |
| Duplicate title in content | Page title is set via properties | Do not add `# Title` in content body |

## Tool Usage Patterns

### Creating a New Page

- Set the page title via `properties`, not as `# Heading` in content
- Set `icon` (emoji) and `cover` (image URL) for visual completeness
- Structure content starting from H2 or a `<table_of_contents/>`

### Updating an Existing Page

- Always `notion-fetch` first to read current content
- For partial edits: use `update_content` command with precise `old_str` matching
- For full rewrites: use `replace_content` command

### Cautions

- `replace_content` with `preserve_children="false"` can **delete child pages and databases** — use carefully
- Database pages require checking the schema via `notion-fetch` before setting properties
- The `<page>` block tag **moves** existing pages — use `<mention-page>` for inline references instead
