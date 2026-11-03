# Fortran Grammar

A comprehensive, example-driven tutorial of **modern Fortran (Fortran 2023)**:
every part of the language and the technologies around it, one topic per file.

- Every example is a small, complete, heavily commented program.
- Every example compiles with `gfortran -std=f2023 -pedantic`, so it is
  standard Fortran, not a vendor dialect.
- Each chapter has a `README.md` summarising the rules and linking its files.

See [PLAN.md](PLAN.md) for the full roadmap and [CONVENTIONS.md](CONVENTIONS.md)
for file layout and build directives.

## Quick start

```sh
scripts/run.sh 01-getting-started/01_hello_world.f90   # build + run one example
scripts/check_all.sh                                   # build + run everything
scripts/check_all.sh 01-getting-started                # one chapter
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
| 12 | Procedures II: interfaces and generics | planned |
| 13 | Procedure attributes and scoping | planned |
| 14 | Modules | planned |
| 15 | Submodules | planned |
| 16 | Derived types | planned |
| 17 | Parameterized derived types | planned |
| 18 | OOP I: extension and polymorphism | planned |
| 19 | OOP II: abstract types, generics, finalization | planned |
| 20 | Unlimited polymorphism and defined I/O | planned |
| 21 | Pointers | planned |
| 22 | Formatted I/O | planned |
| 23 | File I/O | planned |
| 24 | Errors and the environment | planned |
| 25 | Numeric model and IEEE arithmetic | planned |
| 26 | Intrinsic procedure catalog | planned |
| 27 | C interoperability | planned |
| 28 | Native parallelism: `do concurrent`, coarrays | planned |
| 29 | Parallel ecosystem: OpenMP, OpenACC, MPI | planned |
| 30 | Ecosystem: fpm, CMake, testing, tooling | planned |
