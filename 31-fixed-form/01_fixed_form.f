! -----------------------------------------------------------------------------
! 01_fixed_form.f - columns, labels, continuation and C comments
!
! Run:  scripts/run.sh 31-fixed-form/01_fixed_form.f
! -----------------------------------------------------------------------------
!
! Fixed source form is the Fortran 77 layout. It is obsolescent and still
! part of the standard, so -std=f2023 accepts it. gfortran chooses fixed
! form from the extension (.f, .for, .ftn), not from a compiler flag.
!
!   columns 1-5   statement label, or a comment marker in column 1
!   column 6      blank or 0 starts a statement; any other character continues
!   columns 7-72  the statement
!   columns 73+   ignored. -Wall reports "line truncated"
!
! Free form (.f90, chapter 02) has no columns. Continue with & at the end
! of the line instead of a mark in column 6.

C     Column 1 is C, so this whole line is a comment, however long it is.
      program fixed_form
      implicit none (type, external)

      integer n

C     Padded past column 72. Only "n = 10" is compiled.
      n = 10                                                            IGNORED
      n = n +
     &    5
      print 100, n
  100 format ('n = ', i0)

      end program fixed_form

! Output:
! n = 15
