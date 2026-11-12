# 76 — Arenas

In scientific codes, building dynamic data structures (trees, graphs, linked lists)
using Fortran pointer components (`pointer`) can lead to pointer chasing, cache
misses, and allocation overhead.

An **arena allocator** stores elements inside a single, pre-allocated contiguous array.
Node links and child pointers are simple 1-based integer array indices (`next = 0` representing null):
- Contiguous memory maximizes CPU cache line efficiency
- Eliminates heap allocation during graph/list construction
- Free nodes are recycled in $O(1)$ time using an internal free list index stack

## Examples

| File | Topic |
|---|---|
| [01_arena.f90](01_arena.f90) | Contiguous array arena with integer indexing and free-node recycling |
