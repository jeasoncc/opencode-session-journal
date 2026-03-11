#!/bin/bash

source "$(dirname "$0")/test_framework.sh"

test_create_directory_structure() {
    setup_test_env
    
    local dir="$TEST_JOURNAL_DIR/year-2026-Horse/month-03-March/day-11-Wednesday"
    mkdir -p "$dir"
    
    assert_dir_exists "$dir" "Directory structure should be created"
    
    teardown_test_env
}

test_write_journal_file() {
    setup_test_env
    
    local dir="$TEST_JOURNAL_DIR/year-2026-Horse/month-03-March/day-11-Wednesday"
    mkdir -p "$dir"
    
    local file="$dir/journal-1773164617-01:43:37.md"
    local content="# Session Journal - ses_test123

**Start Time**: 2026-03-11 01:43:37
**Task**: Test task"
    
    echo "$content" > "$file"
    
    assert_file_exists "$file" "Journal file should be created"
    
    teardown_test_env
}

test_read_journal_file() {
    setup_test_env
    
    local dir="$TEST_JOURNAL_DIR/year-2026-Horse/month-03-March/day-11-Wednesday"
    mkdir -p "$dir"
    
    local file="$dir/journal-1773164617-01:43:37.md"
    local expected_content="Test content"
    
    echo "$expected_content" > "$file"
    local actual_content=$(cat "$file")
    
    assert_equals "$expected_content" "$actual_content" "File content should match"
    
    teardown_test_env
}

test_find_most_recent_journal() {
    setup_test_env
    
    local dir="$TEST_JOURNAL_DIR/year-2026-Horse/month-03-March/day-11-Wednesday"
    mkdir -p "$dir"
    
    touch "$dir/journal-1773164617-01:43:37.md"
    sleep 0.1
    touch "$dir/journal-1773164700-01:45:00.md"
    sleep 0.1
    touch "$dir/journal-1773164800-01:46:40.md"
    
    local most_recent=$(find "$TEST_JOURNAL_DIR" -name "*.md" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
    
    assert_contains "$most_recent" "journal-1773164800-01:46:40.md" "Should find most recent journal"
    
    teardown_test_env
}

test_find_journals_by_date() {
    setup_test_env
    
    local dir1="$TEST_JOURNAL_DIR/year-2026-Horse/month-03-March/day-11-Wednesday"
    local dir2="$TEST_JOURNAL_DIR/year-2026-Horse/month-03-March/day-12-Thursday"
    mkdir -p "$dir1" "$dir2"
    
    touch "$dir1/journal-1773164617-01:43:37.md"
    touch "$dir1/journal-1773164700-01:45:00.md"
    touch "$dir2/journal-1773251017-01:43:37.md"
    
    local day11_journals=$(find "$TEST_JOURNAL_DIR" -path "*/day-11-*/*.md" -name "*.md" 2>/dev/null | wc -l)
    
    assert_equals "2" "$day11_journals" "Should find 2 journals for day 11"
    
    teardown_test_env
}

test_list_all_journals() {
    setup_test_env
    
    local dir="$TEST_JOURNAL_DIR/year-2026-Horse/month-03-March/day-11-Wednesday"
    mkdir -p "$dir"
    
    touch "$dir/journal-1773164617-01:43:37.md"
    touch "$dir/journal-1773164700-01:45:00.md"
    touch "$dir/journal-1773164800-01:46:40.md"
    
    local journal_count=$(find "$TEST_JOURNAL_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
    
    assert_equals "3" "$journal_count" "Should list all 3 journals"
    
    teardown_test_env
}

test_empty_journal_directory() {
    setup_test_env
    
    mkdir -p "$TEST_JOURNAL_DIR"
    
    local journal_count=$(find "$TEST_JOURNAL_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
    
    assert_equals "0" "$journal_count" "Empty directory should have 0 journals"
    
    teardown_test_env
}

test_journal_content_structure() {
    setup_test_env
    
    local dir="$TEST_JOURNAL_DIR/year-2026-Horse/month-03-March/day-11-Wednesday"
    mkdir -p "$dir"
    
    local file="$dir/journal-1773164617-01:43:37.md"
    local content="# Session Journal - ses_test123

**Start Time**: 2026-03-11 01:43:37
**Task**: Test task

---

## 2026-03-11 01:45:00
### 🎯 Started Task: Test task
- **User Request**: Test request

## 📊 Session Summary

### Completed Work
1. ✅ Test work"
    
    echo "$content" > "$file"
    
    local file_content=$(cat "$file")
    assert_contains "$file_content" "# Session Journal" "Should contain header"
    assert_contains "$file_content" "**Start Time**" "Should contain start time"
    assert_contains "$file_content" "**Task**" "Should contain task"
    assert_contains "$file_content" "## 📊 Session Summary" "Should contain summary section"
    
    teardown_test_env
}

echo "Running File Operations Tests..."
echo "================================"

run_test "Create directory structure" test_create_directory_structure
run_test "Write journal file" test_write_journal_file
run_test "Read journal file" test_read_journal_file
run_test "Find most recent journal" test_find_most_recent_journal
run_test "Find journals by date" test_find_journals_by_date
run_test "List all journals" test_list_all_journals
run_test "Empty journal directory" test_empty_journal_directory
run_test "Journal content structure" test_journal_content_structure

print_summary
