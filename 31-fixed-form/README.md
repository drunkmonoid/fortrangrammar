# 31 — Fixed Form and Old Declarations

The layout and declaration spellings that Fortran 77 code still uses. Both
are obsolescent. gfortran 15 accepts them under `-std=f2023 -pedantic` and
warns. The GNU extension `real*8` is rejected by those flags; it is named
here and not used.

## Examples

| File | Topic |
|---|---|
| [01_fixed_form.f](01_fixed_form.f) | Columns, labels, continuation, `C` comments |
| [02_old_declarations.f90](02_old_declarations.f90) | `double precision`, `character*`, statement `parameter` and `dimension` |

## Fixed form

gfortran selects the source form from the file extension. `.f`, `.for` and
`.ftn` are fixed form. `.f90` is free form (chapter 02), whatever the
digits in the extension suggest.

| Columns | Contents |
|---|---|
| 1–5 | Statement label, or `C`, `c`, `*` or `!` for a whole-line comment |
| 6 | Blank or `0`: this line starts a statement. Any other character continues the previous statement |
| 7–72 | The statement |
| 73 onwards | Ignored. `-Wall` warns that the line was truncated |

Free form has no columns. Continue a statement with `&` at the end of the
line.

## Old declarations

| Old spelling | Modern spelling | Chapter |
|---|---|---|
| `double precision x` | `real(real64) :: x` | 03 |
| `character*11 s` | `character(len=11) :: s` | 10 |
| `integer n` / `parameter (n = 3)` | `integer, parameter :: n = 3` | 04 |
| `dimension a(3)` | `integer :: a(3)` | 04, 07 |

`double precision` is still standard; it means `real(kind(0.0d0))`. The
other three rows warn as obsolescent.
