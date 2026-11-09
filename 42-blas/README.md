# 42 — BLAS

`dgemv` and `dgemm` through the Fortran BLAS interface. The arrays are
column-major, the same layout as chapter 07. `lda` is the leading
dimension: the number of rows stored, which here equals the number of
rows used.

`trans` is `'n'` for no transpose. A transpose call would swap the roles
of the two dimensions and read down a row, which is a stride of `lda`.

`build.sh` asks `pkg-config` for the link line and falls back to
`-lblas`. It exits 77 when the library is not installed. A triple loop
in the same program prints the same matrix, so a wrong leading dimension
fails the run instead of matching by accident.

## Examples

| File | Topic |
|---|---|
| [01_gemv_gemm/](01_gemv_gemm/) | `dgemv` and `dgemm` beside a triple loop |
