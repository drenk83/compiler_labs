#!/bin/bash
TEST_DIR="./tests"
TEST_FILES=$(ls $TEST_DIR/lex_*.test 2>/dev/null)
if [ "$#" -gt 0 ]; then
    TEST_FILES="$TEST_DIR/$1"
fi
for test_file in $TEST_FILES; do
    echo "Test: $test_file"
    ./poly < "$test_file" || true
    echo " "
done