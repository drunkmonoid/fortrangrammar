# Exercises: Chapters 01–10

Each exercise combines two features from the corresponding chapter. Every solution is a standalone Fortran 2023 program.

1. **Chapter 01 (Getting Started):** Print the Fortran compiler version inquiry alongside `iso_fortran_env` integer storage size in bits using named `program` and `implicit none (type, external)`.
2. **Chapter 02 (Lexical Elements):** Join a long expression across two `&` continuation lines and place two short assignments on one line with `;`, using a keyword-named variable (`real` is not reserved when not ambiguous, or `integer :: sum`).
3. **Chapter 03 (Intrinsic Types):** Combine `int64` arithmetic with a `complex(real64)` conjugate product and check that `z * conjg(z)` has zero imaginary part and exact integer squared norm.
4. **Chapter 04 (Declarations):** Define an `enum, bind(c)` colour set and an `integer, parameter` lookup table mapping each enumerator to an RGB weight checksum.
5. **Chapter 05 (Expressions):** Combine short-circuit-safe nested `if` guarding (`x /= 0`) with an integer `merge` selection and relational comparison on negative integer division (`-7 / 2` truncation vs modulo).
6. **Chapter 06 (Control Flow):** Use a named outer `do` construct exited with `exit outer` together with a `select case` classifier to stop at the first sentinel and count categories.
7. **Chapter 07 (Arrays Fundamentals):** Slice a 2-D integer matrix using non-unit stride (`1:4:2`) combined with an array constructor using an implied-do (`[(i * i, i = 1, 4)]`) and check `sum`.
8. **Chapter 08 (Dynamic Arrays):** Use `move_alloc` to resize an allocatable integer buffer paired with `allocated(...)` guard and sourced allocation `allocate(buf, source=...)`.
9. **Chapter 09 (Array Intrinsics):** Combine `pack` with a logical mask and `reshape` with `order=[2, 1]` on a 2x3 matrix to extract transposed filtered elements.
10. **Chapter 10 (Characters):** Combine `trim`/`adjustl` normalisation with `index(..., back=.true.)` and `scan` to locate a file extension and delimiter count in a padded path string.
