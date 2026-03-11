#!/bin/bash

source "$(dirname "$0")/test_framework.sh"

test_zodiac_calculation_2026() {
    local year=2026
    local zodiac_index=$(( ($year - 1900) % 12 ))
    local zodiacs=("Rat" "Ox" "Tiger" "Rabbit" "Dragon" "Snake" "Horse" "Goat" "Monkey" "Rooster" "Dog" "Pig")
    local zodiac=${zodiacs[$zodiac_index]}
    
    assert_equals "Horse" "$zodiac" "2026 should be Horse (126 % 12 = 6)"
}

test_zodiac_calculation_1900() {
    local year=1900
    local zodiac_index=$(( ($year - 1900) % 12 ))
    local zodiacs=("Rat" "Ox" "Tiger" "Rabbit" "Dragon" "Snake" "Horse" "Goat" "Monkey" "Rooster" "Dog" "Pig")
    local zodiac=${zodiacs[$zodiac_index]}
    
    assert_equals "Rat" "$zodiac" "1900 should be Rat"
}

test_zodiac_calculation_2027() {
    local year=2027
    local zodiac_index=$(( ($year - 1900) % 12 ))
    local zodiacs=("Rat" "Ox" "Tiger" "Rabbit" "Dragon" "Snake" "Horse" "Goat" "Monkey" "Rooster" "Dog" "Pig")
    local zodiac=${zodiacs[$zodiac_index]}
    
    assert_equals "Goat" "$zodiac" "2027 should be Goat (127 % 12 = 7)"
}

test_zodiac_calculation_2024() {
    local year=2024
    local zodiac_index=$(( ($year - 1900) % 12 ))
    local zodiacs=("Rat" "Ox" "Tiger" "Rabbit" "Dragon" "Snake" "Horse" "Goat" "Monkey" "Rooster" "Dog" "Pig")
    local zodiac=${zodiacs[$zodiac_index]}
    
    assert_equals "Dragon" "$zodiac" "2024 should be Dragon"
}

test_month_name_march() {
    local month_num="03"
    local month_name=$(date -d "2026-${month_num}-01" +%B)
    
    assert_equals "March" "$month_name" "Month 03 should be March"
}

test_month_name_december() {
    local month_num="12"
    local month_name=$(date -d "2026-${month_num}-01" +%B)
    
    assert_equals "December" "$month_name" "Month 12 should be December"
}

test_weekday_name_wednesday() {
    local weekday=$(date -d "2026-03-11" +%A)
    
    assert_equals "Wednesday" "$weekday" "2026-03-11 should be Wednesday"
}

test_directory_path_format() {
    local year=2026
    local month="03"
    local month_name="March"
    local day="11"
    local weekday="Wednesday"
    local zodiac="Snake"
    
    local expected_path="year-${year}-${zodiac}/month-${month}-${month_name}/day-${day}-${weekday}"
    local actual_path="year-${year}-${zodiac}/month-${month}-${month_name}/day-${day}-${weekday}"
    
    assert_equals "$expected_path" "$actual_path" "Directory path format should match org-roam structure"
}

test_filename_format() {
    local timestamp="1773164617"
    local time="01:43:37"
    local expected_filename="journal-${timestamp}-${time}.md"
    local actual_filename="journal-${timestamp}-${time}.md"
    
    assert_equals "$expected_filename" "$actual_filename" "Filename format should be journal-{timestamp}-{HH:MM:SS}.md"
}

test_full_path_generation() {
    local year=2026
    local month="03"
    local month_name="March"
    local day="11"
    local weekday="Wednesday"
    local zodiac="Horse"
    local timestamp="1773164617"
    local time="01:43:37"
    
    local journal_base="$HOME/.opencode/session-journals"
    local dir="$journal_base/year-${year}-${zodiac}/month-${month}-${month_name}/day-${day}-${weekday}"
    local file="journal-${timestamp}-${time}.md"
    local full_path="$dir/$file"
    
    assert_contains "$full_path" ".opencode/session-journals" "Path should contain .opencode/session-journals"
    assert_contains "$full_path" "year-2026-Horse" "Path should contain year-2026-Horse"
    assert_contains "$full_path" "month-03-March" "Path should contain month-03-March"
    assert_contains "$full_path" "day-11-Wednesday" "Path should contain day-11-Wednesday"
    assert_contains "$full_path" "journal-1773164617-01:43:37.md" "Path should contain journal filename"
}

echo "Running Path Generation Tests..."
echo "================================"

run_test "Zodiac calculation for 2026" test_zodiac_calculation_2026
run_test "Zodiac calculation for 1900" test_zodiac_calculation_1900
run_test "Zodiac calculation for 2027" test_zodiac_calculation_2027
run_test "Zodiac calculation for 2024" test_zodiac_calculation_2024
run_test "Month name for March" test_month_name_march
run_test "Month name for December" test_month_name_december
run_test "Weekday name for Wednesday" test_weekday_name_wednesday
run_test "Directory path format" test_directory_path_format
run_test "Filename format" test_filename_format
run_test "Full path generation" test_full_path_generation

print_summary
