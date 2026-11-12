# 84 — Parser

Recursive-descent parsing transforms the flat token stream from Chapter 83
into an Abstract Syntax Tree (AST) that encodes operator precedence and grouping:

```text
expr   = term   { ("+" | "-") term }
term   = factor { ("*" | "/") factor }
factor = integer | identifier | "(" expr ")"
```

AST nodes are allocated inside an integer-indexed arena array (Chapter 76) rather
than linked via Fortran pointers. Syntax errors such as mismatched parentheses set a
non-zero `stat` without printing any partial tree.

## Examples

| File | Topic |
|---|---|
| [01_parser.f90](01_parser.f90) | Recursive-descent arithmetic expression parser and prefix tree printer |
