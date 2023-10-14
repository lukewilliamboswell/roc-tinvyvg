#!/bin/bash

# Check if 'roc' is available in the PATH
if ! command -v roc &> /dev/null; then
    echo "'roc' is not available. Please install it to proceed."
    exit 1
fi

# Check if 'tvg-text' is available in the PATH
tvg_text_available=true
if ! command -v tvg-text &> /dev/null; then
    echo "'tvg-text' is not available. .tvgt files will be generated, but not .svg files. Please install 'tvg-text' if you want to generate .svg files."
    tvg_text_available=false
fi

# Clear all .tvgt and .svg files from the examples directory
rm examples/*.tvgt 2>/dev/null
rm examples/*.svg 2>/dev/null

# Loop through all .roc files in the examples directory
for roc_file in examples/*.roc; do
    # Get the base name without the extension
    base_name=$(basename "$roc_file" .roc)
    
    # Generate the output names for .tvgt and .svg files
    tvgt_file="examples/$base_name.tvgt"
    svg_file="examples/$base_name.svg"

    # Process each .roc file and generate corresponding .tvgt
    roc run "$roc_file" > "$tvgt_file"

    # If tvg-text is available, generate the .svg file
    if $tvg_text_available; then
        tvg-text "$tvgt_file" -o "$svg_file"
    fi
done
