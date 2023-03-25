#!/bin/bash

logger -s -p user.notice "Starting delete-files script"

#Get Params for script and set defaults
path="" # defaults to run in current directory
pathToNotice=/tmp #Default to put notice in /tmp

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    -p | --path)
        path="$2"
        shift # past argument
        shift # past value
        ;;
    -n | --pathtonotice)
        pathToNotice="$2"
        shift # past argument
        shift # past value
        ;;
    *) # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift              # past argument
        ;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ -d "$path" ]]; then
    logger -s -p user.notice "Delete-files: Will use path = $path"
else
    logger -s -p user.error "Delete-files: Please call this script with the following params: --path or -p"
    exit
fi

find "$path" -type f -name '~$*' | while read thing; do
   logger "Removing $thing";
   rm "$thing";
done