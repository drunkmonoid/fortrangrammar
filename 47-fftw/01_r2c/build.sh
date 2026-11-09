#!/usr/bin/env bash
# Link FFTW. Exit 77 when the library is missing.
# Run from the repository root:  scripts/run.sh 47-fftw/01_r2c/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

if pkg-config --exists fftw3; then
  libs="$(pkg-config --libs fftw3)"
else
  libs=-lfftw3
fi

# shellcheck disable=SC2086
if ! "$FC" $FFLAGS demo.f90 -o "$OUT/demo" $libs >"$OUT/log" 2>&1; then
  # The runtime SONAME is enough when the -dev symlink is not installed.
  soname="$(gcc -print-file-name=libfftw3.so.3)"
  if [[ $soname != libfftw3.so.3 ]] && "$FC" $FFLAGS demo.f90 -o "$OUT/demo" "$soname" >"$OUT/log" 2>&1; then
    :
  elif grep -qiE 'cannot find -lfftw3|undefined reference to .fftw_' "$OUT/log"; then
    echo "FFTW was not found"
    exit 77
  else
    cat "$OUT/log"
    exit 1
  fi
fi
"$OUT/demo"
