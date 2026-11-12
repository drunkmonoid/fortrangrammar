# 104 — Linear Regression

Application wrapper reading `(x, y)` pairs from an input table and fitting `y = intercept + slope * x`.

## Behaviour

- Uses the same 2x2 normal-equations formulation as [95 — Least Squares](../95-least-squares/).
- Fits `(0, 1)`, `(1, 3)`, `(2, 5)` and reports `slope = 2` and `intercept = 1`.

## Files

| File | Description |
|---|---|
| [01_regression.f90](01_regression.f90) | Linear regression table reader and summary output |
