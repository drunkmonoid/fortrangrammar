#!/usr/bin/env bash
# Generate Fortran source using fypp and compile. Exit 77 when fypp is absent.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

if ! command -v fypp >/dev/null 2>&1; then
  echo "fypp preprocessor was not found"
  exit 77
fi

fypp axpy.fypp "$OUT/axpy.f90"
# shellcheck disable=SC2086
"$FC" $FFLAGS "$OUT/axpy.f90" -o "$OUT/axpy_demo"
"$OUT/axpy_demo"
