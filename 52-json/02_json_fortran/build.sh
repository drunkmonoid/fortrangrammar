#!/usr/bin/env bash
# Compile against json-fortran. Exit 77 when json_module is absent.
#   JSON_INC=/path/to/mods scripts/run.sh 52-json/02_json_fortran/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

inc=()
if [[ -n ${JSON_INC:-} ]]; then
  inc=(-I "$JSON_INC")
fi
libs=()
if pkg-config --exists json-fortran; then
  # shellcheck disable=SC2207
  inc+=($(pkg-config --cflags json-fortran))
  # shellcheck disable=SC2207
  libs=($(pkg-config --libs json-fortran))
fi

# shellcheck disable=SC2086
if ! "$FC" $FFLAGS "${inc[@]}" demo.f90 -o "$OUT/demo" "${libs[@]}" >"$OUT/log" 2>&1; then
  if grep -qiE 'cannot open module file|cannot find -ljsonfortran' "$OUT/log"; then
    echo "json-fortran was not found"
    exit 77
  fi
  cat "$OUT/log"
  exit 1
fi
"$OUT/demo"
