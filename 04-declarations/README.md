# 04 — Declarations and Attributes

How to declare variables and constants, what every attribute means, and the
F2023 additions for enumerations and type inference.

## Examples

| File | Topic |
|---|---|
| [01_declaration_syntax.f90](01_declaration_syntax.f90) | `type-spec, attrs :: entities`, per-entity overrides |
| [02_attributes_catalog.f90](02_attributes_catalog.f90) | Every attribute in one working module |
| [03_attribute_statements.f90](03_attribute_statements.f90) | `dimension a(3)`, `parameter (n=3)`, `save :: x` … |
| [04_named_constants.f90](04_named_constants.f90) | `parameter`, constant expressions, implied-shape `(*)` |
| [05_implied_save.f90](05_implied_save.f90) | Initialisation implies `save` |
| [06_volatile.f90](06_volatile.f90) | `volatile` |
| [07_enum_bind_c.f90](07_enum_bind_c.f90) | `enum, bind(c)` (C-compatible integer constants) |
| [08_enumeration_type.f90](08_enumeration_type.f90) | F2023 `enumeration type` ⚠ not in gfortran 15 |
| [09_typeof_classof.f90](09_typeof_classof.f90) | F2023 `typeof` / `classof` ⚠ not in gfortran 15 |
| [10_data_statement.f90](10_data_statement.f90) | `data` statements (reading older code) |

## Grammar

```
type-spec [, attr-spec]... :: entity-decl [, entity-decl]...

entity-decl  ->  name [(array-spec)] [[coarray-spec]] [*char-length] [= constant-expr]
             |   name [(array-spec)] => null()  |  => initial-data-target
```

## Attributes

| Attribute | Applies to | Notes |
|---|---|---|
| `parameter` | constants | value is a constant expression |
| `dimension(...)` | arrays | or put the shape on the entity: `a(3)` |
| `allocatable` | variables | run-time size; auto-deallocated |
| `pointer` / `target` | variables | pointer association |
| `contiguous` | array pointers, assumed shape | promises contiguity |
| `intent(in/out/inout)` | dummy args | |
| `optional` | dummy args | test with `present()` |
| `value` | dummy args | private copy |
| `save` | locals | persists between calls; implied by initialisation |
| `volatile` | variables | always reload from memory |
| `asynchronous` | variables | async I/O, non-blocking communication |
| `public` / `private` | module entities | |
| `protected` | module variables | read-only outside the module |
| `external` / `intrinsic` | procedures | |
| `bind(c[, name=])` | variables, procedures, types | C interop |
| `codimension[...]` | coarrays | |

## Initialisation vs assignment

```fortran
subroutine s()
  integer :: a = 0      ! ONCE, at program start; implies SAVE
  integer :: b
  b = 0                 ! every call
end subroutine
```

## Enumerations

| | `enum, bind(c)` (F2003) | `enumeration type` (F2023) |
|---|---|---|
| Creates a type | no — plain integers | yes |
| Explicit values | yes (`red = 1`) | no |
| Mixing with integers | silently allowed | compile error |
| Ordinal / iteration | arithmetic | `int()`, `next()`, `previous()`, `huge()` |
| Use case | C interop | type-safe program logic |

## Key points

- Always write `::`; put attributes on the declaration.
- Every initialised local is `save`d. To reset per call, assign in the
  execution part.
- Constant expressions may call most intrinsics, never user functions.
- Use `(*)` implied shape and `len=*` for constants so sizes follow values.
- `data` works but declaration initialisers are clearer.
