# Fortran Grammar

A comprehensive, example-driven tutorial of **modern Fortran (Fortran 2023)**:
every part of the language and the technologies around it, one topic per file.

- Every example is a small, complete, heavily commented program.
- Every example compiles with `gfortran -std=f2023 -pedantic`, so it is
  standard Fortran, not a vendor dialect.
- Each chapter has a `README.md` summarising the rules and linking its files.

Start here:

- [INDEX.md](INDEX.md) — every example in the repository, one line each
- [PLAN.md](PLAN.md) — the 30-phase roadmap
- [CONVENTIONS.md](CONVENTIONS.md) — file layout and build directives
- [30-ecosystem/09_feature_support.md](30-ecosystem/09_feature_support.md) —
  which F2018/F2023 features gfortran 15 accepts

Files that show standard features gfortran 15 does not implement yet are
still complete, correct examples; they are marked `@build skip` and
reported as SKIP by the check script.

## Quick start

```sh
scripts/run.sh 01-getting-started/01_hello_world.f90   # build + run one example
scripts/check_all.sh                                   # build + run everything
scripts/check_all.sh 01-getting-started                # one chapter
scripts/run.sh 14-modules/08_multi_file/               # a multi-file example
scripts/check_outputs.sh                               # verify every "! Output:" block
FFLAGS="-std=f2023 -O2" scripts/check_outputs.sh       # ...at another optimisation level
scripts/make_index.sh > INDEX.md                       # regenerate the index
FC=ifx FFLAGS="-stand f23 -warn all" scripts/check_all.sh   # another compiler
```

Requires `gfortran` 15 or newer (or another Fortran 2023 compiler) and `bash`.

## Chapters

