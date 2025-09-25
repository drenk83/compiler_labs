#!/bin/bash

# 1. Comments — everything after # is ignored

# 2. Variables
name="Alice"
age=30
readonly PI=3
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

# 5. Case statement
read -p "Enter command (start|stop|restart): " action

case $action in
    start)
        echo "Starting service..."
        ;;
    stop)
        echo "Stopping service..."
        ;;
    restart)
        echo "Restarting service..."
        ;;
    *)
        echo "Unknown command. Use: start, stop, or restart."
        ;;
esac

# 6. Loops

# For loop over a range
echo "Counting to 3:"
for i in {1..3}; do
    echo "  $i"
done

# While loop
counter=0
while [ $counter -lt 2 ]; do
    echo "  while: iteration $((counter + 1))"
    ((counter++))
done

# 7. Arrays
fruits=("apple" "banana" "orange")
echo "Fruits: ${fruits[0]}, ${fruits[1]}, ${fruits[2]}"
echo "Total fruits: ${#fruits[@]}"

# Print all array elements
echo "All fruits: ${fruits[*]}"

# 8. Functions
greet() {
    local user="$1"  # local variable
    echo "Hello from function, $user!"
}
greet "$your_name"

# 9. Arithmetic
result=$(( 10 + 5 * 2 ))
echo "10 + 5 * 2 = $result"

# 10. Check if file exists
if [ -f "./demo.sh" ]; then
    echo "File demo.sh exists."
else
    echo "File demo.sh not found (possibly run from a different directory)."
fi

# 11. Check if directory exists
if [ -d "/tmp" ]; then
    echo "Directory /tmp exists."
fi

# 12. Exit with status
echo "Script completed successfully."
exit 0

# Additional basic commands section

# 1. List directory contents in long format
ls -l

# 2. Print working directory
pwd

# 4. Create a new directory
mkdir -p test_dir

# 5. Create an empty file
touch file.txt

# 6. Copy a file
cp file.txt file_copy.txt

# 7. Rename a file
mv file_copy.txt new_name.txt

# 8. Remove original file
rm file.txt

# 9. Display system information
cat /etc/os-release

# 10. Print a message
echo "Hello, World!"

# Optional: clean up created files and directory
# rm -rf test_dir new_name.txt