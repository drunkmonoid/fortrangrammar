! -----------------------------------------------------------------------------
! 03_intent.f90 - INTENT(IN), INTENT(OUT), INTENT(INOUT)
!
! Run:  scripts/run.sh 11-procedures-basics/03_intent.f90
! -----------------------------------------------------------------------------
!
!   intent(in)     the procedure only reads the argument; assigning to it
!                  is a COMPILE error. The actual may be an expression.
!   intent(out)    the argument is undefined on entry and must be set
!                  before use. Allocatable actuals are DEALLOCATED on entry,
!                  and derived-type components with default initialisation
!                  are RE-INITIALISED on entry. The actual must be a variable.
!   intent(inout)  read and modified. The actual must be a variable.
!   (no intent)    like inout, but also allows passing a non-variable if the
!                  procedure happens not to modify it. Avoid.
!
! Always declare intent for every dummy argument: it documents the
! interface and lets the compiler catch mistakes and optimise.

module intent_demo
  implicit none (type, external)

  type :: counter
    integer :: hits = 0                ! default initialisation
  end type counter

contains

  subroutine accumulate(x, total)
    real, intent(in) :: x
    real, intent(inout) :: total
    ! x = 0.0     <- compile error: x is intent(in)
    total = total + x
  end subroutine accumulate

  subroutine fresh_counter(c)
    type(counter), intent(out) :: c    ! c%hits is reset to 0 on entry
    c%hits = c%hits + 1
  end subroutine fresh_counter

  subroutine bump_counter(c)
    type(counter), intent(inout) :: c
    c%hits = c%hits + 1
  end subroutine bump_counter

  subroutine make_list(list, n)
    integer, allocatable, intent(out) :: list(:)   ! deallocated on entry
    integer, intent(in) :: n
    integer :: i
    list = [(i, i = 1, n)]
  end subroutine make_list

end module intent_demo

program intent
  use intent_demo, only: counter, accumulate, fresh_counter, bump_counter, make_list
  implicit none (type, external)

  real :: total
  type(counter) :: c
  integer, allocatable :: list(:)

  total = 0
  call accumulate(1.5, total)
  call accumulate(2.0 * 3.0, total)          ! expressions are fine for intent(in)
  print '(a, f0.1)', 'total = ', total

  c%hits = 10
  call bump_counter(c)
  print '(a, i0)', 'after bump  (inout): ', c%hits
  call fresh_counter(c)
  print '(a, i0)', 'after fresh (out)  : ', c%hits

  list = [9, 9, 9, 9, 9, 9]
  call make_list(list, 3)
  print '(a, *(1x, i0))', 'make_list:', list

  ! call accumulate(1.0, 5.0)  <- compile error: 5.0 is not a variable

end program intent

! Output:
! total = 7.5
! after bump  (inout): 11
! after fresh (out)  : 1
! make_list: 1 2 3
