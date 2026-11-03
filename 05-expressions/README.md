# 05 — Expressions and Assignment

Operators, precedence, type conversion in mixed expressions, what the
compiler is allowed to reorder, and what `=` actually does.

## Examples

| File | Topic |
|---|---|
| [01_arithmetic_operators.f90](01_arithmetic_operators.f90) | `+ - * / **`, `-2**2`, integer division, `mod` vs `modulo` |
| [02_mixed_mode.f90](02_mixed_mode.f90) | Type/kind promotion, the `1/2 * x` bug |
| [03_relational_operators.f90](03_relational_operators.f90) | `==` … `>=`, `.eq.` …, float tolerance, string padding |
| [04_no_short_circuit.f90](04_no_short_circuit.f90) | `.and.`/`.or.` may evaluate both sides |
| [05_operator_precedence.f90](05_operator_precedence.f90) | Full precedence table |
| [06_intrinsic_assignment.f90](06_intrinsic_assignment.f90) | Conversion, padding, broadcast, reallocation |
| [07_evaluation_rules.f90](07_evaluation_rules.f90) | Parentheses are honoured, nothing else is promised |
| [08_conditional_expressions.f90](08_conditional_expressions.f90) | F2023 `( c ? a : b )` ⚠ not in gfortran 15 |
| [09_defined_operators_preview.f90](09_defined_operators_preview.f90) | `.dot.`, `.cross.`, extending `+` |

## Precedence (high → low)

| Level | Operators | Associativity |
|---|---|---|
| 1 | defined unary `.op.` | — |
| 2 | `**` | right |
| 3 | `*` `/` | left |
| 4 | unary `+` `-` | — |
| 5 | binary `+` `-` | left |
| 6 | `//` | left |
| 7 | `==` `/=` `<` `<=` `>` `>=` (and `.eq.` …) | none |
| 8 | `.not.` | — |
| 9 | `.and.` | left |
| 10 | `.or.` | left |
| 11 | `.eqv.` `.neqv.` | left |
| 12 | defined binary `.op.` | left |

## Mixed-mode result types

| `x1 op x2` | Result |
|---|---|
| integer ∘ integer | integer, larger-range kind |
| integer ∘ real | real |
| real ∘ real | real, greater-precision kind |
| any ∘ complex | complex, greater-precision kind |

Conversion happens **per operation**: `1/2 * x` is `0 * x`.

## Key points

- `-2**2` is `-4`; `2**3**2` is `2**9`.
- `integer / integer` truncates toward zero; `2**(-1)` is `0`.
- Never test reals with `==`; use a relative tolerance.
- No short-circuit guarantee: guard with nested `if` (or F2023 `? :`).
  `merge()` evaluates all its arguments too.
- Parentheses are always respected; otherwise the compiler may reorder
  mathematically equivalent expressions.
- `=` converts to the variable's type, pads/truncates strings,
  broadcasts scalars and reallocates allocatables.
