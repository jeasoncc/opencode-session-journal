# Session Journals Directory Structure

## Directory Structure

```
.opencode/session-journals/
├── year-2026-Horse/
│   ├── month-03-March/
│   │   ├── day-09-Monday/
│   │   │   ├── journal-1741234567-02:16:45.md
│   │   │   └── journal-1741245678-14:30:22.md
│   │   └── day-10-Tuesday/
│   │       └── journal-1741334567-09:15:30.md
│   └── month-04-April/
│       └── day-01-Monday/
│           └── journal-1743012345-09:15:30.md
└── README.md (this file)
```

## Naming Rules

### Filename Format
```
journal-{unix_timestamp}-{HH:MM:SS}.md
```

- **unix_timestamp**: Unix timestamp (seconds since epoch)
- **HH:MM:SS**: Human-readable time (24-hour format)

### Directory Structure
```
year-YYYY-Zodiac/month-MM-MonthName/day-DD-Weekday/
```

- **year-YYYY-Zodiac**: Year with Chinese zodiac animal
  - 2026 = Horse, 2027 = Goat, 2028 = Monkey, 2029 = Rooster
  - 2030 = Dog, 2031 = Pig, 2032 = Rat, 2033 = Ox
  - Formula: `(year - 1900) % 12` maps to zodiac array
- **month-MM-MonthName**: Month number (01-12) and full English name
  - 01 = January, 02 = February, 03 = March, etc.
- **day-DD-Weekday**: Day number (01-31) and weekday name
  - Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday

## Examples

### Session started on March 9, 2026 at 02:16:45
```
.opencode/session-journals/year-2026-Horse/month-03-March/day-09-Monday/journal-1741234567-02:16:45.md
```

### Multiple sessions on the same day
```
.opencode/session-journals/year-2026-Horse/month-03-March/day-09-Monday/
├── journal-1741234567-02:16:45.md  (morning 02:16)
├── journal-1741245678-14:30:22.md  (afternoon 14:30)
└── journal-1741267890-20:15:30.md  (evening 20:15)
```

### Sessions across different months
```
.opencode/session-journals/
├── year-2026-Horse/
│   ├── month-03-March/
│   │   └── day-09-Monday/
│   │       └── journal-1741234567-02:16:45.md
│   ├── month-04-April/
│   │   └── day-15-Tuesday/
│   │       └── journal-1743456789-10:30:00.md
│   └── month-12-December/
│       └── day-25-Thursday/
│           └── journal-1766789012-09:15:30.md
└── year-2027-Goat/
    └── month-01-January/
        └── day-05-Monday/
            └── journal-1767890123-14:20:00.md
```

## Advantages

### 1. Time Organization
- Grouped by year/month for long-term management
- Avoids single directory with too many files
- Natural chronological browsing

### 2. Quick Location
- Find specific time journals quickly by date
- Unix timestamp ensures uniqueness
- Human-readable time for easy identification

### 3. Clear Hierarchy
- Not too deep (4 levels)
- Not too shallow (avoids file accumulation)
- Balanced structure for navigation

### 4. Easy Maintenance
- Archive old journals by month
- Delete expired data by year
- Clear organizational boundaries

### 5. Cultural Context
- Chinese zodiac adds memorable context
- Full month/weekday names improve readability
- Inspired by org-roam's diary structure

## Use Cases

### Case 1: Find yesterday's work
```bash
# If today is March 10, 2026 (Tuesday)
ls .opencode/session-journals/year-2026-Horse/month-03-March/day-09-Monday/
```

### Case 2: View all sessions this month
```bash
ls .opencode/session-journals/year-2026-Horse/month-03-March/
```

### Case 3: Archive last year's journals
```bash
tar -czf session-journals-2025.tar.gz .opencode/session-journals/year-2025-Snake/
rm -rf .opencode/session-journals/year-2025-Snake/
```

