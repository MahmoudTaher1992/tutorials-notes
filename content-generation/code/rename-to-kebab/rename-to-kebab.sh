#!/bin/bash

# Usage: ./rename-to-kebab.sh /path/to/directory

target_dir="${1:-.}"

# Traverse directories bottom-up (-depth ensures files before dirs)
find "$target_dir" -depth | while read -r path; do
    dir=$(dirname "$path")
    base=$(basename "$path")

    # Convert to kebab-case:
    # 1. Lowercase
    # 2. Replace spaces/underscores with dashes
    # 3. Collapse multiple dashes
    newbase=$(echo "$base" | tr '[:upper:]' '[:lower:]' | sed -E 's/[ _]+/-/g; s/-+/-/g')

    # Only rename if different
    if [[ "$base" != "$newbase" ]]; then
        newpath="$dir/$newbase"
        echo "Renaming: $path -> $newpath"
        mv -n "$path" "$newpath"
    fi
done
