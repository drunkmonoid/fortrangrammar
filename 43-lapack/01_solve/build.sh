#!/usr/bin/env bash
# Link LAPACK and BLAS. Exit 77 when either library is missing.
# Run from the repository root:  scripts/run.sh 43-lapack/01_solve/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

if pkg-config --exists lapack; then
  libs="$(pkg-config --libs lapack)"
else
  libs="-llapack -lblas"
fi

# shellcheck disable=SC2086
if ! "$FC" $FFLAGS demo.f90 -o "$OUT/demo" $libs >"$OUT/log" 2>&1; then
  if grep -qiE 'cannot find -l(lapack|blas)|undefined reference to .d(gesv|gels|syev)_' "$OUT/log"; then
    echo "LAPACK was not found"
    exit 77
  fi
  cat "$OUT/log"
  exit 1
fi
"$OUT/demo"
