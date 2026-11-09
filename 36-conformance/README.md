# 36 — Conformance

A program can compile and still have no meaning under the standard. This
chapter records what gfortran 15, with the tutorial's default
`-fcheck=all`, actually does about four cases. Argument aliasing and a
mismatched `common` block already have their own files.

## Examples

| File | Topic |
|---|---|
| [01_allocation_status.f90](01_allocation_status.f90) | Ask `allocated` before using an allocatable |
| [02_unallocated_reference.f90](02_unallocated_reference.f90) | The reference without that test. Compiled, not run |
| [03_sequence_association.f90](03_sequence_association.f90) | Passing an element to an assumed-size dummy |

## What the default flags catch

| Situation | gfortran 15, `-fcheck=all` | Where |
|---|---|---|
| Index past the bounds | Runtime error, exit status 2 | [chapter 30](../30-ecosystem/06_runtime_checks.f90) |
| Reference of an unallocated allocatable | Segmentation fault. The bounds check reads a descriptor that was never set | `02_unallocated_reference.f90` |
| Argument aliasing | Not diagnosed. The result is undefined | [chapter 11](../11-procedures-basics/08_argument_aliasing.f90) |
| `common` blocks of different sizes | Warning at compile time, then it runs | [chapter 32](../32-storage-association/02_common_mismatch.f90) |
| Stride passed to `b(*)` | Accepted. An array temporary is copied, and a runtime warning is printed | `03_sequence_association.f90` |

`-fcheck=all` is not a proof of conformance. It catches the cases the
compiler can see at run time.
