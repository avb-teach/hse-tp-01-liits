#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/input_dir /path/to/output_dir"
    exit 1
fi

input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ]; then
    echo "Input directory does not exist: $input_dir"
    exit 1
fi

mkdir -p "$output_dir"

python3 - <<SOS
import os
import shutil
from collections import defaultdict

input_dir = "$input_dir"
output_dir = "$output_dir"
name_count = defaultdict(int)

for root, _, files in os.walk(input_dir):
    for file in files:
        src = os.path.join(root, file)
        name_count[file] += 1
        
        if name_count[file] == 1:
            dst_name = file
        else:
            name, ext = os.path.splitext(file)
            dst_name = f"{name}{name_count[file]}{ext}"
            
        dst = os.path.join(output_dir, dst_name)
        shutil.copy2(src, dst)
SOS
