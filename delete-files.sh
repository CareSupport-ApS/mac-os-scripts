#!/bin/bash

usage() {
    echo "Usage: $0 --path <path_to_start_from> --target <target_name> [--dry]"
    exit 1
}

DRY_RUN=0
TARGET_PATH=""
TARGET_NAME=""

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --path)
        TARGET_PATH="$2"
        shift # past argument
        shift # past value
        ;;
        --target)
        TARGET_NAME="$2"
        shift # past argument
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

if [[ -z "$TARGET_PATH" || -z "$TARGET_NAME" ]]; then
    usage
fi


# Function to search and delete (or dry run)
function delete_target {
    local path="$1"
    local target="$2"
    local is_dry_run="$3"

    # Use find to recursively go through directories
    find "$path" -type d | while read dir; do
        echo "Searching in: $dir"
        find "$dir" -maxdepth 1 -name "$target" | while read line; do
            # If dry run, just print the target
            if [[ "$is_dry_run" -eq 1 ]]; then
                echo "Will delete: $line"
            else
                # Try to remove the target (either file or directory)
                if [[ -d "$line" ]]; then
                    echo "Deleted directory: $line"
                    #rm -rf "$line" && echo "Deleted directory: $line"
                else
                echo "Deleted file: $line"
                    #rm -f "$line" && echo "Deleted file: $line"
                fi
            fi
        done
    done
}

# Call the function
delete_target "$TARGET_PATH" "$TARGET_NAME" "$DRY_RUN"