| # | Chapter | Status |
|---|---|---|
| 01 | [Getting started](01-getting-started/) | ✅ |
| 02 | [Lexical elements](02-lexical-elements/) | ✅ |
| 03 | [Intrinsic types and kinds](03-intrinsic-types/) | ✅ |
| 04 | [Declarations and attributes](04-declarations/) | ✅ |
| 05 | [Expressions and assignment](05-expressions/) | ✅ |
| 06 | [Control flow](06-control-flow/) | ✅ |
| 07 | [Arrays I: fundamentals](07-arrays-fundamentals/) | ✅ |
| 08 | [Arrays II: dynamic arrays and arguments](08-arrays-dynamic/) | ✅ |
| 09 | [Array intrinsics](09-array-intrinsics/) | ✅ |
| 10 | [Characters and strings](10-characters/) | ✅ |
| 11 | [Procedures I](11-procedures-basics/) | ✅ |
| 12 | [Procedures II: interfaces and generics](12-procedures-interfaces/) | ✅ |
| 13 | [Procedure attributes and scoping](13-procedure-attributes/) | ✅ |
| 14 | [Modules](14-modules/) | ✅ |
| 15 | [Submodules](15-submodules/) | ✅ |
| 16 | [Derived types](16-derived-types/) | ✅ |
| 17 | [Parameterized derived types](17-parameterized-types/) | ✅ |
| 18 | [OOP I: extension and polymorphism](18-oop-polymorphism/) | ✅ |
| 19 | [OOP II: abstract types, generics, finalization](19-oop-advanced/) | ✅ |
| 20 | [Unlimited polymorphism and defined I/O](20-unlimited-polymorphism/) | ✅ |
| 21 | [Pointers](21-pointers/) | ✅ |
| 22 | [Formatted I/O](22-formatted-io/) | ✅ |
| 23 | [File I/O](23-file-io/) | ✅ |
| 24 | [Errors and the environment](24-errors-environment/) | ✅ |
| 25 | [Numeric model and IEEE arithmetic](25-numeric-ieee/) | ✅ |
| 26 | [Intrinsic procedure catalog](26-intrinsic-catalog/) | ✅ |
| 27 | [C interoperability](27-c-interop/) | ✅ |
| 28 | [Native parallelism: `do concurrent`, coarrays](28-native-parallelism/) | ✅ |
| 29 | [Parallel ecosystem: OpenMP, OpenACC, MPI](29-parallel-ecosystem/) | ✅ |
| 30 | [Ecosystem: fpm, CMake, testing, tooling](30-ecosystem/) | ✅ |
| 31 | [Fixed form and old declarations](31-fixed-form/) | ✅ |
| 32 | [Storage association](32-storage-association/) | ✅ |
| 33 | [Obsolescent forms](33-obsolescent-forms/) | ✅ |
| 34 | [Deleted features](34-deleted-features/) | ✅ |
| 35 | [Fortran 77 rewrites](35-f77-rewrites/) | ✅ |
| 36 | [Conformance](36-conformance/) | ✅ |
| 37 | [Compiler portability](37-compiler-portability/) | ✅ |
| 38 | [Fortran 202Y](38-fortran-202y/) | ✅ |
| 39 | [Array performance](39-array-performance/) | ✅ |
| 40 | [Floating-point practice](40-floating-point-practice/) | ✅ |
| 41 | [stdlib](41-stdlib/) | ✅ |
| 42 | [BLAS](42-blas/) | ✅ |
| 43 | [LAPACK](43-lapack/) | ✅ |
| 44 | [Sparse matrices](44-sparse/) | ✅ |
| 45 | [Quadrature and roots](45-quadrature/) | ✅ |
| 46 | [ODEs](46-ode/) | ✅ |
| 47 | [FFTW](47-fftw/) | ✅ |
| 48 | [Random variates](48-random-variates/) | ✅ |
| 49 | [Generic kernels](49-generic-kernels/) | ✅ |
| 50 | [CSV](50-csv/) | ✅ |
| 51 | [Configuration](51-configuration/) | ✅ |
| 52 | [JSON](52-json/) | ✅ |
| 53 | [TOML](53-toml/) | ✅ |
| 54 | [HDF5](54-hdf5/) | ✅ |
| 55 | [NetCDF](55-netcdf/) | ✅ |
| 56 | [Python interop](56-python-interop/) | ✅ |
| 57 | [C++ interop](57-cxx-interop/) | ✅ |
| 58 | [C descriptors](58-c-descriptors/) | ✅ |
| 59 | [Library ABI](59-library-abi/) | ✅ |
| 60 | [OpenMP patterns](60-openmp-patterns/) | ✅ |
| 61 | [MPI patterns](61-mpi-patterns/) | ✅ |
| 62 | [Coarray halos](62-coarray-halos/) | ✅ |
| 63 | [`do concurrent` performance](63-do-concurrent-performance/) | ✅ |
| 64 | [Hybrid grid](64-hybrid-grid/) | ✅ |
| 65 | [GPU offload](65-gpu-offload/) | ✅ |
| 66 | [MPI-IO](66-mpi-io/) | ✅ |
| 67 | [fypp](67-fypp/) | ✅ |
| 68 | [Error library](68-error-library/) | ✅ |
| 69 | [test-drive](69-test-drive/) | ✅ |
| 70 | [fpm packaging](70-fpm-packaging/) | ✅ |
| 71 | [Continuous integration](71-ci/) | ✅ |
| 72 | [Debugging a wrong answer](72-debugging-numerics/) | ✅ |
| 73 | [Profiling](73-profiling/) | ✅ |
| 74 | [Capstone](74-capstone/) | ✅ |
| 75 | [Stacks](75-stacks/) | ✅ |
| 76 | [Arenas](76-arenas/) | ✅ |
| 77 | [Heaps](77-heaps/) | ✅ |
| 78 | [Hash maps](78-hash-maps/) | ✅ |
| 79 | [Union-find](79-union-find/) | ✅ |
| 80 | [Graphs](80-graphs/) | ✅ |
| 81 | [Sorted tables](81-sorted-tables/) | ✅ |
| 82 | [String builders](82-string-builders/) | ✅ |
| 83 | [Lexer](83-lexer/) | ✅ |
| 84 | [Parser](84-parser/) | ✅ |
| 85 | [Evaluator](85-evaluator/) | ✅ |
| 86 | [Fixed-width records](86-fixed-records/) | ✅ |
| 87 | [Use scanner](87-use-scanner/) | ✅ |
| 88 | [Derived-type dump](88-derived-dump/) | ✅ |
| 89 | [Interpolation](89-interpolation/) | ✅ |
| 90 | [Poisson](90-poisson/) | ✅ |
| 91 | [Heat](91-heat/) | ✅ |
| 92 | [Advection](92-advection/) | ✅ |
| 93 | [Conjugate gradient](93-conjugate-gradient/) | ✅ |
| 94 | [Newton systems](94-newton-systems/) | ✅ |
| 95 | [Least squares](95-least-squares/) | ✅ |
| 96 | [Richardson](96-richardson/) | ✅ |
| 97 | [Linear congruential generator](97-lcg/) | ✅ |
| 98 | [Quadrature 2D](98-quadrature-2d/) | ✅ |
| 99 | [Special functions](99-special-functions/) | ✅ |
| 100 | [Golden section](100-golden-section/) | ✅ |
| 101 | [Game of Life](101-game-of-life/) | ✅ |
| 102 | [Mandelbrot](102-mandelbrot/) | ✅ |

The remaining phases of the first continuation, a second haul in phases
75–114, and a third haul in phases 115–154 are listed in [PLAN.md](PLAN.md).
Phases 75–114 are data structures, parsers, numerical methods, small
applications, and exercises. Phases 115–154 compare the standard revisions
by compiling with each one's `-std`, then cover algorithms, more numerical
methods, design with the type system, binary data, and quality tooling.
