#!/bin/bash

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

if cmake -S ./cpp/ -B ./build; then
    echo "CMake configuration successful."
else
    echo "CMake configuration failed."
    exit 1
fi
if cmake --build ./build; then
    echo "Build successful."
else
    echo "Build failed."
    exit 1
fi