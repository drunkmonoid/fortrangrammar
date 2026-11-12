# 81 — Sorted Tables

A **sorted table** (or flat map) stores key-value pairs contiguously in an array
sorted by key.

While insertions require $O(N)$ element shifts, sorted arrays offer significant advantages:
- Exact and lower-bound queries run in $O(\log N)$ time via binary search
- Perfect memory compactness with zero pointer overhead
- Superior hardware prefetching and cache-line locality compared to pointer trees

## Examples

| File | Topic |
|---|---|
| [01_sorted_table.f90](01_sorted_table.f90) | Sorted array map with binary search and in-order insertion |
