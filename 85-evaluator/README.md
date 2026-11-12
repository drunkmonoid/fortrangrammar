# 85 — Evaluator

This chapter completes the expression pipeline started in Chapters 83 and 84
by evaluating the AST in an environment containing variable bindings (`a = 3`, `b = 4`):

- Post-order tree walk handles binary operators, integer literals, and variable lookup
- Precedence and grouping are already encoded in the AST structure by the parser
- Runtime errors such as division by zero (`stat = -10`) and unbound names (`stat = -11`)
  propagate cleanly through `stat`

## Examples

| File | Topic |
|---|---|
| [01_evaluator.f90](01_evaluator.f90) | Tree-walking integer evaluator with variable environment and division-by-zero check |
