#!/bin/bash    

process() {
    local file=$1
    local -a lines=()
    local line

    [[ -f $file ]] || return 1

    while IFS= read -r line; do
        lines+=("$line")
    done < "$file"

    printf '%s\n' "${lines[@]}"
}