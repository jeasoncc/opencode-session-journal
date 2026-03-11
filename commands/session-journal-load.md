# Load Session Journal

Load and display previously saved session journals.

## Execute These Steps

### 1. Determine Target

If user provided argument:
- `list` → Find all journals, display list, STOP
- Date (YYYY-MM-DD, today, yesterday) → Find journals for that date
- Session ID → Find journal with that session ID
- No argument → Find most recent journal

### 2. Find Journal Files

Run these commands:

```bash
# Set journal directory (use global path)
JOURNAL_DIR="$HOME/.opencode/session-journals"

# Most recent journal
find "$JOURNAL_DIR" -name "*.md" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-

# Specific date (example: 2026-03-09)
find "$JOURNAL_DIR" -path "*/day-09-*/*.md" -name "*.md" 2>/dev/null

# List all journals
find "$JOURNAL_DIR" -name "*.md" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn
```

### 3. Read and Display Journal

Read the journal file and extract key sections:
- Session ID and start time from header
- Completed work items (lines with ✅)
- Problems solved (lines with ⚠️)
- Key decisions
- Important files
- Current state
- Pending tasks
- Recommendations

Display formatted summary with the extracted information.

### 4. Load Context

Read the FULL journal content into context. This allows you to understand:
- What was done in previous session
- What problems were encountered
- What decisions were made
- What files are important
- What needs to be done next

After loading, confirm: "✅ Journal loaded. I understand the previous work and can continue from: [brief summary of current state]"

## Examples

**Load most recent:**
```
/session-journal-load
```

**List all journals:**
```
/session-journal-load list
```

**Load specific date:**
```
/session-journal-load 2026-03-09
```

**Load by session ID:**
```
/session-journal-load ses_abc123
```

## Error Handling

If no journals found:
- Display: "❌ No session journals found. Use /session-journal-save to create one."
- STOP

If journal file is corrupted or unreadable:
- Display: "⚠️ Journal file corrupted: [path]"
- Try next most recent journal
- If all fail, STOP with error message
