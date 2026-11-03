#!/usr/bin/env bash
# Compile and run every example, honouring the @directives in CONVENTIONS.md.
# Usage: scripts/check_all.sh [chapter-dir...]     (default: all chapters)
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
shopt -s nullglob

pass=0
fail=0
skip=0
failures=()

ok()   { pass=$((pass + 1)); printf 'PASS  %s\n' "$1"; }
bad()  { fail=$((fail + 1)); failures+=("$1"); printf 'FAIL  %s  (%s)\n' "$1" "$2"; }

if [[ $# -gt 0 ]]; then
  chapters=("$@")
else
  chapters=("$root"/[0-9][0-9]-*/)
fi

log="$(mktemp)"
trap 'rm -f "$log"' EXIT

for chapter in "${chapters[@]}"; do
  chapter="$(realpath "$chapter")"

  for src in "$chapter"/*.f90 "$chapter"/*.F90; do
    rel="${src#"$root"/}"
    mode="$(directive build "$src")"

    if [[ $mode == skip* ]]; then
      skip=$((skip + 1))
      printf 'SKIP  %s  (%s)\n' "$rel" "${mode#skip}"
      continue
    fi

    if ! exe="$(build_one "$src" 2>"$log")"; then
      if [[ $mode == fail* ]]; then ok "$rel"; else bad "$rel" "compile error"; cat "$log"; fi
      continue
    fi
    if [[ $mode == fail* ]]; then
      bad "$rel" "compiled but was expected to fail"
      continue
    fi
    if [[ "$(directive run "$src")" == no* ]]; then
      ok "$rel"
      continue
    fi

    expected="$(directive exit "$src")"
    # shellcheck disable=SC2046
    timeout 20 "$exe" $(directive args "$src") </dev/null >"$log" 2>&1
    status=$?
    if [[ $status -eq ${expected:-0} ]]; then
      ok "$rel"
    else
      bad "$rel" "exit status $status, expected ${expected:-0}"
      tail -n 20 "$log"
    fi
  done

  for script in "$chapter"/*/build.sh; do
    dir="$(dirname "$script")"
    rel="${dir#"$root"/}/"
    OUT="$BUILD_DIR/${dir#"$root"/}"
    rm -rf "$OUT" && mkdir -p "$OUT"
    FC="$FC" FFLAGS="$FFLAGS" OUT="$OUT" bash "$script" </dev/null >"$log" 2>&1
    status=$?
    if [[ $status -eq 0 ]]; then
      ok "$rel"
    elif [[ $status -eq 77 ]]; then
      skip=$((skip + 1))
      printf 'SKIP  %s  (%s)\n' "$rel" "$(tail -n 1 "$log")"
    else
      bad "$rel" "build.sh failed"
      tail -n 20 "$log"
    fi
  done
done

printf '\n%d passed, %d failed, %d skipped\n' "$pass" "$fail" "$skip"
if [[ $fail -gt 0 ]]; then
  printf 'failed: %s\n' "${failures[@]}"
  exit 1
fi
