# Block Syntax Guide for Notion-flavored Markdown

This reference covers the Notion-flavored Markdown syntax for blocks that directly improve page readability. Use this alongside the official spec (`notion://docs/enhanced-markdown-spec` MCP resource).

> **Note:** All indentation in Notion-flavored Markdown uses **tabs**, not spaces. This is critical for toggles, callouts, and columns.

---

## 1. Colored Heading

Add `{color="Color"}` to any heading to apply a background color.

**Syntax:**
```
# Section Title {color="blue_bg"}
## Sub Section {color="gray_bg"}
### Detail Item
```

**Heading hierarchy convention:**
- H1: Strong background (e.g., `blue_bg`) — major section dividers
- H2: Light background (e.g., `gray_bg`) — sub-section dividers
- H3: No background — detail items

**Good:**
```
# Architecture Overview {color="blue_bg"}

## Frontend {color="gray_bg"}

### React Components
```

**Bad:**
```
# Architecture Overview {color="blue_bg"}
## Frontend {color="blue_bg"}
### React Components {color="blue_bg"}
```
> Applying the same strong color to all levels defeats the purpose of visual hierarchy.

---

## 2. Toggle Heading

Add `{toggle="true"}` to a heading. Children **must be indented with tabs** to be contained within the toggle.

**Syntax:**
```
## Section Title {toggle="true" color="blue_bg"}
	Content inside the toggle (indented with tab)
	- List items also indented
	More content
```

**Good:**
```
## Background {toggle="true" color="gray_bg"}
	This project was initiated to address compliance requirements.
	The old auth middleware stored session tokens in a non-compliant way.
```

**Bad:**
```
## Background {toggle="true"}
This content is NOT inside the toggle because it's not indented.
```
> Children without tab indentation will render as separate blocks outside the toggle.

---

## 3. Callout

Semantic emphasis box with icon and background color. Supports nested children (lists, code blocks, other callouts).

**Syntax:**
```xml
<callout icon="💡" color="blue_bg">
	Content here (indented with tab)
	- Nested list item
	More content
</callout>
```

**Semantic conventions:**

| Purpose | Icon | Color |
|---|---|---|
| Info / Tip | 💡 | `blue_bg` |
| Success / Recommendation | ✅ | `green_bg` |
| Warning / Caution | ⚠️ | `yellow_bg` |
| Danger / Error | 🚨 | `red_bg` |
| Note / Reference | 📝 | `gray_bg` |
| Important / Key point | 📌 | `purple_bg` |

**Good:**
```xml
<callout icon="⚠️" color="yellow_bg">
	This API is deprecated since v2.0.
	Use `newEndpoint()` instead.
</callout>
```

**Bad:**
```xml
<callout icon="⚠️" color="yellow_bg">
This content is not indented — it will not render correctly inside the callout.
</callout>
```

**Nesting callout + toggle (for "important but long" content):**
```xml
<callout icon="📘" color="blue_bg">
	**Kafka Partition Leader Election** — summary in one line
	<details>
	<summary>Detailed mechanism</summary>
		When a broker fails, the controller selects a new leader...
		```java
		// ISR-based leader election
		selectLeader(partition, isr);
		```
	</details>
</callout>
```

> Use Notion-flavored Markdown inside callouts, NOT HTML tags like `<strong>`. Use `**bold**` instead.

---

## 4. Divider

**Syntax:**
```
---
```

**Usage strategy:**
- Place dividers between major sections (H1 level)
- Use blank lines (not dividers) between sub-sections (H2 level)
- Dividers work inside callouts and columns, auto-adjusting to container width

---

## 5. Columns

Multi-column layout for side-by-side content. Each `<column>` contains indented children.

**Syntax:**
```xml
<columns>
	<column>
		Left content (indented with tab)
	</column>
	<column>
		Right content (indented with tab)
	</column>
</columns>
```

**Common patterns:**

| Pattern | Description |
|---|---|
| Before / After | Compare code or config changes side by side |
| Pros / Cons | Parallel layout for decision documents |
| Code + Explanation | Code block on left, description on right |
| Callout grid | Multiple callouts in columns for dashboard style |

**Good:**
```xml
<columns>
	<column>
		### Before
		```python
		def get_user(id):
		    return db.query(id)
		```
	</column>
	<column>
		### After
		```python
		def get_user(id: int) -> User:
		    return db.query(User, id)
		```
	</column>
</columns>
```

> Columns stack vertically on mobile. Avoid relying on column layout for critical information flow.

