#!/usr/bin/env bash
# Compile against HDF5 Fortran bindings. Exit 77 when HDF5 is absent.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

inc=()
libs=()

if command -v h5fc >/dev/null 2>&1; then
  FC="h5fc"
elif pkg-config --exists hdf5-fortran 2>/dev/null; then
  # shellcheck disable=SC2207
  inc+=($(pkg-config --cflags hdf5-fortran))
  # shellcheck disable=SC2207
  libs=($(pkg-config --libs hdf5-fortran))
elif pkg-config --exists hdf5 2>/dev/null; then
  # shellcheck disable=SC2207
  inc+=($(pkg-config --cflags hdf5))
  # shellcheck disable=SC2207
  libs=($(pkg-config --libs hdf5) -lhdf5_fortran)
fi

# shellcheck disable=SC2086
if ! "$FC" $FFLAGS "${inc[@]}" hdf5_demo.f90 -o "$OUT/hdf5_demo" "${libs[@]}" >"$OUT/log" 2>&1; then
  if grep -qiE 'cannot open module file|cannot find -lhdf5|command not found' "$OUT/log"; then
    echo "HDF5 Fortran bindings were not found"
    exit 77
  fi
  cat "$OUT/log"
  exit 1
fi

(cd "$OUT" && ./hdf5_demo)
rm -f "$OUT/test.h5"
