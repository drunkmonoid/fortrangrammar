#!/usr/bin/env bash
# Build a shared library and call it from Python. Exit 77 without NumPy.
# Run from the repository root:  scripts/run.sh 56-python-interop/01_ctypes/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 was not found"
  exit 77
fi
if ! python3 -c 'import numpy' >/dev/null 2>&1; then
  echo "numpy was not found"
  exit 77
fi

# shellcheck disable=SC2086
"$FC" $FFLAGS -shared -fPIC fill.f90 -o "$OUT/libfill.so"
python3 call.py "$OUT/libfill.so"
