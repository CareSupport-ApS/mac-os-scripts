#!/bin/bash

usage() {
    echo "Usage: $0 --path <path_to_start_from> [--dry]"
    exit 1
}

TARGET_PATH=""
DRY_RUN=0

# Check for --dry argument
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --path)
        TARGET_PATH="$2"
        shift # past $target
        shift # past value
        ;;
        --dry)
        DRY_RUN=1
        shift # past argument
        ;;
        *)
        usage
        ;;
    esac
done


if [[ -z "$TARGET_PATH" ]]; then
    usage
fi

if [[ -d "$TARGET_PATH" ]]; then
    echo "Directory exists, proceeding..."
else
    echo "Directory does not exist or is not readable: $TARGET_PATH"
    exit 1
fi


# Function to rename files and directories to remove leading and trailing whitespaces
function rename_files {
    local path="$1"

    # First, process all the files and directories within the current directory
    for f in "$path"/*; do
        # Skip if file/directory doesn't exist (for instance, when the directory is empty)
        [ -e "$f" ] || continue

        # If it's a directory, recurse into it first to handle its contents
        if [ -d "$f" ]; then
            rename_files "$f"
        fi
    done


    # Iterate over all files and directories within the current directory
    for f in "$path"/*; do
        # Skip if file/directory doesn't exist (for instance, when the directory is empty)
        [ -e "$f" ] || continue

        # Extract just the name of the file/directory from the full path
        filename=$(basename -- "$f")

        # Remove leading and trailing whitespaces
        new_filename=$(echo "$filename" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

        # If the name has changed, print or rename the file/directory
        if [ "$filename" != "$new_filename" ]; then
            if [ $DRY_RUN -eq 1 ]; then
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


# Call the function
echo "Running with parameters: $TARGET_PATH, DRY: $DRY_RUN"
rename_files "$TARGET_PATH"
