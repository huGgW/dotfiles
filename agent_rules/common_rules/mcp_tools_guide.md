# MCP Tools Usage Guide

## AST-grep
**When to use:** Analyzing or refactoring code structure programmatically
- **whenever a search requires syntax-aware or structural matching, default to ast-grep --lang go -p '<pattern>' (or set --lang appropriately) and avoid falling back to text-only tools like rg or grep unless I explicitly request a plain-text search.**
- Finding specific code patterns across large codebases
- Performing structural code searches beyond simple text matching
- Understanding syntax tree structure for complex refactoring

## Context7
**When to use:** Accessing up-to-date library documentation
- Getting official documentation for npm packages or libraries
- Understanding API specifications and usage examples
- Finding version-specific documentation

## GitHub Code Search (grep_searchGitHub)
**When to use:** Finding real-world code examples and implementation patterns
- Learning how to use unfamiliar APIs or libraries
- Discovering best practices from production codebases
- Finding syntax examples for specific library functions

## DeepWiki
**When to use:** Understanding GitHub repository structure and features
- Reading repository documentation and wikis
- Asking questions about specific repository implementation
- Exploring repository architecture and design decisions

## MarkItDown
**When to use:** Converting various document formats to Markdown
- Processing documents from URLs or local files
- Extracting content from PDFs, Office docs, or web pages
- Preparing content for documentation or knowledge base

## Notion Tools
**When to use:** Managing documentation, knowledge bases, or project databases in Notion
- Creating/updating pages, databases, and structured content
- Searching across workspace content and connected sources
- Managing comments, teams, and collaborative workflows

## Linear Tools
**When to use:** Managing software development issues and project tracking
- Creating, updating, or searching issues and projects
- Managing issue states, labels, cycles, and assignments
- Adding comments or tracking project progress
