# 39 — Array Performance

Same mathematical result, different cost. The numbers below are checksums,
so the `! Output:` blocks stay stable when the compiler changes its
optimiser. Turn on `-Warray-temporaries` when you are hunting copies; it
is not part of the default flags.

## Examples

| File | Topic |
|---|---|
| [01_traversal.f90](01_traversal.f90) | Column-major storage: the first index is the contiguous one |
| [02_contiguous_argument.f90](02_contiguous_argument.f90) | A `contiguous` dummy, a column, and a strided row |

## What costs

- Fortran arrays are column-major (chapter 07). Loop over the first index
  in the inner loop.
- A non-contiguous actual argument passed to a `contiguous` dummy is
  copied in, and copied back out if the dummy is `intent(inout)` or
  `intent(out)`. The result is right. The copy is the cost.
- A whole-array expression such as `b = a + a` may allocate a temporary
  for the right-hand side. A loop that writes `b(i) = a(i) + a(i)` does
  not. Chapter 73 is the profiling pass over this.
