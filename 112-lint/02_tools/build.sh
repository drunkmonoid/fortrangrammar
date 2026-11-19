#!/usr/bin/env bash
# Run fprettify and fortitude on the chapter sample. Exit 77 if either is missing.
# Run from the repository root:  scripts/run.sh 112-lint/02_tools/
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
sample="../01_sample.f90"

if ! command -v fprettify >/dev/null 2>&1 || ! command -v fortitude >/dev/null 2>&1; then
  echo "fprettify or fortitude was not found"
  exit 77
fi

diff="$(fprettify --diff "$sample")"
if [[ -n $diff ]]; then
  printf '%s\n' "$diff"
  exit 1
fi
fortitude check --quiet "$sample"
echo clean
