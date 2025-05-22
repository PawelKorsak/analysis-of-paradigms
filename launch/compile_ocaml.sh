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

# Function to compile OCaml file
compile_ocaml () {
    src_file=$1
    out_file=$2
    if ocamlc -o "$out_file" "$src_file"; then
        echo "OCaml build successful: $out_file"
    else
        echo "OCaml build failed: $src_file"
        exit 1
    fi
}

# Compile each program
compile_ocaml ./ocaml/functional/hash.ml     ./build/functional_hash
compile_ocaml ./ocaml/procedural/hash.ml     ./build/procedural_hash
compile_ocaml ./ocaml/objective/hash.ml      ./build/objective_hash

compile_ocaml ./ocaml/functional/pid.ml      ./build/functional_pid
compile_ocaml ./ocaml/procedural/pid.ml      ./build/procedural_pid
compile_ocaml ./ocaml/objective/pid.ml       ./build/objective_pid

compile_ocaml ./ocaml/functional/sorting.ml  ./build/functional_sorting
compile_ocaml ./ocaml/procedural/sorting.ml  ./build/procedural_sorting
compile_ocaml ./ocaml/objective/sorting.ml   ./build/objective_sorting
