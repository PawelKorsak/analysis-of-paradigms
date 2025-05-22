#!/bin/bash

cd rust || exit 1

# Clean and create build directory
if rm -rf ../build 2>/dev/null; then
    echo "Removed existing build directory."
else
    echo "No existing build directory found."
fi

if mkdir ../build 2>/dev/null; then
    echo "Created build directory."
else
    echo "Failed to create build directory."
    exit 1
fi

# Function to build a binary with Cargo and copy it
build_binary () {
    binary_name=$1
    if cargo build --bin "$binary_name" --release; then
        cp target/release/"$binary_name" ../build/
        echo "Rust build successful: $binary_name"
    else
        echo "Rust build failed: $binary_name"
        exit 1
    fi
}

# Build binaries
build_binary functional_hash
build_binary procedural_hash

build_binary functional_pid
build_binary procedural_pid

build_binary functional_sorting
build_binary procedural_sorting
