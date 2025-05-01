#!/bin/bash
input_dir="$1"
output_dir="$2"
mkdir -p "$output_dir

python3 - <<SOS
import os
import shutil

input_dir = "${input_dir}"
output_dir = "${output_dir}"

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

name_count = {}
for root, dirs, files in os.walk(input_dir):
    for file in files:
        src_path = os.path.join(root, file)
        base, ext = os.path.splitext(file)
        out_name = file
        if out_name in name_count:
            name_count[out_name] += 1
            out_name = f"{base}{name_count[file]}{ext}"
        else:
            name_count[out_name] = 1
        dst_path = os.path.join(output_dir, out_name)
        while os.path.exists(dst_path):
            name_count[file] += 1
            out_name = f"{base}{name_count[file]}{ext}"
            dst_path = os.path.join(output_dir, out_name)
        shutil.copy2(src_path, dst_path)
SOS
