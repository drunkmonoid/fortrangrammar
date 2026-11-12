# 96 — Richardson Extrapolation

Symmetric finite differences approximate $f'(x)$ via
$$D(h) = \frac{f(x+h) - f(x-h)}{2h} = f'(x) + \frac{h^2}{6} f'''(x) + O(h^4).$$
For any quadratic polynomial $f(x) = x^2$, $f'''(x) = 0$ identically, so $D(h)$ is exact.
More generally, **Richardson extrapolation** combines $D(h)$ and $D(h/2)$ via
$(4D(h/2) - D(h)) / 3$ to cancel the $O(h^2)$ error term and achieve fourth-order accuracy.

## Examples

| File | Topic |
|---|---|
| [01_richardson.f90](01_richardson.f90) | Symmetric difference and Richardson step on $f(x) = x^2$ |
