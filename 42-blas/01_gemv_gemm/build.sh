#!/usr/bin/env bash
# Link the Fortran BLAS and compare it with the triple loop.
# Run from the repository root:  scripts/run.sh 42-blas/01_gemv_gemm/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

if pkg-config --exists blas; then
  libs="$(pkg-config --libs blas)"
else
  libs=-lblas
fi

# shellcheck disable=SC2086
if ! "$FC" $FFLAGS demo.f90 -o "$OUT/demo" $libs >"$OUT/log" 2>&1; then
  if grep -qiE 'cannot find -lblas|undefined reference to .dge(mv|mm)_' "$OUT/log"; then
    echo "BLAS was not found"
    exit 77
  fi
  cat "$OUT/log"
  exit 1
fi
"$OUT/demo"
