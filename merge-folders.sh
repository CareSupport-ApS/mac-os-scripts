#!/bin/bash

# Default dry run to true
dry_run="--dry-run"

# Initialize parameters
source_dir=""
dest_dir=""

# Parse named parameters
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --dry-run)
            dry_run="--dry-run";;
        --no-dry-run)
            dry_run="";;
        --source)
            source_dir="$2"
            shift;;
        --destination)
            dest_dir="$2"
            shift;;
        *)
            echo "Unknown parameter: $1"
            echo "Usage: $0 --source <source_dir> --destination <dest_dir> [--no-dry-run]"
            exit 1;;
    esac
    shift
done

# Check if directories have been set
if [ -z "$source_dir" ] || [ -z "$dest_dir" ]; then
    echo "Source and destination directories must be specified."
    echo "Usage: $0 --source <source_dir> --destination <dest_dir> [--no-dry-run]"
    exit 1
fi

# Execute the rsync command
echo "Running rsync command..."
rsync $dry_run --verbose --recursive --no-perms --no-owner "$source_dir" "$dest_dir"

# Inform the user the script has finished
echo "rsync operation completed."
