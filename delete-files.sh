#!/bin/bash

usage() {
    echo "Usage: $0 --path <path_to_start_from> --target <target_name> [--dry] [--recycle-bin-path <path_to_recycle_bin>]"
    exit 1
}

DRY_RUN=0
TARGET_PATH=""
TARGET_NAME=""
RECYCLE_BIN_PATH=""

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
        --recycle-bin-path)
        RECYCLE_BIN_PATH="$2"
        shift # past argument
        shift # past value
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
    local recycle_bin="$4"

    IFS=',' read -ra TARGET_ARRAY <<< "$targets"

    find "$path" | while read -r line; do
         # Check if the line still exists
        if [[ ! -e "$line" ]]; then
            continue
        fi


        for target in "${TARGET_ARRAY[@]}"; do
            if echo "$line" | grep -q "$target"; then
                # Get the modification time in epoch seconds
                if [[ "$(uname)" == "Darwin" ]]; then
                    # macOS stat command
                    mod_time=$(stat -f %m "$line")
                else
                    # Assume GNU/Linux stat command
                    mod_time=$(stat -c %Y "$line")
                fi

                # Get the current time in epoch seconds
                current_time=$(date +%s)

                # Check if the item was modified less than 2 minutes ago
                if [[ $((current_time - mod_time)) -le 120 ]]; then
                    echo "$line was modified less than 2 minutes ago, skipping."
                    continue
                fi

                if [[ $is_dry_run -eq 1 ]]; then
                    echo "Will delete: $line"
                else
                        local recycle_path="${recycle_bin}${line#$path}"

                        # Check if the line is a directory; if so, adjust the path
                        if [[ -d "$line" ]]; then
                            recycle_path="${recycle_bin}${line#$path}"
                        fi
                        
                        # Create the directory only if it does not exist
                        local recycle_dir="$(dirname "$recycle_path")"
                        if [[ ! -d "$recycle_dir" ]]; then
                            mkdir -p "$recycle_dir"
                        fi
echo "Moving to recycle bin: $recycle_path"
mv "$line" "$recycle_path"
                fi
            fi
        done
    done
}

# Call the function
delete_target "$TARGET_PATH" "$TARGET_NAME" "$DRY_RUN" "$RECYCLE_BIN_PATH"
