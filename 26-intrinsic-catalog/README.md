# 26 — Intrinsic Procedure Catalog

The intrinsics not covered in their own chapters, plus an index of **every**
Fortran 2023 intrinsic procedure with a pointer to where it is explained.

## Examples

| File | Topic |
|---|---|
| [01_elemental_math.f90](01_elemental_math.f90) | `sqrt` … `bessel_yn`, `hypot`, `erf`, `gamma`, complex math |
| [02_degree_trigonometry.f90](02_degree_trigonometry.f90) | F2023 `sind`, `cosd`, `atan2d` … (`sinpi` family ⚠ not in gfortran 15) |
| [03_numeric_functions.f90](03_numeric_functions.f90) | `aint`, `anint`, `nint`, `floor`, `ceiling`, `mod`, `modulo`, `out_of_range` |
| [04_bit_intrinsics.f90](04_bit_intrinsics.f90) | `iand` … `merge_bits`, shifts, masks, `popcnt`, unsigned compares |
| [05_transfer_storage.f90](05_transfer_storage.f90) | `transfer`, `storage_size`, `c_sizeof` |

## A–Z index

Class: **E** elemental function · **ES** elemental subroutine ·
**I** inquiry function · **T** transformational function ·
**S** subroutine · **A** atomic subroutine · **C** collective subroutine.

