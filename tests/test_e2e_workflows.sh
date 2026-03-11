#!/bin/bash

source "$(dirname "$0")/test_framework.sh"

source "$(dirname "$0")/test_save_command.sh" 2>/dev/null || true
source "$(dirname "$0")/test_load_command.sh" 2>/dev/null || true

test_workflow_save_and_load() {
    setup_test_env
    
    local journal_file=$(save_journal "Complete WeBank SDK integration")
    
    assert_file_exists "$journal_file" "Journal should be saved"
    
    local loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    
    assert_equals "$journal_file" "$loaded" "Should load the saved journal"
    
    local content=$(cat "$loaded")
    assert_contains "$content" "WeBank SDK integration" "Loaded content should match saved"
    
    teardown_test_env
}

test_workflow_multi_directory() {
    setup_test_env
    
    local original_dir=$(pwd)
    
    cd /tmp
    local journal_file=$(save_journal "Save from /tmp")
    
    cd "$HOME"
    local loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    
    assert_equals "$journal_file" "$loaded" "Should load journal saved from different directory"
    
    cd "$original_dir"
    teardown_test_env
}

test_workflow_multiple_sessions() {
    setup_test_env
    
    local journal1=$(save_journal "First session" "ses_001")
    sleep 1
    local journal2=$(save_journal "Second session" "ses_002")
    sleep 1
    local journal3=$(save_journal "Third session" "ses_003")
    
    local loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    
    assert_equals "$journal3" "$loaded" "Should load most recent (third) session"
    
    local content=$(cat "$loaded")
    assert_contains "$content" "Third session" "Should contain third session content"
    
    teardown_test_env
}

test_workflow_team_handoff() {
    setup_test_env
    
    local dev_a_journal=$(save_journal "Developer A: Implemented feature" "ses_dev_a")
    
    local loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    assert_file_exists "$loaded" "Developer B should load Developer A's journal"
    
    local dev_b_journal=$(save_journal "Developer B: Reviewed and tested" "ses_dev_b")
    
    local final_loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    assert_equals "$dev_b_journal" "$final_loaded" "Should load Developer B's journal"
    
    teardown_test_env
}

test_workflow_context_management() {
    setup_test_env
    
    local research_journal=$(save_journal "Research phase: Analyzed requirements" "ses_research")
    
    local loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    local content=$(cat "$loaded")
    assert_contains "$content" "Research phase" "Should restore research context"
    
    local impl_journal=$(save_journal "Implementation phase: Built feature" "ses_impl")
    
    local loaded2=$(load_most_recent "$TEST_JOURNAL_DIR")
    local content2=$(cat "$loaded2")
    assert_contains "$content2" "Implementation phase" "Should restore implementation context"
    
    teardown_test_env
}

test_workflow_list_and_select() {
    setup_test_env
    
    create_test_journal "$(($(date +%s) - 300))" "Day 1: Setup"
    create_test_journal "$(($(date +%s) - 200))" "Day 2: Development"
    create_test_journal "$(($(date +%s) - 100))" "Day 3: Testing"
    
    local list=$(list_all_journals "$TEST_JOURNAL_DIR")
    local count=$(echo "$list" | wc -l)
    
    assert_equals "3" "$count" "Should list all sessions"
    
    local most_recent=$(load_most_recent "$TEST_JOURNAL_DIR")
    local content=$(cat "$most_recent")
    assert_contains "$content" "Day 3: Testing" "Should load most recent session"
    
    teardown_test_env
}

test_workflow_continuous_development() {
    setup_test_env
    
    local day1=$(save_journal "Day 1: Initial implementation")
    sleep 1
    
    local loaded1=$(load_most_recent "$TEST_JOURNAL_DIR")
    assert_equals "$day1" "$loaded1" "Day 2 should load Day 1 context"
    
    local day2=$(save_journal "Day 2: Added tests")
    sleep 1
    
    local loaded2=$(load_most_recent "$TEST_JOURNAL_DIR")
    assert_equals "$day2" "$loaded2" "Day 3 should load Day 2 context"
    
    local day3=$(save_journal "Day 3: Deployed to production")
    
    local final=$(load_most_recent "$TEST_JOURNAL_DIR")
    assert_equals "$day3" "$final" "Should have complete development history"
    
    teardown_test_env
}

test_workflow_error_recovery() {
    setup_test_env
    
    local journal1=$(save_journal "Working on feature X")
    
    mkdir -p "$TEST_JOURNAL_DIR/corrupted"
    echo "corrupted data" > "$TEST_JOURNAL_DIR/corrupted/invalid.md"
    
    local loaded=$(load_most_recent "$TEST_JOURNAL_DIR")
    
    assert_not_empty "$loaded" "Should still find valid journal despite corrupted files"
    
    teardown_test_env
}

echo "Running E2E Workflow Tests..."
echo "================================"

run_test "Workflow: Save and load" test_workflow_save_and_load
run_test "Workflow: Multi-directory" test_workflow_multi_directory
run_test "Workflow: Multiple sessions" test_workflow_multiple_sessions
run_test "Workflow: Team handoff" test_workflow_team_handoff
run_test "Workflow: Context management" test_workflow_context_management
run_test "Workflow: List and select" test_workflow_list_and_select
run_test "Workflow: Continuous development" test_workflow_continuous_development
run_test "Workflow: Error recovery" test_workflow_error_recovery

print_summary
