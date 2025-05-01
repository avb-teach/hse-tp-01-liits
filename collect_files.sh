#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 /path/to/input_dir /path/to/output_dir"
  exit 1

INPUT_DIR="$1"
OUTPUT_DIR="$2"

if [ ! -d "$INPUT_DIR" ]; then
  echo "Input directory does not exist: $INPUT_DIR"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

TMPFILE=$(mktemp)

python3 - <<END
import os
import shutil
from collections import defaultdict

input_dir = os.path.abspath("$INPUT_DIR")
output_dir = os.path.abspath("$OUTPUT_DIR")

with open("$TMPFILE", "r") as f:
    files = [line.strip() for line in f if line.strip()]

name_count = defaultdict(int)

for filepath in files:
    filename = os.path.basename(filepath)
    name_count[filename] += 1
    if name_count[filename] == 1:
        out_name = filename
    else:
        name, ext = os.path.splitext(filename)
        out_name = f"{name}{name_count[filename]}{ext}"
    out_path = os.path.join(output_dir, out_name)
    shutil.copy2(filepath, out_path)
END

rm "$TMPFILE"
