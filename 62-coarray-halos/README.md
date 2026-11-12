# 62 — Coarray Halos

Fortran 2008 introduced coarrays for Partitioned Global Address Space (PGAS)
parallel computing natively in the language.

This chapter demonstrates a 1-D periodic domain decomposition using coarrays
and fine-grained synchronisation:
- Declaring array coarrays with codimensions: `integer :: u(0:n+1)[*]`
- One-sided remote memory access: copying local boundary values directly into
  neighbouring images' halo slots
- Pairwise synchronisation with `sync images`: avoiding the global barrier overhead
  of `sync all` by synchronising only with immediate topological neighbours
- Deadlock analysis: why mismatched or asymmetric `sync images` sequences cause
  circular stalls

## Multi-image execution

To run across multiple images using OpenCoarrays and MPI:
```bash
caf -std=f2023 -O2 01_ring_halo.f90 -o ring_halo
cafrun -n 4 ./ring_halo
```

## Examples

| File | Topic |
|---|---|
| [01_ring_halo.f90](01_ring_halo.f90) | 1-D ring halo exchange with `sync images` |
