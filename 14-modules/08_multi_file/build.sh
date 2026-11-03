#!/usr/bin/env bash
# Build a program from three files in dependency order.
#
#   constants.f90  ->  constants.mod  constants.o
#   physics.f90    ->  physics.mod    physics.o     (needs constants.mod)
#   main.f90       ->                 main.o        (needs both .mod files)
#   link all .o    ->  app
#
# -J dir tells gfortran where to WRITE .mod files and also adds dir to the
# module SEARCH path. Other compilers: ifx -module dir, flang -module-dir dir.
# Run from the repository root:  scripts/run.sh 14-modules/08_multi_file/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

for src in constants.f90 physics.f90 main.f90; do
  # shellcheck disable=SC2086
  "$FC" $FFLAGS -J "$OUT" -c "$src" -o "$OUT/${src%.f90}.o"
done
"$FC" "$OUT"/constants.o "$OUT"/physics.o "$OUT"/main.o -o "$OUT/app"

ls "$OUT"/*.mod | xargs -n1 basename
"$OUT/app"
