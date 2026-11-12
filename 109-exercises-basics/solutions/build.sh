#!/usr/bin/env bash
set -euo pipefail

FC="${FC:-gfortran}"
FFLAGS="${FFLAGS:--std=f2023 -Wall -Wextra -pedantic -fcheck=all -g -fbacktrace}"
DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$DIR/../.." && pwd)"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

for src in "$DIR"/ex[0-9][0-9].f90; do
  name="$(basename "$src" .f90)"
  exe="$TMPDIR/$name"
  # shellcheck disable=SC2086
  "$FC" $FFLAGS "$src" -o "$exe"
  actual="$("$exe")"
  expected="$(sed -n '/^! Output:/,$ { /^! Output:/d; /^!/s/^! \{0,1\}//p; }' "$src")"
  if [[ -n "$expected" && "$actual" != "$expected" ]]; then
    echo "Output mismatch in $src:" >&2
    diff -u <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") >&2 || true
    exit 1
  fi
done
echo "10/10 exercise solutions verified"