### Case 4: Count this month's work sessions
```bash
find .opencode/session-journals/year-2026-Horse/month-03-March/ -name "*.md" | wc -l
```

### Case 5: Find all Monday sessions
```bash
find .opencode/session-journals -type d -name "day-*-Monday"
```

## Journal Content

Each journal file contains:

1. **Session Information**: Start time, task description
2. **Timeline Records**: Chronological record of each action
3. **Problems and Solutions**: Issues encountered and how they were solved
4. **Key Decisions**: Important technical decisions and rationale
5. **Session Summary**: Completed work, current state, pending tasks

## Integration with Other Tools

### With Handoff
When switching sessions, action logs can directly generate handoff summaries.

### With Git
Each important commit is recorded in the action log.

### With Todo
Todo creation, completion, and modifications are synced to action log.

## Maintenance Recommendations

### Regular Archiving
Recommend archiving old journals quarterly:
```bash
# Archive 2026 Q1
tar -czf archives/2026-Q1-session-journals.tar.gz \
  .opencode/session-journals/year-2026-Horse/month-01-January/ \
  .opencode/session-journals/year-2026-Horse/month-02-February/ \
  .opencode/session-journals/year-2026-Horse/month-03-March/
```

### Cleanup Strategy
- Keep last 3 months of journals
- Compress and archive 3-12 month old journals
- Delete journals older than 12 months (if backed up)

## Automation Scripts

### View most recent journal
```bash
#!/bin/bash
# View most recent session journal
find .opencode/session-journals -name "*.md" -type f -printf '%T@ %p\n' | \
  sort -rn | head -1 | cut -d' ' -f2- | xargs cat
```

### Generate monthly report
```bash
#!/bin/bash
# Generate work summary for current month
YEAR=$(date +%Y)
MONTH=$(date +%m)
MONTH_NAME=$(date +%B)

# Calculate zodiac
ZODIAC_INDEX=$(( ($YEAR - 1900) % 12 ))
ZODIACS=("Rat" "Ox" "Tiger" "Rabbit" "Dragon" "Snake" "Horse" "Goat" "Monkey" "Rooster" "Dog" "Pig")
ZODIAC=${ZODIACS[$ZODIAC_INDEX]}

echo "# $YEAR-$MONTH Work Summary"
echo ""
find .opencode/session-journals/year-$YEAR-$ZODIAC/month-$MONTH-$MONTH_NAME/ -name "*.md" | while read file; do
  echo "## $(basename $file)"
  grep "^### 🎉" "$file" || echo "No major milestones"
  echo ""
done
```

### List sessions by weekday
```bash
#!/bin/bash
# Find all sessions on a specific weekday
WEEKDAY=$1  # e.g., "Monday"
find .opencode/session-journals -type d -name "day-*-$WEEKDAY" | while read dir; do
  echo "=== $dir ==="
  ls "$dir"
  echo ""
done
```

## Comparison with Other Formats

| Format | Advantages | Disadvantages |
|--------|-----------|---------------|
| **Org-roam style** (this) | Human-readable, culturally rich, easy browsing | Slightly longer paths |
| **Flat YYYY-MM-DD** | Simple, short paths | Hard to manage with many files |
| **Timestamp only** | Unique, sortable | Not human-readable |
| **Session ID only** | Unique identifier | No time context |

## Migration from Old Format

If migrating from `.sisyphus/action-logs/YYYY/MM/DD-HHMMSS-ses_*.md`:

```bash
#!/bin/bash
# Migration script (example)
OLD_DIR=".sisyphus/action-logs"
NEW_DIR=".opencode/session-journals"

find "$OLD_DIR" -name "*.md" | while read old_file; do
  # Extract date components
  # Parse filename and create new path
  # Move file to new location
  echo "Migrating: $old_file"
done
```

---

**Created**: 2026-03-09  
**Version**: 2.0  
**Format**: Org-roam inspired
