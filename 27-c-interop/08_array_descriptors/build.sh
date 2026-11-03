#!/usr/bin/env bash
# ISO_Fortran_binding.h ships with gfortran and is on gcc's include path.
# Run from the repository root:  scripts/run.sh 27-c-interop/08_array_descriptors/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}" "${CC:=gcc}"
"$CC" -std=c11 -Wall -Wextra -c cdesc.c -o "$OUT/cdesc.o"
# shellcheck disable=SC2086
"$FC" $FFLAGS -J "$OUT" -c main.f90 -o "$OUT/main.o"
"$FC" "$OUT/main.o" "$OUT/cdesc.o" -o "$OUT/app"
"$OUT/app"
