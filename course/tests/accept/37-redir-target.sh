#!/bin/bash
echo hi > "$file"
echo hi >> "$dir/$name"
cat < "$file"
ls 2> "$err"
echo hi > $name
cat < $(echo /tmp/f)
{ echo hi; } > "$file"
