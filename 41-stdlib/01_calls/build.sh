#!/usr/bin/env bash
# Compile against an installed stdlib. Exit 77 when the modules are absent.
#   STDLIB_INC=/path/to/mods scripts/run.sh 41-stdlib/01_calls/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

inc=()
if [[ -n ${STDLIB_INC:-} ]]; then
  inc=(-I "$STDLIB_INC")
fi

# shellcheck disable=SC2086
if ! "$FC" $FFLAGS "${inc[@]}" demo.f90 -o "$OUT/demo" >"$OUT/log" 2>&1; then
  if grep -qi 'cannot open module file' "$OUT/log"; then
    echo "stdlib modules were not found"
    exit 77
  fi
  cat "$OUT/log"
  exit 1
fi
"$OUT/demo"
