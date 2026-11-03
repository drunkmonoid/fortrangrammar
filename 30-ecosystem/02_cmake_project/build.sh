#!/usr/bin/env bash
# Configure, build and test out of source:
#   cmake -S . -B build && cmake --build build && ctest --test-dir build
# Run from the repository root:  scripts/run.sh 30-ecosystem/02_cmake_project/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${OUT:=$(mktemp -d)}"
if ! cmake --version >/dev/null 2>&1; then
  echo "no working cmake found"
  exit 77
fi
cmake -S . -B "$OUT" -DCMAKE_Fortran_COMPILER="$FC" -DCMAKE_BUILD_TYPE=Debug > "$OUT/configure.log"
cmake --build "$OUT" -j 1 > "$OUT/build.log"
"$OUT/app"
ctest --test-dir "$OUT" --output-on-failure | grep -E 'tests passed|Failed'
