! -----------------------------------------------------------------------------
! 01_if.f90 - IF statement and IF construct
!
! Run:  scripts/run.sh 06-control-flow/01_if.f90
! -----------------------------------------------------------------------------
!
!   if (logical-expr) action-stmt                  one-line IF statement
!
!   [name:] if (logical-expr) then                 IF construct
!     ...
!   else if (logical-expr) then [name]
!     ...
!   else [name]
!     ...
!   end if [name]
!
! * The condition must be a scalar LOGICAL - integers are not accepted.
! * The one-line form takes a single action statement, which may not be
!   another IF, an END statement or the start of a construct.
! * At most one branch runs; the first true condition wins.
! * A construct name (here `classify`) must match on else/end if and lets
!   you EXIT the construct (see 04_exit_cycle_named.f90).

program if_construct
  implicit none (type, external)

  integer :: n
  integer :: tests(5) = [-5, 0, 7, 42, 1000]
  integer :: k

  ! One-line IF statement.
  n = 3
  if (n > 0) print '(a)', 'n is positive'

  ! IF construct with else-if chain.
  do k = 1, size(tests)
    n = tests(k)
    classify: if (n < 0) then
      print '(i0, a)', n, ': negative'
    else if (n == 0) then classify
      print '(i0, a)', n, ': zero'
    else if (n < 100) then classify
      print '(i0, a)', n, ': small positive'
    else classify
      print '(i0, a)', n, ': large positive'
    end if classify
  end do

  ! Nested IF without names.
  n = 42
  if (mod(n, 2) == 0) then
    if (mod(n, 3) == 0) then
      print '(i0, a)', n, ' is divisible by 6'
    end if
  end if

end program if_construct

! Output:
! n is positive
! -5: negative
! 0: zero
! 7: small positive
! 42: small positive
! 1000: large positive
! 42 is divisible by 6
