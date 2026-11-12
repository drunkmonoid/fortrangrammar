# 80 — Graphs

Graph structures in scientific computing model mesh topologies, network flows,
and dependency cascades.

This chapter demonstrates:
- An **edge-pool adjacency list** storing incident edges in a contiguous array
  (building upon the arena pattern of Chapter 76)
- **Breadth-First Search (BFS)** traversing graphs level-by-level using an integer queue
- Computing shortest unweighted path distances in $O(V + E)$ time
- Representing disconnected or unreachable components using sentinel distance `-1`

## Examples

| File | Topic |
|---|---|
| [01_bfs.f90](01_bfs.f90) | Adjacency list graph and BFS distance computation |
