# Tooling Around Fortran

## Build and packaging

| Tool | Purpose |
|---|---|
| [fpm](https://fpm.fortran-lang.org) | Fortran Package Manager: build, run, test, dependencies ([01_fpm_project/](01_fpm_project/)) |
| [CMake](https://cmake.org) | De-facto build system for mixed-language projects ([02_cmake_project/](02_cmake_project/)) |
| Make | Hand-written dependency rules ([03_make_project/](03_make_project/)) |
| Meson | Alternative build system with Fortran support |
| Spack, conda-forge | Installing compilers, MPI, libraries on HPC systems |

## Editors and language servers

| Tool | Purpose |
|---|---|
| [fortls](https://github.com/fortran-lang/fortls) | Language server: completion, go-to-definition, hover, diagnostics |
| Modern Fortran (VS Code extension) | Syntax highlighting, linting through the compiler, fortls integration, debugging |
| Vim / Neovim / Emacs | Built-in Fortran modes, LSP clients for fortls |

## Formatting and linting

| Tool | Purpose |
|---|---|
| [fprettify](https://github.com/fortran-lang/fprettify) | Auto-formatter (indentation, whitespace, case) |
| findent | Indenter / fixed→free form converter |
| [fortitude](https://github.com/PlasmaFAIR/fortitude) | Fast linter with style and correctness rules |
| compiler warnings | `-Wall -Wextra -pedantic -std=f2023` remain the first line of defence |

## Other compilers and interpreters

| Tool | Purpose |
|---|---|
| [LFortran](https://lfortran.org) | Interactive Fortran (REPL, Jupyter kernel), also a compiler |
| LLVM Flang | Modern LLVM-based compiler (`flang`) |
| Intel ifx, NVIDIA nvfortran, AMD/HPE/NAG compilers | see [01-getting-started/compilers.md](../01-getting-started/compilers.md) |

## Continuous integration

GitHub Actions can install any of the major compilers with
[`fortran-lang/setup-fortran`](https://github.com/fortran-lang/setup-fortran):

```yaml
- uses: fortran-lang/setup-fortran@v1
  with:
    compiler: gcc
    version: 15
- run: scripts/check_all.sh
```

## Libraries worth knowing

stdlib ([07_stdlib_example.f90](07_stdlib_example.f90)), test-drive,
pFUnit, json-fortran, toml-f, LAPACK / BLAS (OpenBLAS, MKL), FFTW,
HDF5 and NetCDF Fortran APIs, PETSc, MPI (`mpi_f08`).
