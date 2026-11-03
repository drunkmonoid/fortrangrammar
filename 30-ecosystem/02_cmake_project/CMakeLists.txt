# CMakeLists.txt - a Fortran library + executable + test with CMake.
# CMake scans Fortran sources for module dependencies itself, so file order
# does not matter (Makefile and Ninja generators both support this).
cmake_minimum_required(VERSION 3.20)
project(geometry LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/modules)

# Standard-conformance flags for GNU; other compilers get their own.
if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  add_compile_options(-std=f2023 -Wall -Wextra -fcheck=all)
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
  add_compile_options(-stand f23 -warn all)
endif()

add_library(geometry src/shapes.f90)
target_include_directories(geometry PUBLIC ${CMAKE_Fortran_MODULE_DIRECTORY})

add_executable(app app/main.f90)
target_link_libraries(app PRIVATE geometry)

enable_testing()
add_executable(test_shapes test/test_shapes.f90)
target_link_libraries(test_shapes PRIVATE geometry)
add_test(NAME shapes COMMAND test_shapes)

# Optional OpenMP: find_package(OpenMP REQUIRED)
#                  target_link_libraries(app PRIVATE OpenMP::OpenMP_Fortran)
