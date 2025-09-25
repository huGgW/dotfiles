# MCP tool usage guideline

## context7
- Context7 MCP pulls up-to-date, version-specific documentation and code examples straight from the source — and places them directly into your prompt.
- **Use it if you need library / framework information**

---
## grep
- Grep MCP server provides an endpoint that searches public GitHub repositories. Through the Grep MCP server, AI agents can issue search queries and retrieve code snippets that match specific patterns or regular expressions, filtered by language, repository, and file path.
- **Use it ONLY when you need to find specific code implementation patterns or snippets from real open-source projects**
- **For general information search or documentation lookup, prefer using WebSearch tool instead**

### When to use grep MCP:
- Finding real-world usage examples of specific APIs or libraries
- Looking for code patterns or implementations in open-source projects
- Searching for specific code syntax or patterns across GitHub repositories

### When NOT to use grep MCP:
- General information search (use WebSearch instead)
- Documentation lookup (use context7 or WebSearch instead)
- Concept explanations or tutorials (use WebSearch instead)

---

## Sequential Thinking MCP Server
- An MCP server implementation that provides a tool for dynamic and reflective problem-solving through a structured thinking process.
### Usage
The Sequential Thinking tool is designed for:
- Breaking down complex problems into steps
- Planning and design with room for revision
- Analysis that might need course correction
- Problems where the full scope might not be clear initially
- Tasks that need to maintain context over multiple steps
- Situations where irrelevant information needs to be filtered out

---

## fetcher
- MCP server for fetch web page content using Playwright headless browser.
- **Prefer using fetcher mcp when getting information from website is needed**

### Advantages
- **JavaScript Support**: Unlike traditional web scrapers, Fetcher MCP uses Playwright to execute JavaScript, making it capable of handling dynamic web content and modern web applications.
- **Intelligent Content Extraction**: Built-in Readability algorithm automatically extracts the main content from web pages, removing ads, navigation, and other non-essential elements.
- **Flexible Output Format**: Supports both HTML and Markdown output formats, making it easy to integrate with various downstream applications.
- **Parallel Processing**: The `fetch_urls` tool enables concurrent fetching of multiple URLs, significantly improving efficiency for batch operations.
- **Resource Optimization**: Automatically blocks unnecessary resources (images, stylesheets, fonts, media) to reduce bandwidth usage and improve performance.
- **Robust Error Handling**: Comprehensive error handling and logging ensure reliable operation even when dealing with problematic web pages.
- **Configurable Parameters**: Fine-grained control over timeouts, content extraction, and output formatting to suit different use cases.

### Tips
#### Handling Special Website Scenarios
##### Dealing with Anti-Crawler Mechanisms
- **Wait for Complete Loading**: For websites using CAPTCHA, redirects, or other verification mechanisms, include in your prompt:
  ```
  Please wait for the page to fully load
  ```

  This will use the `waitForNavigation: true` parameter.

- **Increase Timeout Duration**: For websites that load slowly:
  ```
  Please set the page loading timeout to 60 seconds
  ```
  This adjusts both `timeout` and `navigationTimeout` parameters accordingly.

##### Content Retrieval Adjustments
- **Preserve Original HTML Structure**: When content extraction might fail:
  ```
  Please preserve the original HTML content
  ```

  Sets `extractContent: false` and `returnHtml: true`.

- **Fetch Complete Page Content**: When extracted content is too limited:
  ```
  Please fetch the complete webpage content instead of just the main content
  ```

  Sets `extractContent: false`.

- **Return Content as HTML**: When HTML format is needed instead of default Markdown:
  ``` Please return the content in HTML format
  ```
  Sets `returnHtml: true`.

---

## notionMCP
- **Always use when notion related task is needed**

---

## serena
- Serena provides essential semantic code retrieval and editing tools that are akin to an IDE's capabilities, extracting code entities at the symbol level and exploiting relational structure. When combined with an existing coding agent, these tools greatly enhance (token) efficiency.
- Do not use Serena on large-scale `Java` projects.
- Always onboard or search project based on path names.
- Prefer using serena for project-specific code search and simple replace, correction tasks.
- Do not use serena for complex refactoring or large-scale code modifications, since it needs to be handled and reviewed by ai agents.
- Ensure to consult project documentation for additional guidelines related to code practices.

---
