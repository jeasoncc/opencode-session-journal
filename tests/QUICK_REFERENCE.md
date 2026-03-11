# Testing Quick Reference

## Running Tests

```bash
# All tests
./tests/run_tests.sh

# With coverage
./tests/run_tests.sh --coverage

# Verbose output
./tests/run_tests.sh --verbose

# Specific suite
./tests/test_path_generation.sh
./tests/test_file_operations.sh
./tests/test_save_command.sh
./tests/test_load_command.sh
./tests/test_e2e_workflows.sh
```

## Writing Tests

### Basic Test Structure

```bash
#!/bin/bash

source "$(dirname "$0")/test_framework.sh"

test_my_feature() {
    setup_test_env
    
    # Your test code here
    local result=$(my_function "input")
    
    assert_equals "expected" "$result" "Description"
    
    teardown_test_env
}

run_test "My feature test" test_my_feature

print_summary
```

### Available Assertions

```bash
assert_equals "expected" "actual" "message"
assert_contains "haystack" "needle" "message"
assert_file_exists "/path/to/file" "message"
assert_dir_exists "/path/to/dir" "message"
assert_not_empty "$variable" "message"
assert_exit_code 0 $? "message"
```

### Test Isolation

```bash
# Setup creates temporary directory
setup_test_env
# Use $TEST_DIR and $TEST_JOURNAL_DIR

# Teardown cleans up
teardown_test_env
```

## Test Categories

- **Unit Tests**: Individual functions (path generation, zodiac calculation)
- **Integration Tests**: Command behavior (save, load)
- **E2E Tests**: Real workflows (save → load → continue)

## Coverage Goals

- Target: 80%+
- Current: 95%+
- All new features must include tests

## Before Committing

```bash
# Run tests
./tests/run_tests.sh

# Check coverage
./tests/run_tests.sh --coverage

# All tests must pass
```

## Test Files

- `test_framework.sh` - Core testing framework
- `test_path_generation.sh` - Path and zodiac tests
- `test_file_operations.sh` - File I/O tests
- `test_save_command.sh` - Save command tests
- `test_load_command.sh` - Load command tests
- `test_e2e_workflows.sh` - End-to-end tests
- `run_tests.sh` - Master test runner

## Documentation

- `TEST_SPECIFICATION.md` - Test plan and coverage goals
- `TEST_REPORT.md` - Execution results and findings
- `RECOMMENDATIONS.md` - Improvement suggestions
