#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 /path/to/input_dir /path/to/output_dir"
  exit 1

input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ]; then
  echo "Input directory does not exist: $input_dir"
  exit 1
fi

mkdir -p "$output_dir"

TMPFILE=$(mktemp)

python3 - <<END
import os
import shutil
from collections import defaultdict

input_dir = os.path.abspath("$input_dir")
output_dir = os.path.abspath("$output_dir")

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
