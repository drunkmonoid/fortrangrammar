# 21 — Pointers

Aliases, views of arrays, linked structures — and the memory-safety rules
that come with them.

## Examples

| File | Topic |
|---|---|
| [01_pointer_basics.f90](01_pointer_basics.f90) | `pointer`, `target`, `=>` vs `=`, `associated`, `nullify`, `null()` |
| [02_allocate_pointers.f90](02_allocate_pointers.f90) | `allocate`/`deallocate` through pointers, leaks, dangling pointers |
| [03_array_pointers.f90](03_array_pointers.f90) | Section pointers, `p(0:) => a`, rank remapping `m(1:3,1:4) => v` |
| [04_linked_list.f90](04_linked_list.f90) | Doubly linked list, cleanup in a `final` procedure |
| [05_pointer_vs_allocatable.f90](05_pointer_vs_allocatable.f90) | Deep vs shallow copy; when to use which |
| [06_pointer_results_and_targets.f90](06_pointer_results_and_targets.f90) | Pointer functions (also on the LHS), `target` dummies |

## Statements and intrinsics

| Form | Meaning |
|---|---|
| `real, pointer :: p => null()` | declare + initialise (always do this) |
| `real, target :: x` | may be pointed to |
| `p => x` | pointer assignment |
| `p = 1.0` | assigns to the target |
| `p(lo:) => a` | set lower bounds |
| `m(1:n, 1:k) => v` | rank remapping (F2008) |
| `associated(p [, t])` | association test |
| `nullify(p)` / `p => null()` | disassociate |
| `allocate(p)` / `deallocate(p)` | create / free an anonymous target |
| `procedure(f), pointer :: fp` | procedure pointer (chapter 12) |

## Key points

- Pointers start **undefined** unless initialised with `=> null()`.
- Only `target`s (and other pointers' targets) may be pointed to.
- Nothing frees pointer targets for you; every `allocate` needs exactly one
  `deallocate`, through a pointer to the whole object.
- Copying a type with pointer components copies the pointers (shallow).
- A pointer to a local, or to a `target` dummy whose actual was not a
  target, dangles after return.
- Prefer allocatables for ownership; use pointers for views, sharing and
  cyclic structures.
