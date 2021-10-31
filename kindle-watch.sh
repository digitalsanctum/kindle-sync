#!/bin/bash

set -e

usage() {
    echo >&2 "$@"    
    exit 1
}

[ "$#" -eq 1 ] || usage "usage: ./kindle-watch.sh [DIRECTORY_TO_WATCH]"

WATCH_DIR="$1"

inotifywait -m ${WATCH_DIR} -e create -e moved_to |
    while read dir action file; do
        echo "The file '$file' appeared in directory '$dir' via '$action'"
        if [[ "$file" == *.pdf ]]; then
            echo "Sending $file to Kindle..."
            ./sync.sh "$file"
        fi
    done
