# 27 — C Interoperability

Standard, portable mixing of Fortran and C (F2003, extended in F2018 and
F2023). Multi-file examples are built with `gcc` + `gfortran`.

## Examples

| File / directory | Topic |
|---|---|
| [01_c_kinds.f90](01_c_kinds.f90) | `iso_c_binding` kinds and character constants |
| [02_interoperable_types.f90](02_interoperable_types.f90) | `bind(c)` structs, `enum, bind(c)`, `c_sizeof` |
| [03_call_c_from_fortran/](03_call_c_from_fortran/) | `bind(c)` interfaces, `value`, arrays, column-major vs row-major |
| [04_call_fortran_from_c/](04_call_fortran_from_c/) | Exporting procedures and a global variable to a C `main` |
| [05_strings/](05_strings/) | NUL-terminated strings both ways, `f_c_string` (F2023) |
| [06_callbacks/](06_callbacks/) | `c_funloc`: Fortran comparator for `qsort`, callbacks from C |
| [07_c_pointers.f90](07_c_pointers.f90) | `c_ptr`, `c_loc`, `c_f_pointer`, `malloc`/`free` from Fortran |
| [08_array_descriptors/](08_array_descriptors/) | `ISO_Fortran_binding.h`: assumed-shape/rank and allocatable dummies in C |

Run a directory with `scripts/run.sh 27-c-interop/05_strings/`.

## Type mapping

| C | Fortran |
|---|---|
| `int`, `long`, `long long`, `short` | `integer(c_int)`, `c_long`, `c_long_long`, `c_short` |
| `size_t`, `intptr_t`, `int32_t` … | `integer(c_size_t)`, `c_intptr_t`, `c_int32_t` … |
| `float`, `double`, `long double` | `real(c_float)`, `c_double`, `c_long_double` |
| `float _Complex` … | `complex(c_float_complex)` … |
| `_Bool` | `logical(c_bool)` |
| `char` | `character(kind=c_char)` |
| `T x` (by value) | `type, value :: x` |
| `T *x` | `type :: x` (scalar) or `x(*)` (array) |
| `void *` | `type(c_ptr), value` |
| `T (*f)(…)` | `type(c_funptr), value` |
| `struct S` | `type, bind(c) :: s` |
| `enum` | `enum, bind(c)` |
| global `extern T g;` | `T, bind(c, name='g') :: g` in a module |
| `CFI_cdesc_t *` | assumed-shape `a(:)`, assumed-rank `a(..)`, allocatable/pointer dummies, `type(*)`, `character(*)` |

## Procedures in `iso_c_binding`

| Procedure | Purpose |
|---|---|
| `c_loc(x)`, `c_funloc(p)` | C address of a target / procedure |
| `c_f_pointer(cptr, fptr [, shape] [, lower])` | Fortran pointer to C data |
| `c_f_procpointer(cfunptr, fproc)` | Fortran procedure pointer from C function pointer |
| `c_associated(c1 [, c2])` | non-null / equal test |
| `c_sizeof(x)` | size in bytes |
| `f_c_string(s [, asis])` (F2023) | Fortran string → NUL-terminated |
| `c_f_strpointer(cstr, fstrptr [, nchars])` (F2023) | C string → Fortran pointer (not in gfortran 15) |

## Key points

- Every boundary procedure gets `bind(c, name='exact_symbol')`.
- C by-value parameters need `value`; everything else is passed by address.
- Fortran arrays are column-major: `m(i, j)` is `m[i + j*rows]` in C.
- Strings: append `c_null_char` going to C; find it coming back.
- Callbacks called from C must themselves be `bind(c)`.
- Interface bodies need their own `implicit none`; declare bounds first.
- Descriptors (`ISO_Fortran_binding.h`) let C handle strided, allocatable
  and assumed-rank Fortran arrays without copies.
- Link with the Fortran compiler (or add the Fortran runtime library).
