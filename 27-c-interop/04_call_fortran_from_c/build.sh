#!/usr/bin/env bash
# A C main program linked against Fortran code. Link with the Fortran
# compiler (or add -lgfortran when linking with the C compiler).
# Run from the repository root:  scripts/run.sh 27-c-interop/04_call_fortran_from_c/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}" "${CC:=gcc}"
# shellcheck disable=SC2086
"$FC" $FFLAGS -J "$OUT" -c flib.f90 -o "$OUT/flib.o"
"$CC" -std=c11 -Wall -Wextra -c main.c -o "$OUT/main.o"
"$FC" "$OUT/main.o" "$OUT/flib.o" -o "$OUT/app"
"$OUT/app"
