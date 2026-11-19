# Reading orders

Three ways through the chapters that are already in the tree. Each line
is why that chapter comes next. Phases 115–154 are in [PLAN.md](PLAN.md)
and have no directories yet.

## Language

The language itself, then the generic, error, and parsing chapters that
sit on top of it. Waiting on 115–120 (older `-std` revisions) and
140–145 (types used as a design tool).

1. **01** — compile a program and turn implicit typing off.
2. **02** — how the source is read: names, comments, continuation.
3. **03** — the five intrinsic types and their kinds.
4. **04** — declarations and attributes.
5. **05** — expressions, and the fact that `.and.` does not stop early.
6. **06** — `if`, `select case`, and `do`.
7. **07** — array shape, order, and sections.
8. **08** — allocation and argument shape.
9. **09** — the array intrinsics, including `matmul` and `reduce`.
10. **10** — character length, substrings, and `split`.
11. **11** — procedures, `intent`, and `optional`.
12. **12** — interfaces and generics.
13. **13** — `pure`, `elemental`, and recursion.
14. **14** — modules.
15. **15** — submodules.
16. **16** — derived types.
17. **17** — parameterized types.
18. **18** — extension and `select type`.
19. **19** — abstract types and finalizers.
20. **20** — `class(*)`.
21. **21** — pointers and targets.
22. **22** — formats.
23. **23** — files, scratch files, and namelists.
24. **24** — `stat`, `iostat`, and the environment.
25. **25** — the numeric model and IEEE arithmetic.
26. **26** — the intrinsic catalogue.
27. **27** — `iso_c_binding`.
28. **28** — `do concurrent` and coarrays.
29. **29** — OpenMP, OpenACC, and MPI.
30. **30** — fpm, CMake, and tests.
31. **31** — fixed form, so old source is readable.
32. **32** — `common` and `equivalence`.
33. **33** — statement functions, `entry`, `forall`, labelled `do`.
34. **34** — the forms gfortran 15 rejects.
35. **35** — a Fortran 77 program beside the modern one.
36. **36** — what the standard leaves undefined.
37. **49** — one kernel for three real kinds, without templates.
38. **68** — a result type instead of an exception.
39. **82** — a string buffer that does not copy on every append.
40. **83** — tokens for `2 * (a + 10)`.
41. **84** — the parse tree of that expression.
42. **85** — the value of the tree.

## Numerics

From kinds and arrays to the small solvers. Waiting on 131–139
(intervals, adaptive steps, a hand-written FFT, multigrid).

1. **03** — real kinds, because every later tolerance depends on them.
2. **07** — column-major layout.
3. **08** — allocatable work arrays.
4. **09** — reductions and `matmul`.
5. **25** — what a floating-point number actually is.
6. **39** — traversal order and a noncontiguous argument.
7. **40** — decimal fractions and `ieee_fma`.
8. **44** — a sparse matrix-vector product and Jacobi.
9. **45** — quadrature and a scalar root.
10. **46** — Euler and RK4 on a known solution.
11. **89** — interpolation on `x**2`.
12. **90** — a 1-D Poisson problem, solved directly.
13. **91** — one heat step that must not move a linear profile.
14. **92** — upwind advection at CFL 1.
15. **93** — conjugate gradient on the chapter 44 matrix.
16. **94** — Newton on a 2×2 system.
17. **95** — a least-squares line from the normal equations.
18. **96** — one Richardson step.
19. **97** — a fixed generator, not `random_number`.
20. **98** — a product Simpson rule.
21. **99** — series for `exp` and `erf`.
22. **100** — golden-section search.

## Applications

Data in, a structure, a small model. Waiting on 121–130 (sorting,
graphs, calendars) and 146–149 (`wc`, WAV, UTF-8, logging).

1. **50** — CSV, including a quoted comma.
2. **51** — a namelist default and one environment override.
3. **75** — a stack that grows with `move_alloc`.
4. **76** — an arena of integer indices.
5. **77** — a binary heap.
6. **78** — an open-addressed map.
7. **79** — union-find.
8. **80** — breadth-first search.
9. **81** — a sorted table.
10. **101** — one generation of a blinker.
11. **102** — escape counts.
12. **103** — one Euler step of a circular orbit.
13. **104** — slope and intercept of a line.
14. **105** — one k-means update.
15. **106** — an SIR step whose compartments still sum to `N`.
16. **107** — a 2×2 PPM round trip.
17. **108** — a segment that hits the unit circle, and one that misses.
