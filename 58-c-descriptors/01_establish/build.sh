#!/usr/bin/env bash
# ISO_Fortran_binding.h ships with gfortran.
# Run from the repository root:  scripts/run.sh 58-c-descriptors/01_establish/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}" "${CC:=gcc}"

"$CC" -std=c11 -Wall -Wextra -c cdesc.c -o "$OUT/cdesc.o"
# shellcheck disable=SC2086
"$FC" $FFLAGS -c main.f90 -o "$OUT/main.o"
# shellcheck disable=SC2086
"$FC" $FFLAGS "$OUT/main.o" "$OUT/cdesc.o" -o "$OUT/app"
"$OUT/app"
