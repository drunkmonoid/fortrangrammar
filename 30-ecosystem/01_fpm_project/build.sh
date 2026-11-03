#!/usr/bin/env bash
# With fpm installed:   cd 30-ecosystem/01_fpm_project && fpm build && fpm run && fpm test
# Without fpm (as on the machine that generated this repo) this script builds
# the same sources by hand so the example is still verified.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"
if command -v fpm >/dev/null; then
  fpm run --compiler "$FC" && fpm test --compiler "$FC"
else
  # shellcheck disable=SC2086
  "$FC" $FFLAGS -J "$OUT" -c src/stats.f90 -o "$OUT/stats.o"
  # shellcheck disable=SC2086
  "$FC" $FFLAGS -J "$OUT" app/main.f90 "$OUT/stats.o" -o "$OUT/main"
  # shellcheck disable=SC2086
  "$FC" $FFLAGS -J "$OUT" test/check.f90 "$OUT/stats.o" -o "$OUT/check"
  "$OUT/main"
  "$OUT/check"
fi
