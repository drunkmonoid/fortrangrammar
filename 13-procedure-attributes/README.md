# 13 — Procedure Attributes and Scoping

`pure`, `elemental`, `impure`, `recursive`, `simple`, how names are found
(host association), and `import`.

## Examples

| File | Topic |
|---|---|
| [01_pure.f90](01_pure.f90) | `pure` rules and benefits |
| [02_pure_violation.f90](02_pure_violation.f90) | Everything `pure` forbids (must fail to compile) |
| [03_elemental.f90](03_elemental.f90) | `elemental` functions and subroutines |
| [04_impure_elemental.f90](04_impure_elemental.f90) | `impure elemental` (F2008) |
| [05_recursive.f90](05_recursive.f90) | `recursive`, `result`, recursive types; `non_recursive` ⚠ |
| [06_simple_procedures.f90](06_simple_procedures.f90) | F2023 `simple` ⚠ not in gfortran 15 |
| [07_host_association.f90](07_host_association.f90) | Scoping units, hiding, module/host/block scope |
| [08_import.f90](08_import.f90) | `import`, `import :: names` in interface bodies |
| [09_import_f2018.f90](09_import_f2018.f90) | `import, only/none/all` ⚠ not in gfortran 15 |
| [10_procedure_prefixes.f90](10_procedure_prefixes.f90) | Combining prefixes and `bind(c)` |

## Purity ladder

| Attribute | Side effects | Reads globals | Callable from `do concurrent` |
|---|---|---|---|
| (none) / `impure` | allowed | yes | no |
| `pure` | none (checked) | yes | yes |
| `simple` (F2023) | none | **no** — arguments only | yes |

`elemental` implies `pure` unless `impure elemental` is written.

## `pure` checklist

- Function dummies `intent(in)` (or `value`); subroutine dummies have intent.
- No assignment to module, host or common variables.
- No `save` and no initialised locals (initialisation implies `save`).
- No external I/O (internal files are fine), no `stop` (`error stop` is OK).
- Only `pure` procedures may be called.

## Compiler support (gfortran 15)

| Feature | Standard | gfortran 15 |
|---|---|---|
| `pure`, `elemental`, `recursive` | F95 | ✅ |
| `impure elemental` | F2008 | ✅ |
| `import`, `import :: list` | F2003 | ✅ |
| recursive by default | F2018 | partly — write `recursive` explicitly |
| `non_recursive` | F2018 | ❌ |
| `import, only/none/all`, `import` in blocks | F2018 | ❌ |
| `simple` | F2023 | ❌ |

## Key points

- Mark everything `pure` that can be.
- Elemental procedures take scalars and work on any conforming arrays.
- Recursive functions need `result(r)`.
- A local declaration hides a host entity in the whole scope.
- Interface bodies need `import` to see the host's types and kinds.
