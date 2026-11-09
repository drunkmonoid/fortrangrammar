#!/usr/bin/env bash
# Shared library plus a C driver that includes only scale.h.
# Run from the repository root:  scripts/run.sh 59-library-abi/01_shared/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}" "${CC:=gcc}"

# shellcheck disable=SC2086
"$FC" $FFLAGS -shared -fPIC -J "$OUT" scale.f90 -o "$OUT/libscale.so"
"$CC" -std=c11 -Wall -Wextra driver.c -I. -L"$OUT" -lscale -Wl,-rpath,"$OUT" -o "$OUT/driver"
"$OUT/driver"
