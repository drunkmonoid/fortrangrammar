#!/usr/bin/env bash
# Build every exercise and compare its stdout with the ! Output: block.
# Coarray and OpenMP flags come from a "! @flags" line in the source.
set -euo pipefail

FC="${FC:-gfortran}"
FFLAGS="${FFLAGS:--std=f2023 -Wall -Wextra -pedantic -fcheck=all -g -fbacktrace}"
DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="${OUT:-$(mktemp -d)}"
mkdir -p "$OUT"

shopt -s nullglob
mapfile -t sources < <(printf '%s\n' "$DIR"/ex[0-9][0-9].f90 "$DIR"/ex[0-9][0-9].f | sort)

count=0
for src in "${sources[@]}"; do
  [[ -f $src ]] || continue
  extra="$(sed -n 's/^[[:space:]]*![[:space:]]*@flags[[:space:]]*//p' "$src" | head -n 1)"
  name="$(basename "$src")"
  name="${name%.*}"
  exe="$OUT/$name"
  # shellcheck disable=SC2086
  "$FC" $FFLAGS $extra "$src" -J"$OUT" -o "$exe"
  actual="$("$exe" | sed -e 's/[[:space:]]*$//')"
  expected="$(sed -n '/^! Output:/,$p' "$src" | tail -n +2 | sed -e 's/^! //' -e 's/^!$//')"
  if [[ -n $expected && $actual != "$expected" ]]; then
    echo "Output mismatch in $src" >&2
    diff -u <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") >&2 || true
    exit 1
  fi
  count=$((count + 1))
done

echo "$count/$count exercise solutions verified"
