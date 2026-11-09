! -----------------------------------------------------------------------------
! 02_old_declarations.f90 - double precision, character*, statement parameter
!
! Run:  scripts/run.sh 31-fixed-form/02_old_declarations.f90
! -----------------------------------------------------------------------------
!
! These spellings are what you type when you are reading Fortran 77. The
! attribute-statement forms are still the ones in chapter 04; this file is
! the old punctuation.
!
!   double precision x          still standard: real(kind(0.0d0))
!   character*11 greeting       obsolescent character(len=11)
!   integer n / parameter (n=)  obsolescent integer, parameter :: n =
!   dimension counts(3)         obsolescent integer :: counts(3)
!
! real*8, integer*4 and complex*16 are not standard. -std=f2023 rejects
! them as GNU extensions, so they do not appear in this program.

program old_declarations
  implicit none (type, external)

  integer n
  parameter (n = 3)
  double precision x
  parameter (x = 1.5d0)
  character*11 greeting
  integer counts
  dimension counts(3)

  greeting = 'Hello there'
  counts(1) = 1
  counts(2) = 2
  counts(3) = 3

  print '(a, i0)', 'n = ', n
  print '(a, a, a)', 'greeting = [', greeting, ']'
  print '(a, l1)', 'same kind as 0d0: ', kind(x) == kind(0.0d0)
  print '(a, f3.1)', 'x = ', x
  print '(a, 3(1x, i0))', 'counts =', counts

end program old_declarations

! Output:
! n = 3
! greeting = [Hello there]
! same kind as 0d0: T
! x = 1.5
! counts = 1 2 3
