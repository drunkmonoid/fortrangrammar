! -----------------------------------------------------------------------------
! 01_format_specifications.f90 - where a format comes from, and its grammar
!
! Run:  scripts/run.sh 22-formatted-io/01_format_specifications.f90
! -----------------------------------------------------------------------------
!
! A format specification is a parenthesised list of edit descriptors:
!
!   '(a, i5, 2(1x, f8.3))'
!
! It can be given as:
!   * a character literal or constant            print '(i0)', n
!   * a character VARIABLE built at run time     write (*, fmt) x
!   * a FORMAT statement referenced by label     write (*, 100) x
!   * * for list-directed formatting             print *, x
!
! Grammar:
!   r(...)     a group repeated r times; groups nest
!   r ed       a data edit descriptor repeated: 3i4 = i4, i4, i4
!   *(...)     unlimited repetition (F2008), see 07_unlimited_and_reversion
!   'text'     character string edit descriptor (output only)
! Commas between items may be omitted around / and : and after P.
! Case of descriptors does not matter: I5 = i5.

program format_specifications
  implicit none (type, external)

  integer :: i
  real :: x(3) = [1.0, 22.5, 333.25]
  character(len=:), allocatable :: fmt
  character(len=20) :: built

  print '(a, i5)', 'literal format:', 42
  write (*, '(3(1x, f7.2))') x                     ! group with repeat count
  write (*, '(3f8.2)') x                           ! repeated descriptor

  ! A FORMAT statement.
  write (*, 100) 'format statement', 3.14159
100 format (a, ':', 1x, f6.3)

  ! A run-time format: width chosen from the data.
  i = 12345
  fmt = '(a, i' // char(iachar('0') + 7) // ')'
  write (*, fmt) 'run-time width 7:', i

  ! Building a format with internal I/O (the usual way).
  write (built, '(a, i0, a)') '(', size(x), '(1x, es10.3))'
  print '(2a)', 'built format: ', trim(built)
  write (*, built) x

  ! Nested groups.
  print '(2(a, 2(1x, i0), ";"))', 'pair', 1, 2, 'pair', 3, 4

end program format_specifications

! Output:
! literal format:   42
!     1.00   22.50  333.25
!     1.00   22.50  333.25
! format statement:  3.142
! run-time width 7:  12345
! built format: (3(1x, es10.3))
!   1.000E+00  2.250E+01  3.332E+02
! pair 1 2;pair 3 4;
