
cmake_minimum_required(VERSION 4.0)
project(analysis-of-paradigms LANGUAGES CXX)

set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_CXX_FLAGS_DEBUG "-O0")

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/common)

add_executable(procedural_hash ${CMAKE_CURRENT_SOURCE_DIR}/procedural/hash.cc)
add_executable(procedural_sorting ${CMAKE_CURRENT_SOURCE_DIR}/procedural/sorting.cc)
add_executable(procedural_pid ${CMAKE_CURRENT_SOURCE_DIR}/procedural/pid.cc)

add_executable(functional_hash ${CMAKE_CURRENT_SOURCE_DIR}/functional/hash.cc)
add_executable(functional_sorting ${CMAKE_CURRENT_SOURCE_DIR}/functional/sorting.cc)
add_executable(functional_pid ${CMAKE_CURRENT_SOURCE_DIR}/functional/pid.cc)

add_executable(objective_hash ${CMAKE_CURRENT_SOURCE_DIR}/objective/hash.cc)
add_executable(objective_sorting ${CMAKE_CURRENT_SOURCE_DIR}/objective/sorting.cc)
add_executable(objective_pid ${CMAKE_CURRENT_SOURCE_DIR}/objective/pid.cc)
