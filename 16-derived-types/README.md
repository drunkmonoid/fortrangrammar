# 16 — Derived Types

User-defined types: components, initialisation, constructors,
encapsulation and memory layout. Type-bound procedures and inheritance are
chapters 18–19; type parameters are chapter 17.

## Examples

| File | Topic |
|---|---|
| [01_type_definition.f90](01_type_definition.f90) | Components, default init, nesting, `%`, arrays of types |
| [02_structure_constructors.f90](02_structure_constructors.f90) | Positional/keyword constructors, custom constructors |
| [03_component_accessibility.f90](03_component_accessibility.f90) | `private` components, public/private types |
| [04_allocatable_components.f90](04_allocatable_components.f90) | Deep copy, auto-deallocation, recursive allocatable lists |
| [05_sequence_and_bind_c.f90](05_sequence_and_bind_c.f90) | `sequence`, `bind(c)` layouts |
| [06_assignment_and_equality.f90](06_assignment_and_equality.f90) | Free assignment, user-defined `==` |
| [07_aos_vs_soa.f90](07_aos_vs_soa.f90) | Array of structures vs structure of arrays |

## Syntax

```fortran
type [, public | private] [, bind(c)] [, extends(parent)] [, abstract] :: name
  [private | sequence]
  type-spec [, attributes] :: component [= default]
contains
  procedure :: binding          ! chapter 18
end type name

type(name) :: obj
obj = name(comp1=..., comp2=...)
obj%comp1
```

## Component attributes

| Attribute | Allowed | Notes |
|---|---|---|
| `dimension` / shape | yes | explicit shape needs constant bounds (or `len` parameters) |
| `allocatable` | yes | deep-copied, auto-freed, may be of the same type |
| `pointer` | yes | shallow copy, never auto-freed |
| `public` / `private` | yes | per component |
| `contiguous` | yes (pointer arrays) | |
| `codimension` | yes (allocatable) | chapter 28 |
| default init `= value` | yes | does **not** imply `save` |

## Key points

- Define types in modules so all users share one definition.
- Default initialisation gives every new object known values.
- Omitted constructor arguments take their default values.
- A generic with the type's name acts as a custom constructor.
- Private components enforce invariants; provide procedures for access.
- Assignment is free and deep for allocatables; `==` must be defined.
- `aos%x` is a valid (strided) array, handy but not contiguous.
