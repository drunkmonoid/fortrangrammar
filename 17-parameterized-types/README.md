# 17 — Parameterized Derived Types

Derived types with `kind` and `len` parameters, like `real(kind)` and
`character(len)` (F2003).

## Examples

| File | Topic |
|---|---|
| [01_kind_parameters.f90](01_kind_parameters.f90) | `integer, kind :: k`; `type(point(real64))`; per-kind generics |
| [02_len_parameters.f90](02_len_parameters.f90) | `integer, len :: n`; sized components; automatic PDT objects |
| [03_assumed_deferred.f90](03_assumed_deferred.f90) | `type(vec(*))` dummies, `type(vec(:)), allocatable`, `allocate(vec(n=5) :: x)` |
| [04_pdt_constructors.f90](04_pdt_constructors.f90) | Standard constructor/default-init syntax ⚠ rejected by gfortran 15 |

## Syntax

```fortran
type :: name(k, n)
  integer, kind :: k = real64     ! compile-time constant
  integer, len  :: n              ! run-time value allowed
  real(k) :: data(n)
end type name

type(name(real32, 10))        :: a      ! positional
type(name(k=real64, n=m))     :: b      ! keyword, run-time n
type(name(n=*))               :: dummy  ! assumed len (dummy arguments)
type(name(n=:)), allocatable  :: c      ! deferred len
allocate (name(n=100) :: c)
print *, c%n, c%k                       ! parameter inquiry
```

## Kind vs len parameters

| | `kind` | `len` |
|---|---|---|
| Value known | compile time | run time |
| Different values → | different types | same type, different sizes |
| Used for | `real(k)`, `integer(k)` components | array bounds, character lengths |
| Can be `*` / `:` | no | yes |
| Generic resolution | yes (by kind) | no |

## Compiler support (gfortran 15)

| Feature | Status |
|---|---|
| kind and len parameters, inquiry | ✅ |
| assumed `(*)`, deferred `(:)`, `allocate(t(n=..) :: x)` | ✅ |
| automatic PDT objects | ✅ |
| structure constructor `t(params)(values)` | ❌ |
| default init of a `real(k)` component | ❌ |

## Key points

- Use kind parameters to write one type for several precisions; pair them
  with a generic interface over the per-kind procedures.
- Use len parameters when sizes are fixed for an object's lifetime;
  otherwise allocatable components are simpler and better supported.
- PDT support varies between compilers more than any other F2003 feature.
