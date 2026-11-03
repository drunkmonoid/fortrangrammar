#!/usr/bin/env bash
# Run from the repository root:  scripts/run.sh 30-ecosystem/03_make_project/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"
make --no-print-directory -s FC="$FC" FFLAGS="$FFLAGS" OUT="$OUT"
"$OUT/app"
