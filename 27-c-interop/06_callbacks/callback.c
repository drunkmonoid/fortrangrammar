/* callback.c - C code that calls a function pointer supplied by Fortran. */
double integrate(double (*f)(double), double a, double b, int n) {
    double h = (b - a) / n, s = 0.5 * (f(a) + f(b));
    for (int i = 1; i < n; ++i) s += f(a + i * h);
    return s * h;                         /* trapezoidal rule */
}
