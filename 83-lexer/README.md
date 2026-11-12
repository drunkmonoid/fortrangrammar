# 83 — Lexer

A lexical scanner (tokenizer) transforms a raw input string into a stream of
typed tokens (`INT`, `IDENT`, operators `+ - * /`, parentheses `( )`, and `EOF`)
while skipping whitespace and reporting unexpected characters via an error `stat`.

This module acts as the front end for the recursive-descent parser in Chapter 84
and the tree evaluator in Chapter 85.

## Examples

| File | Topic |
|---|---|
| [01_lexer.f90](01_lexer.f90) | Tokenize `2 * (a + 10)` and report unknown characters with `stat` |
