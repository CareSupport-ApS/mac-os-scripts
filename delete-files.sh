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
        shift # past $target
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

if [[ -d "$TARGET_PATH" ]]; then
    echo "Directory exists, proceeding..."
else
    echo "Directory does not exist or is not readable: $TARGET_PATH"
    exit 1
fi


# Function to search and delete (or dry run)

function delete_target {
    local path="$1"
    local targets="$2"
    local is_dry_run="$3"

    IFS=',' read -ra TARGET_ARRAY <<< "$targets"

    find "$path" | while read -r line; do
        for target in "${TARGET_ARRAY[@]}"; do
            if echo "$line" | grep -q "$target"; then
                if [[ $is_dry_run -eq 1 ]]; then
                    echo "Will delete: $line"
                else
                    if [[ -d "$line" ]]; then
                        echo "Attempting to delete directory: $line"
                        rmdir "$line" 2>/dev/null || echo "Skipping non-empty directory: $line"
                    elif [[ -f "$line" ]]; then
                        echo "Deleting file: $line"
                        rm -f "$line"
                    fi
                fi
            fi
        done
    done
}


# }

# Call the function
delete_target "$TARGET_PATH" "$TARGET_NAME" "$DRY_RUN"
