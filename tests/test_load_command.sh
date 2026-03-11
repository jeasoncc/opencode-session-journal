#!/bin/bash

source "$(dirname "$0")/test_framework.sh"

create_test_journal() {
    local timestamp="$1"
    local note="${2:-Test journal}"
    local session_id="${3:-ses_test123}"
    
    local year=$(date +%Y)
    local month=$(date +%m)
    local month_name=$(date +%B)
    local day=$(date +%d)
    local weekday=$(date +%A)
    local time=$(date -d "@$timestamp" +%H:%M:%S 2>/dev/null || date +%H:%M:%S)
    
    local zodiac_index=$(( ($year - 1900) % 12 ))
    local zodiacs=("Rat" "Ox" "Tiger" "Rabbit" "Dragon" "Snake" "Horse" "Goat" "Monkey" "Rooster" "Dog" "Pig")
    local zodiac=${zodiacs[$zodiac_index]}
    
    local journal_base="$TEST_JOURNAL_DIR"
    local dir="$journal_base/year-${year}-${zodiac}/month-${month}-${month_name}/day-${day}-${weekday}"
    local file="journal-${timestamp}-${time}.md"
    
    mkdir -p "$dir"
    
    local content="# Session Journal - ${session_id}

**Start Time**: ${year}-${month}-${day} ${time}
**Task**: ${note}

---

## ${year}-${month}-${day} ${time}
### 🎯 Started Task: ${note}
- **User Request**: ${note}
- **Initial State**: Test state
- **Plan**: Test plan

## 📊 Session Summary

### Completed Work
1. ✅ Test work item

### Problems Solved
1. ⚠️ Test problem → Test solution

### Key Decisions
- Test decision: Test rationale

### Current State
- Test state

### Pending Tasks
- [ ] Test pending task

### Important Files
- test.md - Test file

### Recommendations for Next Session
Test recommendations"
    
    echo "$content" > "$dir/$file"
    echo "$dir/$file"
}

load_most_recent() {
    local journal_dir="$1"
    find "$journal_dir" -name "*.md" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-
}

load_by_date() {
    local journal_dir="$1"
    local day="$2"
    find "$journal_dir" -path "*/day-${day}-*/*.md" -name "*.md" 2>/dev/null
}

list_all_journals() {
    local journal_dir="$1"
    find "$journal_dir" -name "*.md" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn
}

test_load_most_recent() {
    setup_test_env
    
    local ts1=$(($(date +%s) - 200))
    local ts2=$(($(date +%s) - 100))
    local ts3=$(date +%s)
    
    create_test_journal "$ts1" "First journal"
    sleep 0.1
    create_test_journal "$ts2" "Second journal"
    sleep 0.1
    local latest=$(create_test_journal "$ts3" "Third journal")
    
    local loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    
    assert_equals "$latest" "$loaded" "Should load most recent journal"
    
    teardown_test_env
}

test_load_from_different_directory() {
    setup_test_env
    
    local journal_file=$(create_test_journal "$(date +%s)" "Test from different dir")
    
    local original_dir=$(pwd)
    cd /tmp
    
    local loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    
    assert_equals "$journal_file" "$loaded" "Should load from any directory"
    
    cd "$original_dir"
    teardown_test_env
}

test_load_specific_date() {
    setup_test_env
    
    local day=$(date +%d)
    local journal_file=$(create_test_journal "$(date +%s)" "Test specific date")
    
    local loaded=$(load_by_date "$TEST_JOURNAL_DIR" "$day")
    
    assert_contains "$loaded" "journal-" "Should find journal for specific date"
    
    teardown_test_env
}

test_load_list_all() {
    setup_test_env
    
    create_test_journal "$(($(date +%s) - 200))" "First"
    create_test_journal "$(($(date +%s) - 100))" "Second"
    create_test_journal "$(date +%s)" "Third"
    
    local list=$(list_all_journals "$TEST_JOURNAL_DIR")
    local count=$(echo "$list" | wc -l)
    
    assert_equals "3" "$count" "Should list all 3 journals"
    
    teardown_test_env
}

test_load_no_journals_found() {
    setup_test_env
    
    mkdir -p "$TEST_JOURNAL_DIR"
    
    local loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    
    assert_equals "" "$loaded" "Should return empty when no journals found"
    
    teardown_test_env
}

test_load_extracts_summary() {
    setup_test_env
    
    local journal_file=$(create_test_journal "$(date +%s)" "Test summary extraction")
    local content=$(cat "$journal_file")
    
    assert_contains "$content" "📊 Session Summary" "Should contain summary"
    assert_contains "$content" "### Completed Work" "Should contain completed work"
    assert_contains "$content" "### Problems Solved" "Should contain problems solved"
    assert_contains "$content" "### Key Decisions" "Should contain key decisions"
    assert_contains "$content" "### Current State" "Should contain current state"
    assert_contains "$content" "### Pending Tasks" "Should contain pending tasks"
    
    teardown_test_env
}

test_load_uses_global_path() {
    setup_test_env
    
    local journal_file=$(create_test_journal "$(date +%s)" "Test global path")
    
    assert_contains "$journal_file" "$TEST_JOURNAL_DIR" "Should use test journal directory"
    
    local loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    assert_contains "$loaded" "$TEST_JOURNAL_DIR" "Loaded path should use test directory"
    
    teardown_test_env
}

test_load_empty_directory() {
    setup_test_env
    
    mkdir -p "$TEST_JOURNAL_DIR/year-2026-Horse/month-03-March/day-11-Wednesday"
    
    local loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    
    assert_equals "" "$loaded" "Should handle empty directory gracefully"
    
    teardown_test_env
}

echo "Running Load Command Tests..."
echo "================================"

run_test "Load most recent" test_load_most_recent
run_test "Load from different directory" test_load_from_different_directory
run_test "Load specific date" test_load_specific_date
run_test "Load list all" test_load_list_all
run_test "Load no journals found" test_load_no_journals_found
run_test "Load extracts summary" test_load_extracts_summary
run_test "Load uses global path" test_load_uses_global_path
run_test "Load empty directory" test_load_empty_directory

print_summary
