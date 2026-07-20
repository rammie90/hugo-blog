#!/bin/bash

set -e

DEFAULT_DIR="$HOME/hugo/rammie-blog/static/images"

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <target_file> [target_dir]"
    exit 1
fi

FILE="$1"
TARGET_DIR="${2:-$DEFAULT_DIR}"

if [ ! -f "$FILE" ]; then
    echo "Error: '$FILE' is not a file"
    exit 1
fi

YYYY=$(date +%Y)
MM=$(date +%m)
DEST="$TARGET_DIR/$YYYY/$MM"

mkdir -p "$DEST"
mv "$FILE" "$DEST/"
echo "Moved '$FILE' -> '$DEST/'"
