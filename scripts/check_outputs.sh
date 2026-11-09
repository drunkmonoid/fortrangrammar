#!/usr/bin/env bash
# Rebuild every example that documents its output in an "! Output:" block,
# run it, and report any difference from the documented text.
# Usage: scripts/check_outputs.sh [chapter-dir...]
#        FFLAGS="-std=f2023 -O2" scripts/check_outputs.sh   (any flags)
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
shopt -s nullglob

if [[ $# -gt 0 ]]; then chapters=("$@"); else chapters=("$root"/[0-9][0-9]-*/); fi

same=0
different=0
for chapter in "${chapters[@]}"; do
  for src in "$chapter"/*.f90 "$chapter"/*.F90 "$chapter"/*.f; do
    grep -q '^! Output:' "$src" || continue
    rel="$(realpath --relative-to="$root" "$src")"
    if ! exe="$(build_one "$src" 2>/dev/null)"; then
      different=$((different + 1)); printf 'BUILD FAIL  %s\n' "$rel"; continue
    fi
    # shellcheck disable=SC2046
    actual="$(timeout 30 "$exe" $(directive args "$src") </dev/null 2>/dev/null | sed -e 's/[[:space:]]*$//')"
    expected="$(sed -n '/^! Output:/,$p' "$src" | tail -n +2 | sed -e 's/^! //' -e 's/^!$//')"
    if [[ $actual == "$expected" ]]; then
      same=$((same + 1))
    else
      different=$((different + 1))
      printf 'DIFF  %s\n' "$rel"
      diff <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") | head -n 10
    fi
  done
done

printf '\n%d outputs identical, %d different\n' "$same" "$different"
[[ $different -eq 0 ]]
