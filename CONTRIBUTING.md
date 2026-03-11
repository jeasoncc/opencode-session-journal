# Contributing to OpenCode Session Journal

Thank you for your interest in contributing!

## How to Contribute

### Reporting Issues

If you find a bug or have a feature request:

1. Check if the issue already exists in GitHub Issues
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment (OS, OpenCode version, etc.)

### Submitting Changes

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
   - Follow the existing code style
   - Update documentation if needed
   - Add examples if applicable
4. **Test your changes**
   - Test with OpenCode
   - Verify commands work as expected
5. **Commit your changes**
   ```bash
   git commit -m "feat: add your feature description"
   ```
   Use conventional commit format:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation
   - `refactor:` for code refactoring
6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Create a Pull Request**

## Development Guidelines

### File Structure

```
opencode-session-journal/
├── skill.md              # Main skill definition
├── commands/
│   ├── session-journal-save.md     # Save command
│   └── session-journal-load.md     # Load command
├── examples/
│   ├── log-structure.md  # Directory structure
│   └── sample-log.md     # Example journal
├── README.md
├── LICENSE
└── CONTRIBUTING.md
```

### Skill Format

Follow the standard skill.md format:
- Clear usage instructions
- Examples for common scenarios
- Integration notes
- Professional English throughout

### Command Format

Commands should include:
- Clear purpose statement
- Usage examples
- Step-by-step execution
- Configuration options
- Troubleshooting section

### Documentation Standards

- **Language**: Professional English only
- **Tone**: Clear, concise, technical but accessible
- **Format**: Markdown with proper headers and code blocks
- **Examples**: Real-world scenarios with actual commands
- **Paths**: Use new org-roam-inspired format (`.opencode/session-journals/year-YYYY-Zodiac/...`)

### Directory Format

All documentation must reference the new directory structure:

```
.opencode/session-journals/
  year-YYYY-Zodiac/
    month-MM-MonthName/
      day-DD-Weekday/
        journal-{timestamp}-{HH:MM:SS}.md
```

**Do NOT reference old format:**
- ❌ `.sisyphus/action-logs/YYYY/MM/DD-HHMMSS-ses_*.md`
- ✅ `.opencode/session-journals/year-YYYY-Zodiac/month-MM-MonthName/day-DD-Weekday/journal-*.md`

## Testing Guidelines

### Manual Testing

Before submitting a PR, test:

1. **Command execution**
   ```bash
   /session-journal-save "Test message"
   /session-journal-load
   /session-journal-load list
   ```

2. **Directory creation**
   - Verify correct year/zodiac calculation
   - Verify correct month name
   - Verify correct weekday name
   - Verify timestamp format

3. **File content**
   - Check markdown formatting
   - Verify all sections present
   - Check for proper timestamps

4. **Edge cases**
   - Multiple sessions same day
   - Sessions across month boundaries
   - Sessions across year boundaries
   - Leap years

### Documentation Testing

- Read through all documentation for clarity
- Verify all code examples are correct
- Check all internal links work
- Ensure no Chinese text remains

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism
- Focus on what's best for the community

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Publishing others' private information
- Other unprofessional conduct

## Style Guide

### Markdown

- Use ATX-style headers (`#` not `===`)
- Use fenced code blocks with language tags
- Use tables for comparisons
- Use emoji sparingly and consistently

### Code Examples

```bash
# Good: Clear, commented, realistic
/session-journal-save "Completed authentication module"

# Bad: Vague, no context
/session-journal-save "done"
```

### Commit Messages

Follow conventional commits:

```
feat: add support for custom journal templates
fix: correct zodiac calculation for years before 1900
docs: update README with comparison table
refactor: simplify directory path generation
```

## Review Process

1. **Automated checks**: Linting, formatting
2. **Manual review**: Code quality, documentation clarity
3. **Testing**: Functionality verification
4. **Approval**: Maintainer approval required
5. **Merge**: Squash and merge to main

## Getting Help

- **Questions**: Open a GitHub Discussion
- **Bugs**: Open a GitHub Issue
- **Security**: Email maintainers directly (see README)

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to OpenCode Session Journal!**
