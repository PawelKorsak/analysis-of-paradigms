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

if go build -o ./build/functional_hash ./go/functional/hash.go; then
    echo "Go build successful."
else
    echo "Go build failed."
    exit 1
fi

if go build -o ./build/procedural_hash ./go/procedural/hash.go; then
    echo "Go build successful."
else
    echo "Go build failed."
    exit 1
fi

if go build -o ./build/objective_hash ./go/objective/hash.go; then
    echo "Go build successful."
else
    echo "Go build failed."
    exit 1
fi

if go build -o ./build/functional_pid ./go/functional/pid.go; then
    echo "Go build successful."
else
    echo "Go build failed."
    exit 1
fi

if go build -o ./build/procedural_pid ./go/procedural/pid.go; then
    echo "Go build successful."
else
    echo "Go build failed."
    exit 1
fi

if go build -o ./build/objective_pid ./go/objective/pid.go; then
    echo "Go build successful."
else
    echo "Go build failed."
    exit 1
fi

if go build -o ./build/functional_sorting ./go/functional/sorting.go; then
    echo "Go build successful."
else
    echo "Go build failed."
    exit 1
fi

if go build -o ./build/procedural_sorting ./go/procedural/sorting.go; then
    echo "Go build successful."
else
    echo "Go build failed."
    exit 1
fi

if go build -o ./build/objective_sorting ./go/objective/sorting.go; then
    echo "Go build successful."
else
    echo "Go build failed."
    exit 1
fi