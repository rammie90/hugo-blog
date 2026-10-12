#!/bin/bash
set -e

DEFAULT_DIR="$HOME/hugo/rammie-blog/static/images"
TARGET_DIR="$DEFAULT_DIR"

usage() {
    echo "Usage: $0 [-d target_dir] <file1> [file2 ...]"
    exit 1
}

while getopts "d:" opt; do
    case "$opt" in
        d) TARGET_DIR="$OPTARG" ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

if [ "$#" -lt 1 ]; then
    usage
fi

YYYY=$(date +%Y)
MM=$(date +%m)
DEST="$TARGET_DIR/$YYYY/$MM"
mkdir -p "$DEST"

for FILE in "$@"; do
    if [ ! -f "$FILE" ]; then
        echo "Warning: '$FILE' is not a file, skipping" >&2
        continue
    fi
    mv "$FILE" "$DEST/"
    echo "Moved '$FILE' -> '$DEST/'"
done
