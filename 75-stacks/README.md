# 75 — Stacks

This chapter begins the Second Haul (Phases 75–114) focusing on core algorithms,
data structures, parsing, numerical methods, and applications written in pure,
dependency-free Fortran 2023.

A dynamically growable LIFO stack of integers is implemented using `move_alloc`
(Chapter 08):
- Capacity doubling upon buffer saturation avoids frequent small reallocations
- Safe popping with error status signaling (`stat = -1` on underflow)
- Encapsulation inside a derived type with type-bound procedures

## Examples

| File | Topic |
|---|---|
| [01_stack.f90](01_stack.f90) | Dynamic integer stack with amortized O(1) push and pop using `move_alloc` |
