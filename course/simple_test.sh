#!/bin/bash

# 1. Comments — everything after # is ignored

# 2. Variables
name="Alice"
age=30
readonly PI=3.1415  # constant (read-only)
your_name="$USER"  # use current user if not specified otherwise

# 3. Output to screen
echo "Hello, $name! You are $age years old."
echo "Pi is approximately $PI"

# 4. Conditional statements (if-else)
if [ "$age" -ge 18 ]; then
    echo "$name is an adult."
elif [ "$age" -gt 0 ]; then
    echo "$name is a minor."
else
    echo "Invalid age."
fi