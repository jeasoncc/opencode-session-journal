# Optimization Summary - OpenCode Session Journal

## Problem Identified

When executing `/session-journal-load`, the AI treated it as a feature to be improved rather than a command to execute immediately.

## Root Cause

Command documentation used **descriptive language** instead of **imperative instructions**.

### Before (Descriptive - Wrong)
```markdown
## Purpose
Load previously saved session journals to quickly understand historical work content.

## Execution Steps
### 1. Find Journal File
Find the corresponding journal based on parameters...
```

### After (Imperative - Correct)
```markdown
# Load Session Journal

Load and display previously saved session journals.

## Execute These Steps

### 1. Determine Target
If user provided argument:
- `list` → Find all journals, display list, STOP
- Date (YYYY-MM-DD, today, yesterday) → Find journals for that date
```

## Changes Made

### 1. Command Files Rewritten

**session-journal-load.md**
- Changed from descriptive documentation to direct execution instructions
- Used imperative verbs: "Run these commands", "Read the journal", "Display"
- Removed verbose examples and "smart features" that confused the AI
- Focused on: What to do, how to do it, when to stop

**session-journal-save.md**
- Simplified from 208 lines to ~100 lines
- Removed "Auto-Suggest Triggers" and "Best Practices" sections
- Changed "Purpose" to direct action: "Generate and save current session progress"
- Added explicit bash commands for directory creation

### 2. Skill File Simplified

**skill.md**
- Reduced from 214 lines to ~50 lines
- Removed verbose examples and "Common Mistakes" section
- Kept only essential: When to use, commands table, log structure
- Focused on actionable information

### 3. Files Updated

```bash
✅ commands/session-journal-load.md - Rewritten (imperative style)
✅ commands/session-journal-save.md - Rewritten (imperative style)
✅ skill.md - Simplified (essential info only)
✅ Installed to ~/.opencode/commands/
✅ Installed to ~/.opencode/skills/opencode-session-journal/
```

## Key Principles Applied

1. **Imperative over Descriptive**
   - ❌ "This command will load journals"
   - ✅ "Load journals by running these commands"

2. **Direct Instructions over Examples**
   - ❌ "Example output shows..."
   - ✅ "Display: [exact format]"

3. **Action-Oriented Headers**
   - ❌ "Purpose", "Overview", "Usage"
   - ✅ "Execute These Steps", "Run these commands"

4. **Minimal Documentation**
   - Remove: Smart features, troubleshooting, best practices
   - Keep: What to do, how to do it, when to stop

## Comparison with Working Commands

Analyzed `/code-review` command structure:
```markdown
# Code Review

Comprehensive security and quality review of uncommitted changes:

1. Get changed files: git diff --name-only HEAD
2. For each changed file, check for:
   **Security Issues (CRITICAL):**
   - Hardcoded credentials, API keys, tokens
```

Notice:
- Direct title (no "Purpose" section)
- Numbered steps with explicit commands
- Imperative language throughout
- No verbose examples or edge cases

## Testing

To verify the fix works:

1. Run `/session-journal-load` in a new OpenCode session
2. AI should immediately:
   - Search for journal files
   - Read and display content
   - Load context
3. AI should NOT:
   - Ask how to improve the command
   - Suggest adding features
   - Treat it as documentation to review

## Lessons Learned

**For OpenCode command design:**
- Commands are execution instructions, not documentation
- Use imperative mood (commands) not indicative mood (descriptions)
- Minimize examples - focus on what to do NOW
- Remove anything that doesn't directly contribute to execution
- Study working commands before writing new ones

**Documentation belongs in:**
- README.md (user-facing)
- CONTRIBUTING.md (developer-facing)
- AGENTS.md (AI agent-facing)

**Commands should contain:**
- Direct execution steps
- Explicit bash commands
- Clear stop conditions
- Minimal context

---

**Date**: 2026-03-10
**Status**: ✅ Complete
**Files Modified**: 3 (commands/session-journal-load.md, commands/session-journal-save.md, skill.md)
