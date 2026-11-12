#!/usr/bin/env bash
# Compile against NetCDF Fortran interface. Exit 77 when NetCDF is absent.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

inc=()
libs=()

if command -v nf-config >/dev/null 2>&1; then
  # shellcheck disable=SC2207
  inc+=($(nf-config --fflags))
  # shellcheck disable=SC2207
  libs=($(nf-config --flibs))
elif pkg-config --exists netcdf-fortran 2>/dev/null; then
  # shellcheck disable=SC2207
  inc+=($(pkg-config --cflags netcdf-fortran))
  # shellcheck disable=SC2207
  libs=($(pkg-config --libs netcdf-fortran))
fi

# shellcheck disable=SC2086
if ! "$FC" $FFLAGS "${inc[@]}" netcdf_demo.f90 -o "$OUT/netcdf_demo" "${libs[@]}" >"$OUT/log" 2>&1; then
  if grep -qiE 'cannot open module file|cannot find -lnetcdff|command not found' "$OUT/log"; then
    echo "NetCDF Fortran interface was not found"
    exit 77
  fi
  cat "$OUT/log"
  exit 1
fi

(cd "$OUT" && ./netcdf_demo)
rm -f "$OUT/test.nc"
