! -----------------------------------------------------------------------------
! 04_implicit_typing_trap.f90 - why IMPLICIT NONE exists
!
! Run:  scripts/run.sh 01-getting-started/04_implicit_typing_trap.f90
! -----------------------------------------------------------------------------
!
! Without an IMPLICIT statement Fortran still applies the default rule:
!
!   names starting with I, J, K, L, M, N  ->  INTEGER
!   every other name                       ->  REAL
!
! Undeclared names are silently created with those types. This file has NO
! implicit none on purpose, and it is still valid Fortran 2023; the compiler
! only warns (with -Wall) about the lossy conversion below.

program implicit_typing_trap

  rate = 0.05          ! starts with R -> REAL,    stores 0.05
  interest = 0.05      ! starts with I -> INTEGER, 0.05 is truncated to 0
  principal = 1000.0   ! starts with P -> REAL

  print '(a, g0)', 'yield using rate     = ', principal * rate
  print '(a, g0)', 'yield using interest = ', principal * interest

  ! A misspelled name is not an error either: "totl" is a brand-new REAL
  ! variable. With implicit none this line would not compile.
  ! (Commented out because reading an undefined variable is undefined
  ! behaviour; the result would be arbitrary.)
  !   total = totl + 1.0

end program implicit_typing_trap

! Output:
! yield using rate     = 50.0000000
! yield using interest = 0.00000000
