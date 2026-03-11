# AGENTS.md - OpenCode Session Journal

## Project Overview

OpenCode Session Journal is a lightweight skill providing session persistence through markdown-based logging. This is a **documentation-heavy project** with no traditional code compilation - the "code" is markdown documentation, bash scripts, and command definitions.

## Project Type

- **Language**: Markdown + Bash
- **Framework**: OpenCode skill system
- **Build System**: None (documentation project)
- **Testing**: Manual verification of commands

## File Structure

```
opencode-session-journal/
├── skill.md                    # Main skill definition (when to use, patterns)
├── commands/
│   ├── session-journal-save.md    # Save command implementation
│   └── session-journal-load.md    # Load command implementation
├── examples/
│   ├── log-structure.md        # Directory structure documentation
│   └── sample-log.md           # Example journal entry
├── install.sh                  # Installation script
├── README.md                   # User-facing documentation
├── CONTRIBUTING.md             # Contribution guidelines
├── LICENSE                     # MIT license
└── AGENTS.md                   # This file
```

## Commands

### Installation
```bash
./install.sh
```
Copies skill and commands to `~/.config/opencode/` or `~/.opencode/`

### Manual Testing
```bash
# Test save command (in OpenCode session)
/session-journal-save "Test message"

# Test load command
/session-journal-load
/session-journal-load list
/session-journal-load 2026-03-09

# Verify directory structure
ls -R .opencode/session-journals/

# Check file content
cat .opencode/session-journals/year-*/month-*/day-*/journal-*.md
```

### Verification Checklist
- [ ] Commands execute without errors
- [ ] Directory structure follows org-roam format
- [ ] Journal files contain all required sections
- [ ] Timestamps are correct (Unix + HH:MM:SS)
- [ ] Zodiac calculation is accurate
- [ ] Month/weekday names are correct

## Code Style Guidelines

### Markdown Standards

**Headers**: Use ATX-style headers (`#` not `===`)
```markdown
# Top Level
## Second Level
### Third Level
```

**Code Blocks**: Always use fenced code blocks with language tags
```markdown
```bash
/session-journal-save "Example"
```
```

**Tables**: Use for comparisons and structured data
```markdown
| Feature | Value |
|---------|-------|
| Type    | Skill |
```

**Emoji**: Use sparingly and consistently
- 🎯 Started Task
- 🔧 Action
- ⚠️ Problem
- ✅ Completed
- 📊 Summary
- 💡 Tip/Recommendation
- 📝 Documentation
- 📖 Loading/Reading
- 📚 List/Collection

### Directory Naming Convention

**CRITICAL**: All documentation must reference the org-roam inspired format:

```
.opencode/session-journals/
  year-YYYY-Zodiac/
    month-MM-MonthName/
      day-DD-Weekday/
        journal-{timestamp}-{HH:MM:SS}.md
```

**Components**:
- `year-YYYY-Zodiac`: Year + Chinese zodiac (2026 = Horse, 2027 = Goat, etc.)
  - Formula: `(year - 1900) % 12` maps to zodiac array
- `month-MM-MonthName`: Month number (01-12) + full English name (January, February, etc.)
- `day-DD-Weekday`: Day number (01-31) + weekday name (Monday, Tuesday, etc.)
- `journal-{unix_timestamp}-{HH:MM:SS}.md`: Unix timestamp + human-readable time

**DO NOT reference old format**:
- ❌ `.sisyphus/action-logs/YYYY/MM/DD-HHMMSS-ses_*.md`
- ✅ `.opencode/session-journals/year-YYYY-Zodiac/month-MM-MonthName/day-DD-Weekday/journal-*.md`

### Language Requirements

- **English only**: All documentation must be in professional English
- **No Chinese text**: Remove any Chinese characters before committing
- **Tone**: Clear, concise, technical but accessible
- **Voice**: Professional but friendly

### Journal Content Structure

Every journal file must contain:

1. **Header Section**
   ```markdown
   # Session Journal - [session-id]
   
   **Start Time**: YYYY-MM-DD HH:MM:SS
   **Task**: [User request]
   ```

2. **Timeline Section**
   ```markdown
   ## YYYY-MM-DD HH:MM:SS
   ### 🎯 Started Task: [Task name]
   - **User Request**: [Original request]
   - **Initial State**: [State description]
   - **Plan**: [Execution plan]
   ```

3. **Action Entries** (use appropriate emoji)
   - 🔧 Action: Regular actions
   - ⚠️ Problem: Issues encountered
   - ✅ Completed: Finished work
   - 💡 Key Finding: Important discoveries

4. **Summary Section**
   ```markdown
   ## 📊 Session Summary
   
   ### Completed Work
   ### Problems Solved
   ### Key Decisions
   ### Current State
   ### Pending Tasks
   ### Important Files
   ### Recommendations for Next Session
   ```

## Commit Message Format

Follow conventional commits:

```
feat: add support for custom journal templates
fix: correct zodiac calculation for years before 1900
docs: update README with comparison table
refactor: simplify directory path generation
```

