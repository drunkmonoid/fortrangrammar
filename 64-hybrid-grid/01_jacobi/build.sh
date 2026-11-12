#!/usr/bin/env bash
# Compile and run hybrid MPI+OpenMP grid. Exit 77 when MPI is absent.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
: "${FC:=gfortran}" "${FFLAGS:=-std=f2023 -Wall}" "${OUT:=$(mktemp -d)}"

MPIFC="mpifort"

if ! command -v "$MPIFC" >/dev/null 2>&1; then
  echo "mpifort was not found"
  exit 77
fi

# Check if mpi_f08 module exists and compile with OpenMP
if ! "$MPIFC" $FFLAGS -fopenmp jacobi_hybrid.f90 -o "$OUT/jacobi_hybrid" >"$OUT/log" 2>&1; then
  if grep -qiE 'cannot open module file|mpi_f08' "$OUT/log"; then
    echo "mpi_f08 module was not found"
    exit 77
  fi
  cat "$OUT/log"
  exit 1
fi

runner=""
if command -v mpirun >/dev/null 2>&1; then
  runner="mpirun"
elif command -v mpiexec >/dev/null 2>&1; then
  runner="mpiexec"
fi

export OMP_NUM_THREADS=2

if [[ -n "$runner" ]]; then
  args=(-n 2)
  if [[ $(id -u) -eq 0 ]]; then
    args+=(--allow-run-as-root)
  fi
  "$runner" "${args[@]}" "$OUT/jacobi_hybrid" || "$OUT/jacobi_hybrid"
else
  "$OUT/jacobi_hybrid"
fi
