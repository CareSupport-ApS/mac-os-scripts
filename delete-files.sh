#!/bin/bash

DRY_RUN=0
TARGET_PATH=""
TARGET_FILES=".smbdelete*,_gsdata_,.docx.sb-*,.doc.sb-*,.xlsx.sb-*,.AppleDouble,.pdf.sb-*,.key.sb-*,.jpg.sb-*,.jpeg.sb-*,~$*"
RECYCLE_BIN_PATH=""

usage() {
    echo "Usage: $0 --path <path_to_start_from> --target <target_files> [--dry] [--recycle-bin-path <path_to_recycle_bin>]"
    echo "If no --target is specified, default target will be used: $TARGET_FILES"
    exit 1
}

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --path)
        TARGET_PATH="$2"
        shift # past $target
        shift # past value
        ;;
        --target)
        TARGET_FILES="$2"
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

if [[ -z "$TARGET_PATH" ]]; then
    usage
fi

if [[ -d "$TARGET_PATH" ]]; then
    echo "Directory exists, proceeding..."
else
    echo "Directory does not exist or is not readable: $TARGET_PATH"
    exit 1
fi

# Function to check if file is in use
is_file_in_use() {
    local file="$1"

     # Check if it's a directory
    if [[ -d "$file" ]]; then
        # A directory cannot be in use in the same way as a file
        return 1
    fi

    # Try to open the file for reading and writing
    exec 3>"$file" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        # File is not in use
        exec 3>&-
        return 1
    else
        # File is in use
        return 0
    fi
}

function get_mod_time {
    local file="$1"
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS stat command
        stat -f %m "$file"
    else
        # Assume GNU/Linux stat command
        stat -c %Y "$file"
    fi
}

function delete_target {
    local path="$1"
    local targets="$2"
    local is_dry_run="$3"
    local recycle_bin="$4"

    IFS=',' read -ra TARGET_ARRAY <<< "$targets"

    find "$path" | while read -r line; do
              # Skip directories starting with @eaDir
    if [[ "$line" =~ /@eaDir/ ]]; then
        continue
    fi


      # Check if the line still exists (skip if deleted)
        if [[ ! -e "$line" ]]; then
            continue
        fi

   

    # Get the modification time in epoch seconds using the reusable function
     mod_time=$(get_mod_time "$line")

    # Get the current time in epoch seconds
     current_time=$(date +%s)

      # Check if the file is a temp Office file (starts with /~$)
        if [[ "$line" =~ /~\$ ]]; then
            # If it's a temp file, check if it's over 1 day old (86400 seconds)
            if [[ $((current_time - mod_time)) -le 86400 ]]; then
                echo "$line is a temp Office file, and was modified less than 1 day ago, skipping."
                continue
            else
                # Temp file is older than 1 day, so delete it
                delete_file "$line" "$path" "$recycle_bin" "$is_dry_run"
                continue
            fi
        fi

        for target in "${TARGET_ARRAY[@]}"; do
            if echo "$line" | grep -q "$target"; then
                
                # Check if the item was modified less than 2 minutes ago (for general files)
                if [[ $((current_time - mod_time)) -le 120 ]]; then
                    echo "$line was modified less than 2 minutes ago, skipping."
                    continue
                fi

                # Check if the file is in use
                if is_file_in_use "$line"; then
                    echo "$line is currently in use, skipping."
                    continue
                fi

                 # Delete the file if it matches
                delete_file "$line" "$path" "$recycle_bin" "$is_dry_run"
            fi
        done
    done
}

function delete_file {
    local line="$1"
    local path="$2"
    local recycle_bin="$3"
    local is_dry_run="$4"

    # Create the recycle path (adjust the path to include the recycle bin directory)
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

    # Perform the move or dry-run
    if [[ $is_dry_run -eq 1 ]]; then
        echo "Would delete delete: $line"
    else
        echo "Moving to recycle bin: $recycle_path"
        mv "$line" "$recycle_path"
    fi
}

# Call the function
delete_target "$TARGET_PATH" "$TARGET_FILES" "$DRY_RUN" "$RECYCLE_BIN_PATH"