**Types**:
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Testing changes
- `chore:` - Maintenance tasks

## Error Handling

### Common Issues

**Directory creation fails**:
- Check write permissions on `.opencode/` directory
- Verify parent directories exist
- Check disk space

**Zodiac calculation incorrect**:
- Verify formula: `(year - 1900) % 12`
- Check zodiac array: ["Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake", "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"]
- Test edge cases: years before 1900, leap years

**Month/weekday name wrong**:
- Use full English names (not abbreviations)
- January-December (not Jan-Dec)
- Monday-Sunday (not Mon-Sun)

## Testing Strategy

### Manual Testing Workflow

1. **Install the skill**
   ```bash
   ./install.sh
   ```

2. **Test save command**
   ```bash
   # In OpenCode session
   /session-journal-save "Test entry"
   ```

3. **Verify directory structure**
   ```bash
   # Check year/zodiac
   ls .opencode/session-journals/
   # Should show: year-2026-Horse (or current year)
   
   # Check month
   ls .opencode/session-journals/year-*/
   # Should show: month-03-March (or current month)
   
   # Check day
   ls .opencode/session-journals/year-*/month-*/
   # Should show: day-09-Monday (or current day)
   
   # Check journal file
   ls .opencode/session-journals/year-*/month-*/day-*/
   # Should show: journal-{timestamp}-{HH:MM:SS}.md
   ```

4. **Verify file content**
   ```bash
   cat .opencode/session-journals/year-*/month-*/day-*/journal-*.md
   ```
   - Check all sections present
   - Verify timestamps are correct
   - Confirm markdown formatting

5. **Test load command**
   ```bash
   /session-journal-load
   /session-journal-load list
   /session-journal-load today
   ```

### Edge Cases to Test

- Multiple sessions on same day
- Sessions across month boundaries
- Sessions across year boundaries
- Leap years (February 29)
- Years before 1900 (if applicable)
- Special characters in task descriptions
- Very long journal entries

## Integration Points

### With OpenCode
- Skill loaded from `~/.config/opencode/skills/` or `~/.opencode/skills/`
- Commands available as `/session-journal-save` and `/session-journal-load`
- Integrates with OpenCode session system

### With Git
- Journal files typically NOT committed (add to .gitignore)
- Skill files ARE committed to this repository
- Use conventional commits for changes

### With /handoff Command
- Session journals provide detailed history
- `/handoff` provides brief summaries
- Use both: journals for long-term, handoff for immediate transfer

## Best Practices for Agents

### When Modifying Documentation

1. **Read existing style first**: Check similar files for patterns
2. **Maintain consistency**: Match existing emoji usage, formatting, structure
3. **Test manually**: Verify commands work after changes
4. **Update all references**: If changing structure, update all docs
5. **Professional English**: No casual language, no Chinese text

### When Adding Features

1. **Update skill.md**: Add to "When to Use" section
2. **Update command files**: Add new usage examples
3. **Update README.md**: Add to user-facing documentation
4. **Update CONTRIBUTING.md**: Add testing procedures
5. **Update examples/**: Add sample output

### When Fixing Bugs

1. **Identify root cause**: Don't just fix symptoms
2. **Test edge cases**: Verify fix works in all scenarios
3. **Update documentation**: If behavior changes, update docs
4. **Add to troubleshooting**: Document the issue and solution

## Common Patterns

### Directory Path Generation
```bash
# Calculate zodiac
ZODIAC_INDEX=$(( ($YEAR - 1900) % 12 ))
ZODIACS=("Rat" "Ox" "Tiger" "Rabbit" "Dragon" "Snake" "Horse" "Goat" "Monkey" "Rooster" "Dog" "Pig")
ZODIAC=${ZODIACS[$ZODIAC_INDEX]}

# Build path
JOURNAL_DIR=".opencode/session-journals/year-${YEAR}-${ZODIAC}/month-${MONTH}-${MONTH_NAME}/day-${DAY}-${WEEKDAY}"
```

### Timestamp Generation
```bash
# Unix timestamp
TIMESTAMP=$(date +%s)

# Human-readable time
TIME=$(date +%H:%M:%S)

# Filename
FILENAME="journal-${TIMESTAMP}-${TIME}.md"
```

### Finding Latest Journal
```bash
find .opencode/session-journals -name "*.md" -type f -printf '%T@ %p\n' | \
  sort -rn | head -1 | cut -d' ' -f2-
```

## Maintenance

### Regular Tasks
- Review and archive old journals quarterly
- Update zodiac array if needed (currently supports 1900-2099)
- Check for broken links in documentation
- Verify install.sh works on different systems

### Before Release
- [ ] All documentation in English
- [ ] No references to old directory format
- [ ] All examples tested and working
- [ ] README.md up to date
- [ ] CONTRIBUTING.md reflects current process
- [ ] install.sh tested on clean system

---

**Version**: 1.0  
**Last Updated**: 2026-03-09  
**Maintained By**: OpenCode Session Journal Contributors
