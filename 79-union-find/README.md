# 79 — Union-Find

The **Disjoint Set Union (DSU)** data structure maintains a collection of disjoint sets,
enabling fast set merging (`union`) and membership testing (`find`).

This chapter demonstrates:
- **Path compression**: Recursively updating node parents to point directly to the set
  root during tree traversal
- **Union by rank**: Maintaining tree balance by attaching trees with smaller ranks
  under the root of larger trees
- Achieving near-linear $O(\alpha(N))$ time per query, where $\alpha$ is the inverse
  Ackermann function

## Examples

| File | Topic |
|---|---|
| [01_union_find.f90](01_union_find.f90) | Disjoint sets on elements 1..6 with path compression and union by rank |