| Intrinsic | Class | Purpose | Chapter |
|---|---|---|---|
| `abs` | E | absolute value / complex modulus | 26 |
| `achar` | E | character from ASCII code | 10 |
| `acos`, `acosd`¹, `acosh`, `acospi`¹ ² | E | inverse cosine (radians / degrees / ×π) | 26 |
| `adjustl`, `adjustr` | E | move blanks | 10 |
| `aimag` | E | imaginary part | 03 |
| `aint`, `anint` | E | truncate / round to whole real | 26 |
| `all`, `any` | T | logical reductions | 09 |
| `allocated` | I | allocation status | 08 |
| `asin`, `asind`¹, `asinh`, `asinpi`¹ ² | E | inverse sine | 26 |
| `associated` | I | pointer association | 21 |
| `atan`, `atan2`, `atand`¹, `atan2d`¹, `atanh`, `atanpi`¹ ², `atan2pi`¹ ² | E | inverse tangent | 26 |
| `atomic_add`, `_and`, `_or`, `_xor`, `_cas`, `_define`, `_ref`, `_fetch_add`, `_fetch_and`, `_fetch_or`, `_fetch_xor` | A | atomic operations on coarrays | 28 |
| `bessel_j0`, `_j1`, `_jn`, `_y0`, `_y1`, `_yn` | E / T | Bessel functions | 26 |
| `bge`, `bgt`, `ble`, `blt` | E | unsigned bit-pattern comparison | 26 |
| `bit_size` | I | bits in an integer kind | 26 |
| `btest` | E | test a bit | 26 |
| `ceiling` | E | round toward +∞ | 26 |
| `char` | E | character from processor code | 10 |
| `cmplx` | E | build a complex | 03 |
| `co_broadcast`, `co_max`, `co_min`, `co_reduce`, `co_sum` | C | collectives over images | 28 |
| `command_argument_count` | T | number of arguments | 24 |
| `conjg` | E | complex conjugate | 03 |
| `cos`, `cosd`¹, `cosh`, `cospi`¹ ² | E | cosine | 26 |
| `coshape` | I | coarray co-extents | 28 |
| `count` | T | count true elements | 09 |
| `cpu_time` | S | processor time | 24 |
| `cshift` | T | circular shift | 09 |
| `date_and_time` | S | calendar date and time | 24 |
| `dble` | E | convert to double precision | 03 |
| `digits` | I | model significant digits | 25 |
| `dim` | E | positive difference | 26 |
| `dot_product` | T | inner product | 09 |
| `dprod` | E | double-precision product of default reals | 26 |
| `dshiftl`, `dshiftr` | E | double-width shift | 26 |
| `eoshift` | T | end-off shift | 09 |
| `epsilon` | I | machine epsilon | 25 |
| `erf`, `erfc`, `erfc_scaled` | E | error functions | 26 |
| `event_query` | S | event count | 28 |
| `execute_command_line` | S | run a shell command | 24 |
| `exp` | E | exponential | 26 |
| `exponent` | E | model exponent | 25 |
| `extends_type_of` | I | dynamic type extension test | 20 |
| `failed_images` | T | list of failed images | 28 |
| `findloc` | T | location of a value | 09 |
| `floor` | E | round toward −∞ | 26 |
| `fraction` | E | model fraction | 25 |
| `gamma` | E | Gamma function | 26 |
| `get_command`, `get_command_argument` | S | command line | 24 |
| `get_environment_variable` | S | environment | 24 |
| `get_team` | T | current/parent/initial team | 28 |
| `huge` | I | largest model number | 25 |
| `hypot` | E | Euclidean distance | 26 |
| `iachar` | E | ASCII code | 10 |
| `iall`, `iany`, `iparity` | T | bitwise reductions | 09 |
| `iand`, `ior`, `ieor` | E | bitwise logic | 26 |
| `ibclr`, `ibset`, `ibits` | E | clear / set / extract bits | 26 |
| `ichar` | E | processor character code | 10 |
| `image_index`, `image_status` | I / E | coarray images | 28 |
| `index` | E | find substring | 10 |
| `int` | E | convert to integer | 03 |
| `is_contiguous` | I | contiguity | 08 |
| `is_iostat_end`, `is_iostat_eor` | E | I/O status tests | 23 |
| `ishft`, `ishftc` | E | logical / circular shift | 26 |
| `kind` | I | kind value | 03 |
| `lbound`, `ubound` | I | bounds | 07 |
| `lcobound`, `ucobound` | I | cobounds | 28 |
| `leadz`, `trailz` | E | leading / trailing zero bits | 26 |
| `len`, `len_trim` | I / E | string length | 10 |
| `lge`, `lgt`, `lle`, `llt` | E | ASCII comparison | 10 |
| `log`, `log10`, `log_gamma` | E | logarithms | 26 |
| `logical` | E | convert logical kind | 03 |
| `maskl`, `maskr` | E | bit masks | 26 |
| `matmul` | T | matrix product | 09 |
| `max`, `min` | E | maximum / minimum | 26 |
| `maxexponent`, `minexponent` | I | exponent range | 25 |
| `maxloc`, `minloc` | T | location of extreme | 09 |
| `maxval`, `minval` | T | extreme value | 09 |
| `merge` | E | elemental choice | 09 |
| `merge_bits` | E | merge bit patterns | 26 |
| `mod`, `modulo` | E | remainders | 26 |
| `move_alloc` | S | move an allocation | 08 |
| `mvbits` | ES | copy bit field | 26 |
| `nearest` | E | next representable number | 25 |
| `new_line` | I | newline character | 10 |
| `nint` | E | round to integer | 26 |
| `norm2` | T | Euclidean norm | 09 |
| `not` | E | bitwise complement | 26 |
| `null` | T | disassociated pointer | 21 |
| `num_images`, `this_image` | T | image count / index | 28 |
| `out_of_range` | E | conversion would overflow? | 26 |
| `pack`, `unpack` | T | gather / scatter by mask | 09 |
| `parity` | T | logical XOR reduction | 09 |
| `popcnt`, `poppar` | E | bit count / parity | 26 |
| `precision` | I | decimal precision | 25 |
| `present` | I | optional argument present? | 11 |
| `product`, `sum` | T | reductions | 09 |
| `radix`, `range` | I | model base / exponent range | 25 |
| `random_init`, `random_number`, `random_seed` | S | random numbers | 24 |
| `rank` | I | array rank | 07 |
| `real` | E | convert to real | 03 |
| `reduce` | T | user-defined reduction | 09 |
| `repeat` | T | repeat a string | 10 |
| `reshape` | T | change shape | 09 |
| `rrspacing` | E | reciprocal relative spacing | 25 |
| `same_type_as` | I | same dynamic type? | 20 |
| `scale`, `set_exponent` | E | scale by radix powers | 25 |
| `scan`, `verify` | E | character set search | 10 |
| `selected_char_kind`, `selected_int_kind`, `selected_logical_kind`¹, `selected_real_kind` | T | choose kinds | 03 |
| `shape`, `size` | I | extents | 07 |
| `shifta`, `shiftl`, `shiftr` | E | shifts | 26 |
| `sign` | E | transfer sign | 26 |
| `sin`, `sind`¹, `sinh`, `sinpi`¹ ² | E | sine | 26 |
| `spacing` | E | ULP | 25 |
| `split`¹ ² | S | incremental tokenising | 10 |
| `spread` | T | replicate along a dimension | 09 |
| `sqrt` | E | square root | 26 |
| `stopped_images` | T | list of stopped images | 28 |
| `storage_size` | I | size in bits | 26 |
| `system_clock` | S | wall clock | 24 |
| `tan`, `tand`¹, `tanh`, `tanpi`¹ ² | E | tangent | 26 |
| `team_number` | T | team identifier | 28 |
| `tiny` | I | smallest normal number | 25 |
| `tokenize`¹ ² | S | split into tokens | 10 |
| `transfer` | T | reinterpret bits | 26 |
| `transpose` | T | transpose | 09 |
| `trim` | T | drop trailing blanks | 10 |

¹ new in Fortran 2023. ² not yet implemented in gfortran 15.

Module procedures that feel like intrinsics: `compiler_version`,
`compiler_options` (`iso_fortran_env`, ch. 01); `c_loc`, `c_funloc`,
`c_f_pointer`, `c_associated`, `c_sizeof` … (`iso_c_binding`, ch. 27);
the `ieee_*` procedures (ch. 25).

## Key points

- Almost every numeric intrinsic is elemental and generic over kinds.
- Pass `kind=` to conversion functions whose result kind matters.
- Bit positions count from 0 at the least significant bit.
- `transfer` reinterprets bits; it never converts values.
- F2023 degree trig is exact at common angles.
