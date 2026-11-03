#!/usr/bin/env bash
# Compile and run one example.
# Usage: scripts/run.sh path/to/example.f90 [program arguments...]
#        scripts/run.sh path/to/multi_file_example/   (runs its build.sh)
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if [[ $# -lt 1 ]]; then
  echo "usage: $0 FILE.f90 [args...] | DIR/" >&2
  exit 2
fi

target="$1"
shift

if [[ -d $target ]]; then
  dir="$(realpath "$target")"
  OUT="$BUILD_DIR/${dir#"$root"/}"
  rm -rf "$OUT" && mkdir -p "$OUT"
  FC="$FC" FFLAGS="$FFLAGS" OUT="$OUT" bash "$dir/build.sh"
  exit
fi

exe="$(build_one "$target")"
"$exe" "$@"
