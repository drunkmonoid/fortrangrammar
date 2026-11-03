# 11 — Procedures I: Subroutines, Functions, Arguments

How to write procedures and how arguments are passed. Interfaces and
generics are chapter 12; `pure`, `elemental` and `recursive` are chapter 13.

## Examples

| File | Topic |
|---|---|
| [01_subroutines.f90](01_subroutines.f90) | `subroutine`, `call`, `return` |
| [02_functions.f90](02_functions.f90) | Function forms, `result`, array and string results |
| [03_intent.f90](03_intent.f90) | `intent(in/out/inout)` and what `out` resets |
| [04_optional_arguments.f90](04_optional_arguments.f90) | `optional`, `present`, defaults idiom, recursive-I/O trap |
| [05_keyword_arguments.f90](05_keyword_arguments.f90) | `f(x, label='a')`, ordering rules |
| [06_value_attribute.f90](06_value_attribute.f90) | `value`: private copies |
| [07_internal_procedures.f90](07_internal_procedures.f90) | `contains`, host association, shadowing |
| [08_argument_aliasing.f90](08_argument_aliasing.f90) | The no-aliasing rule |

## Templates

```fortran
subroutine name(a, b, opt)
  real, intent(in)            :: a
  real, intent(out)           :: b
  integer, intent(in), optional :: opt
  ...
end subroutine name

function name(a) result(r)
  real, intent(in) :: a
  real :: r
  r = ...
end function name
```

## Intent summary

| Intent | Read on entry | Must define | Actual may be expression | Notes |
|---|---|---|---|---|
| `in` | yes | no (cannot) | yes | |
| `out` | no (undefined) | yes | no | allocatables deallocated, default init re-applied |
| `inout` | yes | may | no | |
| `value` | yes (copy) | may | yes | caller unaffected |

## Key points

- Put procedures in modules (or after `contains`) so every call is checked.
- Declare `intent` for every dummy argument.
- Functions should not have side effects; they may be evaluated fewer
  times than written.
- A function used inside an I/O statement must not do I/O on the same unit.
- Optional arguments: test with `present`, never read an absent one, use a
  local copy for defaults.
- After the first keyword argument, all remaining arguments must be keywords.
- Dummy names are part of the API when callers use keywords.
- Never pass the same (or overlapping) actual to two dummies when one is
  modified.
