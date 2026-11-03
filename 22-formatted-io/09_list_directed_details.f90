! -----------------------------------------------------------------------------
! 09_list_directed_details.f90 - the rules of fmt=*
!
! Run:  scripts/run.sh 22-formatted-io/09_list_directed_details.f90
! -----------------------------------------------------------------------------
!
! OUTPUT with * : the processor chooses widths; records start with a blank;
! complex as (re,im); character values without quotes; long lists may wrap
! to several records. Fine for debugging, never for files others parse.
!
! INPUT with * is flexible and worth knowing:
!   * values separated by blanks, commas, or (with DC) semicolons;
!   * r*c      repeat count: 3*0 means 0, 0, 0
!   * r*       r NULL values: the variables keep their old values
!   * ,,       an empty field is a null value too
!   * /        terminates the read; remaining variables are unchanged
!   * character values may be quoted ('a b') - required if they contain
!     blanks, commas or slashes
!   * complex values in parentheses: (1.0, 2.0)
!   * logical values T, F, .true., ...

program list_directed_details
  implicit none (type, external)

  integer :: a(6)
  real :: x
  complex :: z
  character(len=12) :: name
  logical :: flag
  character(len=60) :: line           ! internal files must be variables

  a = -1
  line = '1, 2 3*7'
  read (line, *) a(1:5)
  print '(a, *(1x, i0))', 'repeat count     :', a

  a = -1
  line = '10,,30'
  read (line, *) a(1:3)              ! null value keeps a(2)
  print '(a, *(1x, i0))', 'null value       :', a

  a = -1
  line = '5 6 /'
  read (line, *) a                    ! slash ends the read early
  print '(a, *(1x, i0))', 'slash terminator :', a

  line = "'two words', (1.5, -2), .true., 3.25"
  read (line, *) name, z, flag, x
  print '(3a, 2(1x, f0.2), 1x, l1, 1x, f0.2)', 'quoted + complex : [', trim(name), ']', z, flag, x

  print *, 'list-directed output:', 42, 3.5, (1.0, 2.0), .true., 'text'

end program list_directed_details

! Output:
! repeat count     : 1 2 7 7 7 -1
! null value       : 10 -1 30 -1 -1 -1
! slash terminator : 5 6 -1 -1 -1 -1
! quoted + complex : [two words] 1.50 -2.00 T 3.25
!  list-directed output:          42   3.50000000                 (1.00000000,2.00000000) T text
