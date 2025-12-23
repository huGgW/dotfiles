# CLI tool usage guideline

This guideline provides instructions for AI agents to use modern CLI tools effectively in Claude Code and other environments.

## Modern CLI Tool Alternatives

Use these modern alternatives instead of traditional commands:
- **`bat`** instead of `cat` - for viewing file contents with syntax highlighting
- **`rg`** (ripgrep) instead of `grep` - for fast text searching
- **`fd`** instead of `find` - for fast file finding
- **`gh`** for GitHub-related operations

## bat (Better Cat)

**Usage**: Enhanced file viewer with syntax highlighting and Git integration

### Basic Usage
```bash
bat -P filename.txt                # View file with syntax highlighting
bat -P file1.py file2.js          # View multiple files
bat --style=numbers filename.py    # Show line numbers
bat --style=grid filename.md       # Show file boundaries
```

### Recommended Flags
- **Always use `-P` flags**: Ensures output without paging for clean display and prevent error
  - `-P`: Disable paging (no scrolling interface)

### Key Features
- Automatic syntax highlighting based on file extension
- Git integration showing file changes
- Line numbers and file boundaries
- Paging support for large files

### When to Use
- Viewing source code files
- Reading configuration files
- Displaying file contents with better readability than `cat`

## rg (ripgrep)

**Usage**: Ultra-fast text search tool with powerful pattern matching

### Basic Usage
```bash
rg "pattern"                        # Search in current directory
rg "function.*main" --type py       # Search with regex in Python files
rg "TODO" --ignore-case             # Case-insensitive search
rg "error" src/                     # Search in specific directory
```

### Advanced Features
```bash
rg "import" --type js --stats       # Show search statistics
rg "class \w+" --only-matching      # Show only matching part
rg "bug" --context 3                # Show 3 lines before/after match
rg "config" --glob "*.yaml"         # Search in specific file patterns
```

### When to Use
- Searching for code patterns across projects
- Finding function/variable definitions
- Locating configuration values
- Code analysis and debugging

## fd (Fast Find)

**Usage**: Simple and fast alternative to `find` with intuitive syntax

### Basic Usage
```bash
fd filename                         # Find files by name
fd "\.py$"                         # Find Python files (regex)
fd --type f --extension js          # Find JavaScript files
fd --type d config                  # Find directories named 'config'
```

### Advanced Features
```bash
fd --hidden --no-ignore "\.env"     # Include hidden/ignored files
fd --size +1M                       # Find files larger than 1MB
fd --changed-within 1week           # Find recently modified files
fd "test" --exec rm {}              # Execute command on found files
```

### When to Use
- Locating files by name or pattern
- Finding specific file types
- Cleaning up build artifacts
- Project structure exploration

## gh (GitHub CLI)

**Usage**: Official GitHub command-line tool for repository operations

### Repository Operations
```bash
gh repo view                        # View current repository info
gh repo clone owner/repo            # Clone repository
gh repo create new-project          # Create new repository
gh repo fork owner/repo              # Fork repository
```

### Pull Request Operations
```bash
gh pr create --title "Fix bug" --body "Description"
gh pr list                          # List pull requests
gh pr view 123                      # View specific PR
gh pr merge 123                     # Merge pull request
gh pr checkout 123                  # Checkout PR locally
```

### Issue Operations
```bash
gh issue create --title "Bug report"
gh issue list --state open          # List open issues
gh issue view 456                   # View specific issue
gh issue close 456                  # Close issue
```

### When to Use
- Creating and managing pull requests
- Working with GitHub issues
- Repository management operations
- GitHub Actions workflow management
- Avoiding manual GitHub web interface operations

## Best Practices

1. **Always prefer modern tools**: Use bat, rg, fd, and gh instead of traditional alternatives
2. **Use bat with `-P` flags**: Always include these flags for output without paging
3. **Leverage syntax highlighting**: Use bat for better code readability
4. **Use type filters**: Specify file types with rg and fd for better performance
5. **GitHub automation**: Use gh for any GitHub-related operations to maintain consistency
6. **Combine tools**: Chain commands effectively (e.g., `fd "\.py$" | xargs rg "TODO"`)

## Error Handling

- If modern tools are not available, fall back to traditional commands with appropriate warnings
- Provide installation instructions when tools are missing
- Use `--help` flag for quick reference on unfamiliar options

