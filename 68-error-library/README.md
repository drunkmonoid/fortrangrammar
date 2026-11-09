# 68 — An Error Library

One module, two programs. `result_t` carries an integer status and a
deferred-length message. Procedures that can fail take it as an
`intent(out)` argument and return before they touch their other outputs.
There are no exceptions (chapter 24 is the language mechanism this wraps).

## Examples

| File | Topic |
|---|---|
| [01_two_programs/](01_two_programs/) | `result_m`, a success program, a failure program, `build.sh` |

`allocate` itself can fail, and `check_allocate` records that status. The
failure program does not need it: a negative length is a caller error,
caught before the allocate, so the message is the one this module wrote.
