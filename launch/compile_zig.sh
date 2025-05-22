#!/bin/bash

# Clean and create build directory
if rm -rf ./build 2>/dev/null; then
    echo "Removed existing build directory."
else
    echo "No existing build directory found."
fi

if mkdir build 2>/dev/null; then
    echo "Created build directory."
else
    echo "Failed to create build directory."
    exit 1
fi

# Function to compile Zig source file and move output
compile_zig () {
    src_file=$1
    output_name=$2

    if zig build-exe "$src_file" --name "$output_name"; then
        mv "$output_name" ./build/
        echo "Zig build successful: ./build/$output_name"
    else
        echo "Zig build failed: $src_file"
        exit 1
    fi
}

# Compile functional Zig files
compile_zig ./zig/functional/hash.zig     functional_hash
compile_zig ./zig/functional/pid.zig      functional_pid
compile_zig ./zig/functional/sorting.zig  functional_sorting

# Compile procedural Zig files
compile_zig ./zig/procedural/hash.zig     procedural_hash
compile_zig ./zig/procedural/pid.zig      procedural_pid
compile_zig ./zig/procedural/sorting.zig  procedural_sorting
