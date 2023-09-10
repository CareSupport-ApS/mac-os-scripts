#!/bin/bash

dry_run=0

# Check for --dry argument
if [ "$1" == "--dry" ]; then
    dry_run=1
    shift  # Remove --dry from the arguments
fi



# Function to rename files and directories to remove leading and trailing whitespaces
rename_files() {
    local dir="$1"

    # Iterate over all files and directories within the current directory
    for f in "$dir"/*; do
        # Skip if file/directory doesn't exist (for instance, when the directory is empty)
        [ -e "$f" ] || continue

        # Extract just the name of the file/directory from the full path
        filename=$(basename -- "$f")

        # Remove leading and trailing whitespaces
        new_filename=$(echo "$filename" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

        # If the name has changed, print or rename the file/directory
        if [ "$filename" != "$new_filename" ]; then
            if [ $dry_run -eq 1 ]; then
                echo "Would rename: '$f' to '$(dirname -- "$f")/$new_filename'"
            else
                mv -- "$f" "$(dirname -- "$f")/$new_filename"
                echo "Did rename: '$f' to '$(dirname -- "$f")/$new_filename'"
            fi
        fi

        # If it's a directory, recurse into it
        if [ -d "$f" ]; then
            rename_files "$f"
        fi
    done
}

# Check for user input
if [ -z "$1" ]; then
    echo "Usage: $0 [--dry] path"
    exit 1
fi

# Call the function
rename_files "$1"
