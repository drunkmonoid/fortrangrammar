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
| 44 | [Sparse matrices](44-sparse/) | ✅ |
| 45 | [Quadrature and roots](45-quadrature/) | ✅ |
| 46 | [ODEs](46-ode/) | ✅ |
| 49 | [Generic kernels](49-generic-kernels/) | ✅ |
| 50 | [CSV](50-csv/) | ✅ |
| 51 | [Configuration](51-configuration/) | ✅ |
| 60 | [OpenMP patterns](60-openmp-patterns/) | ✅ |
| 63 | [`do concurrent` performance](63-do-concurrent-performance/) | ✅ |
| 68 | [Error library](68-error-library/) | ✅ |
| 71 | [Continuous integration](71-ci/) | ✅ |
| 72 | [Debugging a wrong answer](72-debugging-numerics/) | ✅ |
| 73 | [Profiling](73-profiling/) | ✅ |

The remaining phases of the first continuation, and a second haul in
phases 75–114, are listed in [PLAN.md](PLAN.md). Phases 75–114 are data
structures, parsers, numerical methods, small applications, and exercises.
