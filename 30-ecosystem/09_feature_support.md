# Feature Support: gfortran 15.2

Every standard feature this tutorial exercises, and whether gfortran 15.2
(the compiler used to verify the repository) accepts it. Entries come
from actually compiling the examples, not from documentation.

✅ works · ⚠ works with a caveat · ❌ rejected (example marked `@build skip`)

## Fortran 2023

| Feature | Status | Example |
|---|---|---|
| Line length 10 000 / statement 1 000 000 | ⚠ default still 132; use `-ffree-line-length-none` | 02 |
| `selected_logical_kind`, `logical8`… names | ✅ | 03/04 |
| BOZ constants in initialisations, typed array constructors | ❌ | 03/08 |
| `enumeration type` | ❌ | 04/08 |
| `typeof`, `classof` | ❌ | 04/09 |
| Conditional expressions `( c ? a : b )`, conditional arguments | ❌ | 05/08 |
| `split`, `tokenize` | ❌ | 10/09 |
| `simple` procedures | ❌ | 13/06 |
| `L0` edit descriptor | ❌ ("zero width after L descriptor") | 22/04 |
| `do concurrent … reduce(op: var)` | ✅ | 28/03 |
| `sind`, `cosd`, `tand`, `asind`, `acosd`, `atand`, `atan2d` | ✅ | 26/02 |
| `sinpi`, `cospi`, `tanpi`, `asinpi`, `acospi`, `atanpi`, `atan2pi` | ❌ | 26/02 |
| `ieee_max`, `ieee_min`, `ieee_max_mag`, `ieee_min_mag` | ❌ | 25/06 |
| `f_c_string` | ✅ | 27/05 |
| `c_f_strpointer` | ❌ (documented only) | 27/05 |
| `c_f_pointer(..., lower=)` | documented only | 27/07 |

## Fortran 2018

| Feature | Status | Example |
|---|---|---|
| `implicit none (type, external)` | ✅ | 01 |
| Assumed rank `(..)`, `select rank` | ✅ | 08/10 |
| `is_contiguous`, `rank` intrinsic | ✅ | 08/11, 07/01 |
| `reduce` intrinsic | ✅ | 09/07 |
| `error stop` in pure procedures, `stop … quiet=` | ✅ | 06/07–08 |
| `non_recursive`; recursion by default | ❌ / ⚠ write `recursive` | 13/05 |
| `import, only / none / all`, `import` in blocks | ❌ | 13/09 |
| `do concurrent` locality `local`, `local_init`, `shared`, `default(none)` | ✅ | 28/02 |
| `integer ::` type-spec in `do concurrent` header (F2008) | ❌ | 28/01 |
| `EX` edit descriptor | ❌ | 22/10 |
| `ieee_fma`, `ieee_signbit`, `ieee_max_num`…, quiet/signaling compares | ✅ | 25/06 |
| `ieee_rint(x, round)`, `ieee_real`, `ieee_int`, `ieee_next_up/down` | ❌ | 25/05–06 |
| `random_init` | ✅ | 24/07 |
| `out_of_range` | ✅ | 26/03 |
| Collectives, events, teams, failed images | ✅ / ⚠ teams end the program under `-fcoarray=single` | 28 |
| C descriptors (`ISO_Fortran_binding.h`) | ✅ | 27/08 |

## Fortran 2003 / 2008 areas with caveats

| Feature | Status | Example |
|---|---|---|
| Parameterized derived types: kind/len parameters, inquiry, `(*)`, `(:)` | ✅ | 17/01–03 |
| PDT structure constructor `t(k)(…)`, default init of `real(k)` components | ❌ | 17/04 |
| Arrays of types with `class(*)` components: growing via constructor or `move_alloc` of character values | ⚠ crashes / loses length | 20/03 |
| `allocate (x, source=y)` with `class(*)` x, y under `-fcheck=bounds` + `-O2` or sanitizers | ⚠ segfault; polymorphic assignment `x = y` works | 20/03 |
| `ieee_rint` under directed rounding | ⚠ results differ from IEEE | 25/05 |
| Internal procedures as actual arguments | ⚠ needs an executable stack (linker warning) | 12/03 |

## Other compilers

Support differs widely between compilers and versions, especially for
F2023 features, PDTs and coarray teams. Check before relying on a feature:

- the release notes of your compiler version;
- the compiler-support tables on the [Fortran Wiki](https://fortranwiki.org/fortran/show/Fortran+2023)
  and [fortran-lang.org](https://fortran-lang.org/compilers/);
- or simply run `FC=yourcompiler FFLAGS=... scripts/check_all.sh` on this
  repository — the `@build skip` files are the ones to try.
