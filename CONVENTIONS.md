# Conventions

## Layout

```
NN-topic/
  README.md             explanation of the chapter, links to every example
  MM_subtopic.f90       one standalone program per subtopic
  MM_subtopic/          multi-file example (modules, C interop, ...)
    build.sh            builds and runs it (see below)
```

Every `.f90` file at the top of a chapter directory is a complete program that
can be compiled on its own. Files are numbered in reading order.

## Language level

All examples target **Fortran 2023** and are compiled with

```
gfortran -std=f2023 -Wall -Wextra -pedantic -fcheck=all -g -fbacktrace
```

`-std=f2023` rejects vendor extensions, so anything that compiles here is
standard Fortran. Features that the standard defines but gfortran does not yet
implement are still documented; those files are marked `@build skip` with the
reason.

## Build directives

A comment line of the form `! @key value` near the top of a file tells the
scripts how to treat it:

| Directive | Meaning |
|---|---|
| `! @build fail` | Must **fail** to compile (demonstrates a compile-time error) |
| `! @build skip <reason>` | Not compiled (e.g. compiler lacks the feature, MPI not installed) |
| `! @flags <flags>` | Extra compiler flags (e.g. `-fopenmp`, `-fcoarray=single`) |
| `! @run no` | Compile only, do not run |
| `! @exit <n>` | Program is expected to terminate with exit status `n` |
| `! @args <args>` | Command-line arguments passed when run by `check_all.sh` |

## Multi-file examples

A subdirectory containing `build.sh` is a multi-file example. The script is
called with these environment variables set and must exit non-zero on failure
(exit status 77 means "skipped": a required tool is missing; the last line
printed is shown as the reason):

| Variable | Meaning |
|---|---|
| `FC` | Fortran compiler |
| `FFLAGS` | Standard flags (above) |
| `OUT` | Empty directory to put objects, `.mod` files and executables in |

## Style

- Free source form, lowercase keywords, two-space indentation.
- `implicit none (type, external)` in every program unit, unless the file is
  about implicit typing.
- `use, intrinsic ::` for intrinsic modules, always with `only:`.
- Named `end` statements: `end program hello`, `end subroutine swap`.
- Comments explain *why* and *what the rule is*; output the program prints is
  shown in a trailing `! Output:` block when it is deterministic.
