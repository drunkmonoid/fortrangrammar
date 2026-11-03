#!/usr/bin/env bash
# Show that changing a submodule does not change the parent .mod file, so
# files that USE the module need not be recompiled.
#
#   geometry.f90       -> geometry.mod  geometry.smod  geometry.o
#   geometry_impl.F90  -> geometry@geometry_impl.smod   geometry_impl.o
#   main.f90           -> main.o   (reads geometry.mod only)
#
# Run from the repository root:  scripts/run.sh 15-submodules/04_compilation_cascade/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

compile() {
  # shellcheck disable=SC2086
  "$FC" $FFLAGS -J "$OUT" "$@"
}

compile -c geometry.f90 -o "$OUT/geometry.o"
compile -c geometry_impl.F90 -o "$OUT/geometry_impl.o"
compile -c main.f90 -o "$OUT/main.o"
# shellcheck disable=SC2086
"$FC" $FFLAGS "$OUT"/geometry.o "$OUT"/geometry_impl.o "$OUT"/main.o -o "$OUT/app"
before="$(md5sum < "$OUT/geometry.mod")"
echo "Euclidean implementation:"
"$OUT/app"

# Change ONLY the implementation, recompile ONLY the submodule, relink.
compile -DMANHATTAN -c geometry_impl.F90 -o "$OUT/geometry_impl.o"
# shellcheck disable=SC2086
"$FC" $FFLAGS "$OUT"/geometry.o "$OUT"/geometry_impl.o "$OUT"/main.o -o "$OUT/app"
after="$(md5sum < "$OUT/geometry.mod")"
echo "Manhattan implementation (main.o NOT recompiled):"
"$OUT/app"

ls "$OUT" | grep -E '\.s?mod$'
if [[ $before == "$after" ]]; then
  echo "geometry.mod unchanged by the submodule edit"
else
  echo "geometry.mod changed (unexpected)"; exit 1
fi
