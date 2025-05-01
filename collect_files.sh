#!/bin/bash
INPUT_DIR="$1"
OUTPUT_DIR="$2"

mkdir -p "$OUTPUT_DIR"

TMPFILE=$(mktemp)

python3 - <<SOS
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
SOS

rm "$TMPFILE"