---

## 6. Table of Contents

Auto-generated from heading structure. Place at the top of long documents.

**Syntax:**
```xml
<table_of_contents color="gray"/>
```

**Tips:**
- Use a single H1 for the document topic; start actual sections from H2 for cleaner TOC hierarchy
- Headings inside callouts also appear in the TOC
- Color applies to the entire TOC block (e.g., `gray`, `gray_bg`)

---

## 7. Quote

Left-bordered text block for citations or key statements. Different from callout — use for direct quotes, not for tips/warnings.

**Syntax:**
```
> Quote text {color="gray_bg"}
```

**Multi-line quote (use `<br>` for line breaks within a single quote block):**
```
> First line<br>Second line<br>Third line {color="gray_bg"}
```

**Bad:**
```
> Line 1
> Line 2
```
> Multiple `>` lines create multiple separate quote blocks, not a single multi-line quote.

**Bad:**
```
>
```
> Empty blockquote — renders as an awkward empty block. Always include text.

---

## 8. Toggle (Non-heading)

Collapsible section without heading semantics. Good for FAQ, optional details, or verbose content.

**Syntax:**
```xml
<details color="blue_bg">
<summary>Click to expand</summary>
	Hidden content (indented with tab)
	- List items
	```code blocks```
</details>
```

**Good:**
```xml
<details>
<summary>Full error log</summary>
	```
	Error: Connection refused at 10.0.0.1:5432
	Caused by: timeout after 30s
	```
</details>
```

> Children must be indented with tabs. Without indentation, content appears outside the toggle.

---

## 9. Table

Structured data with optional header row/column and cell-level color.

**Syntax:**
```xml
<table header-row="true" fit-page-width="true">
	<tr>
		<td>Header 1</td>
		<td>Header 2</td>
		<td>Header 3</td>
	</tr>
	<tr>
		<td>Data</td>
		<td>Data</td>
		<td color="green_bg">Highlighted</td>
	</tr>
</table>
```

**Attributes:**
- `header-row="true"` — first row as header (bold, distinct style)
- `header-column="true"` — first column as header
- `fit-page-width="true"` — stretch table to full page width

**Color precedence:** Cell > Row > Column

**Rules:**
- Table cells can only contain rich text (no headings, lists, images inside cells)
- Use Notion-flavored Markdown for formatting inside cells (`**bold**`, `` `code` ``, etc.)

---

## 10. Code Block

Fenced code with language specification for syntax highlighting.

**Syntax:**
````
```python
def hello():
    print("Hello, World!")
```
````

**Rules:**
- Always specify the language when known (e.g., `python`, `javascript`, `sql`, `mermaid`)
- Do NOT escape special characters inside code blocks — content is literal
- Mermaid diagrams: use `mermaid` as language, wrap node text with special characters in double quotes

**Good:**
````
```javascript
const arr = [1, 2, 3];
```
````

**Bad:**
````
```javascript
const arr = \[1, 2, 3\];
```
````
> Backslash escaping rules only apply outside code blocks. Inside code blocks, write literal content.

---

## 11. Inline Color

Apply color to specific text within a block for emphasis.

**Syntax:**
```
<span color="red">Important text</span>
```

**Available colors:**
- Text colors: `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`
- Background colors: `gray_bg`, `brown_bg`, `orange_bg`, `yellow_bg`, `green_bg`, `blue_bg`, `purple_bg`, `pink_bg`, `red_bg`

**Strategic usage:**
- Status: `red` = incomplete/danger, `green` = complete/safe, `yellow` = in-progress
- Inline code feel: `gray_bg` on technical terms
- Role/team distinction: assign a unique color per team

> Limit to 2-3 color rules per document. Excessive colors reduce readability.

---

## 12. Synced Block

Content that stays synchronized across multiple pages. Edit once, update everywhere.

**Syntax (create new):**
```xml
<synced_block>
	Shared content here
	- Common guidelines
	- Team conventions
</synced_block>
```

**Syntax (reference existing):**
```xml
<synced_block_reference url="{{URL}}">
	Content (auto-synced)
</synced_block_reference>
```

**Use cases:**
- Shared glossary / terminology definitions
- Common disclaimers or warnings
- Team conventions referenced across multiple docs

**Rules:**
- When creating new synced blocks, omit the `url` — it is auto-generated
- When referencing, `url` must point to an existing synced block
- Editing a reference updates the original and all other references
- To detach a specific instance, the user must manually "Unsync" in Notion UI
