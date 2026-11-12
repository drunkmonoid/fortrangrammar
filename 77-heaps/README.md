# 77 — Heaps

A binary heap is a complete binary tree laid out contiguously inside an array.
In Fortran's standard 1-based indexing:
- Node $i$ has parent $\lfloor i / 2 \rfloor$
- Left child $2i$
- Right child $2i + 1$

This chapter demonstrates:
- A `min_heap_t` priority queue implementing logarithmic $O(\log N)$ push (sift-up)
  and pop (sift-down)
- Using heap invariants to sort arbitrary arrays in $O(N \log N)$ time with optimal
  memory locality

## Examples

| File | Topic |
|---|---|
| [01_heap.f90](01_heap.f90) | Binary min-heap and heap sort using 1-based array arithmetic |
