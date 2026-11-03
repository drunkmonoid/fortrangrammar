# 02 — Lexical Elements

How the compiler reads source text: lines, characters, names, comments,
continuation and labels.

## Examples

| File | Topic |
|---|---|
| [01_free_form_basics.f90](01_free_form_basics.f90) | Line length, `;`, case insensitivity, blanks |
| [02_names.f90](02_names.f90) | Name rules (63 chars); keywords are not reserved |
| [03_comments.f90](03_comments.f90) | `!` comments, directive-style comments |
| [04_continuation.f90](04_continuation.f90) | `&` continuation, splitting strings and tokens |
| [05_statement_labels.f90](05_statement_labels.f90) | Numeric labels, `format`, `go to` |
| [06_include_line.f90](06_include_line.f90) | `include` line (+ [06_include_constants.inc](06_include_constants.inc)) |
| [07_character_set.f90](07_character_set.f90) | Character set, quoting rules, no escapes |
| [08_optional_blanks.f90](08_optional_blanks.f90) | `enddo` vs `end do` and friends |
| [09_preprocessor.F90](09_preprocessor.F90) | `#define`, `#ifdef`, predefined macros (non-standard) |

## Free source form at a glance

| Rule | Value (F2023) |
|---|---|
| Max line length | 10 000 characters (gfortran default is still 132: `-ffree-line-length-none`) |
| Max statement length | 1 000 000 characters |
| Max continuation lines | no separate limit |
| Max name length | 63 |
| Statement separator | `;` |
| Comment | `!` to end of line (outside literals) |
| Continuation | trailing `&`, optional leading `&` |
| Label | 1–5 digits before the statement |

## Tokens

A statement is a sequence of *lexical tokens*:

- **names** — `velocity`, `my_type`, `x2`
- **keywords** — `integer`, `do`, `intent` (recognised by context, not reserved)
- **literal constants** — `42`, `3.0e8_real64`, `'text'`, `.true.`, `(1.0, 2.0)`, `z'ff'`
- **operators** — `+ - * / ** //`, `== /= < <= > >=`, `.and. .or. .not. .eqv. .neqv.`, `.eq.` …, defined `.op.`
- **delimiters** — `( ) [ ] (/ /) , = => : :: ; %`
- **labels** — `100`

Blanks separate tokens and may not appear inside one, except in character
literals and the optional-blank keyword pairs listed in
[08_optional_blanks.f90](08_optional_blanks.f90).

## Continuation cheat sheet

```fortran
x = a + b + &          ! break between tokens: no leading & needed
    c

s = 'split &           ! break inside a literal: leading & required
    &here'             ! -> 'split here'

call f(arg1, &         ! comments after & are fine
       ! a comment line in between is skipped
       arg2)
```

## Key points

- Fortran has no reserved words, but never use keywords as names.
- `!` inside a string is just a character.
- There are no backslash escapes; double the delimiter to embed it.
- Prefer modules to `include`, and kind parameters to `#define`.
- Labels are only for `format` and rare `go to`; name your constructs instead.
