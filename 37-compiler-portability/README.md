# 37 — Compiler Portability

The same repository, three compilers. [compiler_matrix.sh](compiler_matrix.sh)
runs `scripts/check_all.sh` for each of `gfortran`, `ifx` and `flang` that
is on `PATH`, and skips the ones that are not. It does not fail the
shell when a compiler is missing.

Flag equivalents are in [compilers.md](../01-getting-started/compilers.md).
The script passes a standard-conformance flag and turns warnings on. It
does not pass `-fcheck=all`: that spelling is gfortran's, and the point
of this chapter is the compiler's own flags.

```sh
37-compiler-portability/compiler_matrix.sh
```

A compiler that rejects an obsolescent feature gfortran only warns
about, or that rejects a file marked `@build fail` for a different
reason, shows up as a failed chapter. `@build skip` files stay skipped.
The feature table for gfortran 15 is
[09_feature_support.md](../30-ecosystem/09_feature_support.md); add a
column there from a real run of this script, not from a release note.
