# 58 — C Descriptors

Chapter 27 passes a descriptor into C and reads it. This chapter builds
descriptors in C.

`CFI_establish` associates a Fortran pointer with memory C already owns.
The lower bound of that pointer is 0, which is the value the function
sets. `CFI_allocate` creates an allocatable with an explicit lower bound
of 2, and `CFI_deallocate` releases it. A deferred-length character is
allocated with its length in the element-length argument. An assumed-rank
dummy reports `rank`, which is 0 for a scalar.

The header is `ISO_Fortran_binding.h`, the same one chapter 27 uses. It
ships with gfortran. gfortran 15 warns that a deferred-length character
dummy may not be interoperable; the descriptor call still runs.

## Examples

| File | Topic |
|---|---|
| [01_establish/](01_establish/) | Establish, allocate, character, assumed rank |
