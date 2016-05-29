#!/bin/sh

FILE="$1"
cd "$(dirname "$FILE")"
FILE="$(basename "$FILE")"

while [ -s "$FILE" ]; do
    new_file="$(head -n 1 "$FILE" | awk  '{print $NF}' | sed 's/^.\(.*\)/.\1/')"
    echo "$new_file"
    sed -i '1,2d' "$FILE"
    mkdir -p "$(dirname "$new_file")"
    sed '/^diff/q' "$FILE" > "$new_file"
    sed -i '1,/^diff/{/^diff/b;/^/d}' "$FILE"
done
