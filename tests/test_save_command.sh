#!/bin/bash

source "$(dirname "$0")/test_framework.sh"

save_journal() {
    local note="$1"
    local session_id="${2:-ses_test123}"
    
    local year=$(date +%Y)
    local month=$(date +%m)
    local month_name=$(date +%B)
    local day=$(date +%d)
    local weekday=$(date +%A)
    local timestamp=$(date +%s)
    local time=$(date +%H:%M:%S)
    
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

test_save_creates_journal() {
    setup_test_env
    
    local journal_file=$(save_journal "Test save command")
    
    assert_file_exists "$journal_file" "Save should create journal file"
    
    teardown_test_env
}

test_save_from_different_directory() {
    setup_test_env
    
    local original_dir=$(pwd)
    cd /tmp
    
    local journal_file=$(save_journal "Test from /tmp")
    
    assert_file_exists "$journal_file" "Save should work from any directory"
    
    cd "$original_dir"
    teardown_test_env
}

test_save_with_note() {
    setup_test_env
    
    local note="Completed WeBank SDK integration"
    local journal_file=$(save_journal "$note")
    
    assert_file_exists "$journal_file" "Journal file should exist"
    
    local content=$(cat "$journal_file")
    assert_contains "$content" "$note" "Journal should contain the note"
    
    teardown_test_env
}

test_save_creates_directory_structure() {
    setup_test_env
    
    local journal_file=$(save_journal "Test directory creation")
    local dir=$(dirname "$journal_file")
    
    assert_dir_exists "$dir" "Directory structure should be created"
    assert_contains "$dir" "year-" "Should contain year directory"
    assert_contains "$dir" "month-" "Should contain month directory"
    assert_contains "$dir" "day-" "Should contain day directory"
    
    teardown_test_env
}

test_save_multiple_same_day() {
    setup_test_env
    
    local journal1=$(save_journal "First save")
    sleep 1
    local journal2=$(save_journal "Second save")
    
    assert_file_exists "$journal1" "First journal should exist"
    assert_file_exists "$journal2" "Second journal should exist"
    
    if [ "$journal1" = "$journal2" ]; then
        echo "ERROR: Both journals have same filename"
        return 1
    fi
    
    teardown_test_env
}

test_save_validates_content_structure() {
    setup_test_env
    
    local journal_file=$(save_journal "Test content structure")
    local content=$(cat "$journal_file")
    
    assert_contains "$content" "# Session Journal" "Should have header"
    assert_contains "$content" "**Start Time**" "Should have start time"
    assert_contains "$content" "**Task**" "Should have task"
    assert_contains "$content" "🎯 Started Task" "Should have started task section"
    assert_contains "$content" "📊 Session Summary" "Should have summary section"
    assert_contains "$content" "### Completed Work" "Should have completed work"
    assert_contains "$content" "### Problems Solved" "Should have problems solved"
    assert_contains "$content" "### Key Decisions" "Should have key decisions"
    assert_contains "$content" "### Current State" "Should have current state"
    assert_contains "$content" "### Pending Tasks" "Should have pending tasks"
    assert_contains "$content" "### Important Files" "Should have important files"
    assert_contains "$content" "### Recommendations for Next Session" "Should have recommendations"
    
    teardown_test_env
}

test_save_handles_special_characters() {
    setup_test_env
    
    local note="Test with emoji 🎯 and unicode 中文"
    local journal_file=$(save_journal "$note")
    
    assert_file_exists "$journal_file" "Journal should be created"
    
    local content=$(cat "$journal_file")
    assert_contains "$content" "🎯" "Should preserve emoji"
    
    teardown_test_env
}

test_save_uses_global_path() {
    setup_test_env
    
    local journal_file=$(save_journal "Test global path")
    
    assert_contains "$journal_file" "$TEST_JOURNAL_DIR" "Should use test journal directory"
    
    teardown_test_env
}

echo "Running Save Command Tests..."
echo "================================"

run_test "Save creates journal" test_save_creates_journal
run_test "Save from different directory" test_save_from_different_directory
run_test "Save with note" test_save_with_note
run_test "Save creates directory structure" test_save_creates_directory_structure
run_test "Save multiple same day" test_save_multiple_same_day
run_test "Save validates content structure" test_save_validates_content_structure
run_test "Save handles special characters" test_save_handles_special_characters
run_test "Save uses global path" test_save_uses_global_path

print_summary
