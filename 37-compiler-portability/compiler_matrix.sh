#!/usr/bin/env bash
# Run check_all.sh once per compiler found on PATH.
# Usage: 37-compiler-portability/compiler_matrix.sh
set -uo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

run_one() {
  local fc="$1"
  shift
  if ! command -v "$fc" >/dev/null 2>&1; then
    printf 'SKIP  %s  (not on PATH)\n' "$fc"
    return 0
  fi
  printf '\n==== %s %s ====\n' "$fc" "$*"
  FC="$fc" FFLAGS="$*" "$root/scripts/check_all.sh"
}

run_one gfortran -std=f2023 -Wall -Wextra -pedantic
run_one ifx -stand f23 -warn all
run_one flang -pedantic -Wall
