#!/usr/bin/env bash
# legacy.f and modern.f90 print the same lines. diff is the test.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

# shellcheck disable=SC2086
"$FC" $FFLAGS legacy.f -o "$OUT/legacy"
# shellcheck disable=SC2086
"$FC" $FFLAGS modern.f90 -o "$OUT/modern"
"$OUT/legacy" > "$OUT/legacy.out"
"$OUT/modern" > "$OUT/modern.out"
diff -u "$OUT/legacy.out" "$OUT/modern.out"
cat "$OUT/modern.out"
