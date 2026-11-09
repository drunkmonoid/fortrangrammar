#!/usr/bin/env bash
# g++ links the Fortran runtime. Exit 77 when g++ is missing.
# Run from the repository root:  scripts/run.sh 57-cxx-interop/01_vector/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

if ! command -v g++ >/dev/null 2>&1; then
  echo "g++ was not found"
  exit 77
fi

# shellcheck disable=SC2086
"$FC" $FFLAGS -c scale.f90 -o "$OUT/scale.o"
g++ -Wall -Wextra -c main.cpp -o "$OUT/main.o"
if ! g++ -o "$OUT/demo" "$OUT/main.o" "$OUT/scale.o" -lgfortran >"$OUT/log" 2>&1; then
  if grep -qi 'cannot find -lgfortran' "$OUT/log"; then
    echo "the Fortran runtime was not found"
    exit 77
  fi
  cat "$OUT/log"
  exit 1
fi
"$OUT/demo"
