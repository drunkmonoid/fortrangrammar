#!/usr/bin/env bash
# Run from the repository root:  scripts/run.sh 27-c-interop/05_strings/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}" "${CC:=gcc}"
"$CC" -std=c11 -Wall -Wextra -c cstr.c -o "$OUT/cstr.o"
# shellcheck disable=SC2086
"$FC" $FFLAGS -J "$OUT" -c main.f90 -o "$OUT/main.o"
"$FC" "$OUT/main.o" "$OUT/cstr.o" -o "$OUT/app"
"$OUT/app"
