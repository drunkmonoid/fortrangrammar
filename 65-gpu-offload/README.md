# 65 — GPU Offload

Modern OpenMP (versions 4.5, 5.0, 5.2) supports heterogeneous computing by offloading
compute-intensive loops to attached accelerators (GPUs) through `target` constructs.

This chapter demonstrates:
- The standard `!$omp target teams distribute parallel do` worksharing idiom
- Directional memory mappings:
  - `map(to: x)`: Copies host array `x` to device memory before kernel execution
  - `map(tofrom: y)`: Copies `y` to device before kernel execution and back to host upon completion
  - `map(from: ...)` / `map(alloc: ...)`: Device-only allocation and retrieval
- Fallback behavior: When an offload target device is unavailable or unconfigured,
  the OpenMP runtime executes the target region directly on the host CPU.

## Compilation for discrete accelerators

| Vendor / Compiler | Flags |
|---|---|
| NVIDIA (`nvfortran`) | `-mp=gpu -gpu=cc80` |
| Intel (`ifx`) | `-fiopenmp -fopenmp-targets=spir64` |
| AMD (`amdflang`) | `-fopenmp --offload-arch=gfx90a` |
| GCC (`gfortran`) | `-fopenmp -foffload=nvptx-none` |

## Examples

| File | Topic |
|---|---|
| [01_saxpy_target.f90](01_saxpy_target.f90) | OpenMP target map offload on a SAXPY kernel |
