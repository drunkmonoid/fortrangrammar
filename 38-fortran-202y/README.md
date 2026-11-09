# 38 — Fortran 202Y

The next revision is the Fortran 2028 working draft, J3/26-007r1
(3 March 2026). Templates are the part this chapter shows. gfortran 15.2
does not accept them, so the example is `@build skip`. The spelling below
is the draft's, including J3/26-158, which writes a deferred-argument list
in braces. It is not a private syntax, and it is not the parentheses form
LFortran used before that paper.

A deferred or instantiation argument list is `{...}`. An ordinary dummy
argument list stays `(...)`.

```fortran
requirement has_plus {t, plus}
  deferred type :: t
  deferred interface
    function plus(x, y) result(z)
      type(t), intent(in) :: x, y
      type(t) :: z
    end function
  end interface
end requirement

template adder {t, plus}
  require has_plus {t, plus}
contains
  subroutine add(x, y, z)
    ...
  end subroutine
end template

instantiate :: adder {t = integer, plus = plus_int}, only: add
```

`require` and `instantiate` may omit the `::`. A templated subprogram is
a separate form, `template subroutine swap{u} (x, y)`, and a call site
can instantiate it inline as `call swap{integer}(a, b)`.

Refresh the skip reason when a compiler in the portability matrix
(chapter 37) accepts this file.

## Examples

| File | Topic |
|---|---|
| [01_template.f90](01_template.f90) | A requirement, a template, and an inline templated subroutine |
