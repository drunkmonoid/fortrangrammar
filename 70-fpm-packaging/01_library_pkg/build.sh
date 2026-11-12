#!/usr/bin/env bash
# Package build and test with fpm. Exit 77 when fpm is absent.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

if ! command -v fpm >/dev/null 2>&1; then
  echo "fpm was not found"
  exit 77
fi

fpm build --compiler "$FC"
fpm test --compiler "$FC"
