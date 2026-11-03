#!/usr/bin/env bash
# Compile the C library with a C compiler, the Fortran program with gfortran,
# and link them with the Fortran compiler (it adds libgfortran).
# Run from the repository root:  scripts/run.sh 27-c-interop/03_call_c_from_fortran/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}" "${CC:=gcc}"
"$CC" -std=c11 -Wall -Wextra -c clib.c -o "$OUT/clib.o"
# shellcheck disable=SC2086
"$FC" $FFLAGS -J "$OUT" -c main.f90 -o "$OUT/main.o"
# shellcheck disable=SC2086
"$FC" $FFLAGS "$OUT/main.o" "$OUT/clib.o" -o "$OUT/app"
"$OUT/app"
