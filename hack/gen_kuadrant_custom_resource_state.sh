#!/bin/bash

# Paths to the input files and the output file
file1="./config/default/custom-resource-state.yaml"
file2="./config/kuadrant/custom-resource-state-kuadrant.yaml"
output_file="./config/kuadrant/custom-resource-state.yaml"

# Ensure the directory for the output file exists
mkdir -p "$(dirname "$output_file")"

# Append the contents of file1 and file2, and write to output_file
cat "$file1" "$file2" > "$output_file"

echo "Contents of $file1 and $file2 have been combined into $output_file"
