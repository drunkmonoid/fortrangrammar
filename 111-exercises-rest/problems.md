# Exercises: Chapters 21–36

Each exercise combines two features from the corresponding chapter. Every solution is a standalone program. The coarray solution is built with `-fcoarray=single`. The OpenMP solution is built with `-fopenmp`. The fixed-form solution is a `.f` file.

1. **Chapter 21 (Pointers):** Associate a pointer with a section of a target array, sum the section, then `nullify` it and test `associated`.
2. **Chapter 22 (Formatted I/O):** Write an integer to an internal file with an explicit format and read it back.
3. **Chapter 23 (File I/O):** Write two integers to a scratch file, rewind, and read them back.
4. **Chapter 24 (Errors):** Take the `iostat` of a bad internal read and the `stat` of a successful `allocate`.
5. **Chapter 25 (IEEE):** Ask `ieee_is_finite` about an ordinary value and a quiet NaN.
6. **Chapter 26 (Intrinsics):** Use `popcnt` and `trailz` on two fixed integers.
7. **Chapter 27 (C interop):** Report `c_sizeof` of a `c_int` and `c_associated(c_loc(...))` without a C file.
8. **Chapter 28 (Coarrays):** On one image, store `this_image()` in a coarray and print `num_images()`.
9. **Chapter 29 (OpenMP):** Reduce `1 + 2 + 3 + 4` with a parallel do. MPI is not used.
10. **Chapter 30 (Testing):** A small assert subroutine and `compiler_version`.
11. **Chapter 31 (Fixed form):** A `C` comment and a continuation mark in column 6.
12. **Chapter 32 (Storage association):** `equivalence` an integer with the first element of a two-element array.
13. **Chapter 33 (Obsolescent forms):** A statement function and a labelled `do` ending on `continue`.
14. **Chapter 34 (Deleted features):** The six deleted forms are named in comments. The program uses an integer `do` and `select case`, which replaced the real loop variable and the arithmetic `if`.
15. **Chapter 35 (Fortran 77 rewrites):** Mean and length of a fixed array, written with array syntax.
16. **Chapter 36 (Conformance):** Test `allocated` before any reference, then allocate and sum.
