# 22 — Formatted I/O

Every edit descriptor, how format specifications are assembled, and how
they interact with the data list.

## Examples

| File | Topic |
|---|---|
| [01_format_specifications.f90](01_format_specifications.f90) | Literal, variable, `format` statement, run-time formats, groups |
| [02_integer_descriptors.f90](02_integer_descriptors.f90) | `I`, `Iw.m`, `I0`, `B`, `O`, `Z`, overflow asterisks |
| [03_real_descriptors.f90](03_real_descriptors.f90) | `F`, `E`, `Ee`, `ES`, `EN`, `D`, `G`, `G0`, `G0.d` |
| [04_character_logical.f90](04_character_logical.f90) | `A`, `Aw`, `L` |
| [05_control_descriptors.f90](05_control_descriptors.f90) | `X`, `T`, `TL`, `TR`, `/`, `:` |
| [06_sign_blank_round_decimal.f90](06_sign_blank_round_decimal.f90) | `SP`/`SS`, `BN`/`BZ`, `RU`…`RP`, `DC`/`DP`, `kP` |
| [07_unlimited_and_reversion.f90](07_unlimited_and_reversion.f90) | Format reversion, `*(...)` |
| [08_g0_idioms.f90](08_g0_idioms.f90) | CSV and space-separated output with `g0` |
| [09_list_directed_details.f90](09_list_directed_details.f90) | `*` input: repeat counts, nulls, `/`, quotes |
| [10_ex_hex_float.f90](10_ex_hex_float.f90) | F2018 `EX` hex floats ⚠ not in gfortran 15 |

## Data edit descriptors

| Descriptor | Type | Notes |
|---|---|---|
| `Iw[.m]`, `I0` | integer | `.m` = minimum digits |
| `Bw[.m]`, `Ow[.m]`, `Zw[.m]` | integer (and reals on input) | binary / octal / hex |
| `Fw.d`, `F0.d` | real, complex | fixed point |
| `Ew.d[Ee]` | real | `0.ddd E±xx` |
| `ESw.d[Ee]` | real | scientific `d.ddd E±xx` |
| `ENw.d[Ee]` | real | engineering, exponent multiple of 3 |
| `EXw.d[Ee]` | real | hexadecimal significand (F2018) |
| `Dw.d` | real | legacy `D` exponent |
| `Gw.d[Ee]`, `G0`, `G0.d` | any intrinsic | general |
| `Lw` | logical | `T` / `F` |
| `A`, `Aw` | character | |
| `DT['iotype'][(v-list)]` | derived type | defined I/O (chapter 20) |

## Control and mode descriptors

| Descriptor | Effect |
|---|---|
| `nX`, `TRn` | skip right | 
| `Tn`, `TLn` | absolute column / skip left |
| `/` | next record |
| `:` | stop if no items remain |
| `'text'`, `"text"` | literal output |
| `S`, `SP`, `SS` | sign mode |
| `BN`, `BZ` | blank interpretation on input |
| `RU RD RZ RN RC RP` | rounding mode |
| `DC`, `DP` | decimal comma / point |
| `kP` | scale factor |

## Key points

- Too-narrow fields print asterisks, never truncated numbers.
- Use `I0`, `F0.d`, `G0` for minimal width; explicit widths for tables.
- `Ew.d` drops the `E` for 3-digit exponents — use `ESw.dE3`.
- `*(...)` keeps everything on one record; `:` avoids trailing separators.
- Without `*`, reversion starts a new record at the last top-level group.
- Internal files (for `read`/`write`) must be character variables.
- List-directed output is for humans; write files with explicit formats.
