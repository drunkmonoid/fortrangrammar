#!/usr/bin/env bash
# Compile against an installed toml-f. Exit 77 when toml-f is absent.
#   TOMLF_INC=/path/to/mods scripts/run.sh 53-toml/01_read_manifest/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

inc=()
if [[ -n ${TOMLF_INC:-} ]]; then
  inc=(-I "$TOMLF_INC")
fi
libs=()
if pkg-config --exists toml-f 2>/dev/null; then
  # shellcheck disable=SC2207
  inc+=($(pkg-config --cflags toml-f))
  # shellcheck disable=SC2207
  libs=($(pkg-config --libs toml-f))
else
  libs=(-ltoml-f)
fi

# shellcheck disable=SC2086
if ! "$FC" $FFLAGS "${inc[@]}" read_manifest.f90 -o "$OUT/read_manifest" "${libs[@]}" >"$OUT/log" 2>&1; then
  if grep -qiE 'cannot open module file|cannot find -ltoml-f' "$OUT/log"; then
    echo "toml-f was not found"
    exit 77
  fi
  cat "$OUT/log"
  exit 1
fi

cp fpm.toml "$OUT/"
(cd "$OUT" && ./read_manifest)
