#!/usr/bin/env bash
# Build and run Fortran tests, C driver, and optional Python caller.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"
: "${CC:=cc}"

# 1. Compile module and submodule
# shellcheck disable=SC2086
"$FC" $FFLAGS -fPIC -J "$OUT" -c src/interp1d.f90 -o "$OUT/interp1d.o"
# shellcheck disable=SC2086
"$FC" $FFLAGS -fPIC -J "$OUT" -c src/interp1d_impl.f90 -o "$OUT/interp1d_impl.o"

# 2. Compile and run Fortran unit test
# shellcheck disable=SC2086
"$FC" $FFLAGS -I "$OUT" test/test_interp.f90 "$OUT/interp1d.o" "$OUT/interp1d_impl.o" -o "$OUT/test_interp"
"$OUT/test_interp"

# 3. Build shared library for interop
# shellcheck disable=SC2086
"$FC" $FFLAGS -shared "$OUT/interp1d.o" "$OUT/interp1d_impl.o" -o "$OUT/libinterp1d.so"

# 4. Compile and run C driver against include/interp1d.h
"$CC" -Wall -Iinclude app/c_driver.c -L"$OUT" -linterp1d -Wl,-rpath,"$OUT" -o "$OUT/c_driver"
"$OUT/c_driver"

# 5. Optional Python caller
if command -v python3 >/dev/null 2>&1; then
  python3 test/test_caller.py "$OUT/libinterp1d.so"
fi
