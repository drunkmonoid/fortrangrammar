# 10 — Characters and Strings

Fixed, assumed and deferred lengths, substrings, the character intrinsics,
number conversion, Unicode, and F2023 tokenising.

## Examples

| File | Topic |
|---|---|
| [01_fixed_and_deferred_length.f90](01_fixed_and_deferred_length.f90) | `len=10`, `len=*`, `len=:`, ragged string arrays |
| [02_substrings.f90](02_substrings.f90) | `s(i:j)`, zero-length, substrings of array elements |
| [03_concatenation_comparison.f90](03_concatenation_comparison.f90) | `//`, `==` with padding, `lge`/`lgt`/`lle`/`llt` |
| [04_length_trim_adjust.f90](04_length_trim_adjust.f90) | `len`, `len_trim`, `trim`, `adjustl`, `adjustr`, `repeat` |
| [05_search.f90](05_search.f90) | `index`, `scan`, `verify`; path parsing |
| [06_character_codes.f90](06_character_codes.f90) | `iachar`, `achar`, `ichar`, `char`, `new_line`, case conversion |
| [07_number_conversion.f90](07_number_conversion.f90) | Internal I/O: `to_string`, `parse_int` |
| [08_unicode.f90](08_unicode.f90) | `ISO_10646` kind, UTF-8 output |
| [09_split_tokenize.f90](09_split_tokenize.f90) | F2023 `split`, `tokenize` ⚠ not in gfortran 15 |
| [10_manual_tokenizer.f90](10_manual_tokenizer.f90) | Portable tokenizer with `scan` |

## Intrinsics

| Intrinsic | Purpose |
|---|---|
| `len(s)`, `len_trim(s)` | length with / without trailing blanks |
| `trim(s)`, `adjustl(s)`, `adjustr(s)` | strip / shift blanks |
| `repeat(s, n)` | `n` copies |
| `index(s, sub [, back])` | find substring |
| `scan(s, set [, back])` | first char **in** set |
| `verify(s, set [, back])` | first char **not in** set |
| `lge`, `lgt`, `lle`, `llt` | ASCII-order comparison |
| `achar(i)`, `iachar(c)` | ASCII ⇄ code |
| `char(i [, kind])`, `ichar(c)` | processor codes, any kind |
| `new_line(c)` | newline of `c`'s kind |
| `selected_char_kind(name)` | `'DEFAULT'`, `'ASCII'`, `'ISO_10646'` |
| `split`, `tokenize` (F2023) | tokenising subroutines |

## Key points

- Positions start at 1; use `s(i:i)` for one character.
- Fixed-length assignment pads/truncates; comparisons ignore trailing
  blanks; concatenation keeps them — `trim` first.
- `len=:` allocatable strings resize automatically on assignment.
- All elements of a string array share one length; use a derived type
  with a `character(:), allocatable` component for ragged lists.
- Convert numbers with internal `read`/`write`; always check `iostat`.
- No backslash escapes, no `to_upper`: build them from `achar`/`iachar`.
- Unicode needs the `ISO_10646` kind and `encoding='UTF-8'` on the unit.
