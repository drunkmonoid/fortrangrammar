#!/usr/bin/env bash
# One module, two programs. Both must succeed.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

# shellcheck disable=SC2086
"$FC" $FFLAGS -J "$OUT" -c result.f90 -o "$OUT/result.o"
# shellcheck disable=SC2086
"$FC" $FFLAGS -I "$OUT" -J "$OUT" success.f90 "$OUT/result.o" -o "$OUT/success"
# shellcheck disable=SC2086
"$FC" $FFLAGS -I "$OUT" -J "$OUT" failure.f90 "$OUT/result.o" -o "$OUT/failure"
"$OUT/success"
"$OUT/failure"
