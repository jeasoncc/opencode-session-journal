# Test Specification - OpenCode Session Journal

## Test Strategy

This document defines the comprehensive test suite for opencode-session-journal following TDD methodology.

## Test Environment

- **Language**: Bash (BATS - Bash Automated Testing System)
- **Test Location**: `/home/lotus/Project/Personal/opencode-session-journal/tests/`
- **Global Journal Path**: `$HOME/.opencode/session-journals/`
- **Test Isolation**: Each test uses temporary directories and cleanup

## Test Coverage Goals

- **Target Coverage**: 80%+
- **Unit Tests**: Individual functions (zodiac calculation, path generation, file operations)
- **Integration Tests**: Full command execution (save, load, list)
- **E2E Tests**: Multi-directory scenarios, real-world workflows

## Test Categories

### 1. Unit Tests - Path Generation

**Test File**: `test_path_generation.bats`

| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `test_zodiac_calculation_2026` | Verify 2026 = Snake | Returns "Snake" |
| `test_zodiac_calculation_1900` | Verify 1900 = Rat | Returns "Rat" |
| `test_zodiac_calculation_2027` | Verify 2027 = Horse | Returns "Horse" |
| `test_zodiac_calculation_edge_cases` | Test years 1899, 2100 | Correct zodiac |
| `test_month_name_generation` | Verify month 03 = March | Returns "March" |
| `test_weekday_name_generation` | Verify correct weekday | Returns full name |
| `test_directory_path_format` | Verify org-roam structure | `year-YYYY-Zodiac/month-MM-MonthName/day-DD-Weekday` |
| `test_filename_format` | Verify journal filename | `journal-{timestamp}-{HH:MM:SS}.md` |

### 2. Unit Tests - File Operations

**Test File**: `test_file_operations.bats`

| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `test_create_directory_structure` | Create nested directories | Directories exist |
| `test_write_journal_file` | Write markdown content | File created with content |
| `test_read_journal_file` | Read existing journal | Content matches |
| `test_find_most_recent_journal` | Find latest by timestamp | Returns newest file |
| `test_find_journals_by_date` | Find journals for specific date | Returns matching files |
| `test_list_all_journals` | List all journals sorted | Returns sorted list |

### 3. Integration Tests - Save Command

**Test File**: `test_save_command.bats`

| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `test_save_creates_journal` | Run save command | Journal file created |
| `test_save_from_project_directory` | Save from project root | Uses global path |
| `test_save_from_tmp_directory` | Save from /tmp | Uses global path |
| `test_save_from_home_directory` | Save from $HOME | Uses global path |
| `test_save_with_note` | Save with custom note | Note in journal |
| `test_save_without_note` | Save without note | Default content |
| `test_save_creates_directory_structure` | First save creates dirs | Full path exists |
| `test_save_multiple_same_day` | Multiple saves same day | Multiple files |
| `test_save_validates_content` | Check journal structure | All sections present |
| `test_save_handles_special_characters` | Save with emoji/unicode | Content preserved |

### 4. Integration Tests - Load Command

**Test File**: `test_load_command.bats`

| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `test_load_most_recent` | Load without arguments | Returns latest journal |
| `test_load_from_project_directory` | Load from project root | Finds global journals |
| `test_load_from_tmp_directory` | Load from /tmp | Finds global journals |
| `test_load_from_home_directory` | Load from $HOME | Finds global journals |
| `test_load_specific_date` | Load by date (2026-03-11) | Returns matching journals |
| `test_load_list_all` | Load with "list" argument | Shows all journals |
| `test_load_no_journals_found` | Load when no journals exist | Error message |
| `test_load_corrupted_journal` | Load corrupted file | Error handling |
| `test_load_extracts_summary` | Verify summary extraction | Key sections extracted |

### 5. E2E Tests - Real Workflows

**Test File**: `test_e2e_workflows.bats`

| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `test_workflow_save_and_load` | Save then load | Context restored |
| `test_workflow_multi_directory` | Save in /tmp, load in /home | Works correctly |
| `test_workflow_multiple_sessions` | 3 saves, load most recent | Latest returned |
| `test_workflow_date_boundary` | Save across midnight | Correct directories |
| `test_workflow_month_boundary` | Save across month change | Correct directories |
| `test_workflow_year_boundary` | Save across year change | Correct zodiac |
| `test_workflow_team_handoff` | Save, load, continue, save | Full cycle works |

### 6. Edge Cases

**Test File**: `test_edge_cases.bats`

| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `test_empty_journal_directory` | No journals exist | Graceful error |
| `test_permission_denied` | No write permission | Error message |
| `test_disk_full` | Disk space exhausted | Error handling |
| `test_very_long_note` | 10KB note text | Handles correctly |
| `test_concurrent_saves` | Multiple saves simultaneously | No corruption |
| `test_symlink_directory` | Journal dir is symlink | Works correctly |
| `test_leap_year_feb_29` | Save on Feb 29 | Correct handling |

## Test Data

### Sample Journal Content

```markdown
# Session Journal - ses_test123

**Start Time**: 2026-03-11 01:43:37
**Task**: Test session

---

## 2026-03-11 01:45:00
### 🎯 Started Task: Test task
- **User Request**: Test request
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
Test recommendations
```

## Test Execution

### Run All Tests
```bash
cd /home/lotus/Project/Personal/opencode-session-journal
./tests/run_tests.sh
```

### Run Specific Test Suite
```bash
bats tests/test_path_generation.bats
bats tests/test_save_command.bats
bats tests/test_load_command.bats
```

### Run with Coverage
```bash
./tests/run_tests.sh --coverage
```

## Success Criteria

- [ ] All tests pass
- [ ] 80%+ code coverage
- [ ] No false positives
- [ ] Tests run in < 30 seconds
- [ ] Tests are independent (no shared state)
- [ ] Tests clean up after themselves
- [ ] Clear error messages on failure

## Test Maintenance

- Run tests before every commit
- Update tests when adding features
- Keep test data minimal
- Document complex test scenarios
- Review coverage reports weekly
