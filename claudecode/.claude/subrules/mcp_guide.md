# MCP tool usage guideline

## context7
- Context7 MCP pulls up-to-date, version-specific documentation and code examples straight from the source — and places them directly into your prompt.
- use it if you need library / framework information

---

## mcp-gopls
- This MCP server helps AI assistants to:
    - Use LSP to analyze Go code
    - Navigate to definitions and find references
    - Check code diagnostics
    - Get hover information for symbols
    - Get completion suggestions
- use it when you need to interact with Go's Language Server Protocol (LSP) and benefit from advanced Go code analysis features.

---

## Sequential Thinking MCP Server
An MCP server implementation that provides a tool for dynamic and reflective problem-solving through a structured thinking process.

### Features

- Break down complex problems into manageable steps
- Revise and refine thoughts as understanding deepens
- Branch into alternative paths of reasoning
- Adjust the total number of thoughts dynamically
- Generate and verify solution hypotheses

### Tool
#### sequential_thinking
Facilitates a detailed, step-by-step thinking process for problem-solving and analysis.

**Inputs:**
- `thought` (string): The current thinking step
- `nextThoughtNeeded` (boolean): Whether another thought step is needed
- `thoughtNumber` (integer): Current thought number
- `totalThoughts` (integer): Estimated total thoughts needed
- `isRevision` (boolean, optional): Whether this revises previous thinking
- `revisesThought` (integer, optional): Which thought is being reconsidered
- `branchFromThought` (integer, optional): Branching point thought number
- `branchId` (string, optional): Branch identifier
- `needsMoreThoughts` (boolean, optional): If more thoughts are needed

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

### Advantages
- JavaScript Support: Unlike traditional web scrapers, Fetcher MCP uses Playwright to execute JavaScript, making it capable of handling dynamic web content and modern web applications.
- Intelligent Content Extraction: Built-in Readability algorithm automatically extracts the main content from web pages, removing ads, navigation, and other non-essential elements.
- Flexible Output Format: Supports both HTML and Markdown output formats, making it easy to integrate with various downstream applications.
- Parallel Processing: The fetch_urls tool enables concurrent fetching of multiple URLs, significantly improving efficiency for batch operations.
- Resource Optimization: Automatically blocks unnecessary resources (images, stylesheets, fonts, media) to reduce bandwidth usage and improve performance.
- Robust Error Handling: Comprehensive error handling and logging ensure reliable operation even when dealing with problematic web pages.
- Configurable Parameters: Fine-grained control over timeouts, content extraction, and output formatting to suit different use cases.


### Advantages
- **JavaScript Support**: Unlike traditional web scrapers, Fetcher MCP uses Playwright to execute JavaScript, making it capable of handling dynamic web content and modern web applications.
- **Intelligent Content Extraction**: Built-in Readability algorithm automatically extracts the main content from web pages, removing ads, navigation, and other non-essential elements.
- **Flexible Output Format**: Supports both HTML and Markdown output formats, making it easy to integrate with various downstream applications.
- **Parallel Processing**: The `fetch_urls` tool enables concurrent fetching of multiple URLs, significantly improving efficiency for batch operations.
- **Resource Optimization**: Automatically blocks unnecessary resources (images, stylesheets, fonts, media) to reduce bandwidth usage and improve performance.
- **Robust Error Handling**: Comprehensive error handling and logging ensure reliable operation even when dealing with problematic web pages.
- **Configurable Parameters**: Fine-grained control over timeouts, content extraction, and output formatting to suit different use cases.

### Features
- `fetch_url` - Retrieve web page content from a specified URL
  - Uses Playwright headless browser to parse JavaScript
  - Supports intelligent extraction of main content and conversion to Markdown
  - Supports the following parameters:
    - `url`: The URL of the web page to fetch (required parameter)
    - `timeout`: Page loading timeout in milliseconds, default is 30000 (30 seconds)
    - `waitUntil`: Specifies when navigation is considered complete, options: 'load', 'domcontentloaded', 'networkidle', 'commit', default is 'load'
    - `extractContent`: Whether to intelligently extract the main content, default is true
    - `maxLength`: Maximum length of returned content (in characters), default is no limit
    - `returnHtml`: Whether to return HTML content instead of Markdown, default is false
    - `waitForNavigation`: Whether to wait for additional navigation after initial page load (useful for sites with anti-bot verification), default is false
    - `navigationTimeout`: Maximum time to wait for additional navigation in milliseconds, default is 10000 (10 seconds)
    - `disableMedia`: Whether to disable media resources (images, stylesheets, fonts, media), default is true
    - `debug`: Whether to enable debug mode (showing browser window), overrides the --debug command line flag if specified

- `fetch_urls` - Batch retrieve web page content from multiple URLs in parallel
  - Uses multi-tab parallel fetching for improved performance
  - Returns combined results with clear separation between webpages
  - Supports the following parameters:
    - `urls`: Array of URLs to fetch (required parameter)
    - Other parameters are the same as `fetch_url`

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

