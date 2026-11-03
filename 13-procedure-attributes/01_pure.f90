! -----------------------------------------------------------------------------
! 01_pure.f90 - PURE procedures
!
! Run:  scripts/run.sh 13-procedure-attributes/01_pure.f90
! -----------------------------------------------------------------------------
!
! A PURE procedure promises no side effects, checked by the compiler:
!   * functions: every dummy argument is intent(in) (or value);
!     subroutines: every dummy has a declared intent;
!   * no modification of module, common or host variables;
!   * no SAVEd local variables (so no initialisers on locals either!);
!   * no I/O to external units (internal files are fine);
!   * only pure procedures may be called;
!   * no STOP; ERROR STOP is allowed (F2018).
!
! Why: pure procedures may be called from DO CONCURRENT, FORALL, specification
! expressions and other pure procedures, and the compiler can reorder,
! parallelise or eliminate calls safely. Mark every procedure pure that can
! be - it costs nothing and documents intent.

module pure_math
  implicit none (type, external)
  integer :: call_count = 0            ! pure procedures may READ this...
contains

  pure real function mean(x)
    real, intent(in) :: x(:)
    mean = sum(x) / max(size(x), 1)
  end function mean

  pure subroutine normalise(x)
    real, intent(inout) :: x(:)
    real :: n                          ! locals are fine (not saved)
    n = norm2(x)
    if (n == 0.0) error stop 'normalise: zero vector'
    x = x / n
  end subroutine normalise

  pure function format_int(n) result(s)
    integer, intent(in) :: n
    character(len=:), allocatable :: s
    character(len=16) :: buffer
    write (buffer, '(i0)') n           ! internal I/O is allowed
    s = trim(buffer)
  end function format_int

  pure integer function times_called()
    times_called = call_count          ! ...but must not modify it
  end function times_called

end module pure_math

program pure_demo
  use pure_math, only: mean, normalise, format_int, times_called
  implicit none (type, external)

  real :: v(3) = [3.0, 0.0, 4.0]
  integer :: i
  real :: results(4)

  print '(a, f0.4)', 'mean(v) = ', mean(v)
  call normalise(v)
  print '(a, *(1x, f0.2))', 'normalised:', v
  print '(a)', 'formatted: ' // format_int(2026)
  print '(a, i0)', 'times_called: ', times_called()

  ! Pure procedures can be used inside DO CONCURRENT.
  do concurrent (i = 1:4)
    results(i) = mean([real(i), real(2 * i)])
  end do
  print '(a, *(1x, f0.1))', 'do concurrent:', results

end program pure_demo

! Output:
! mean(v) = 2.3333
! normalised: .60 .00 .80
! formatted: 2026
! times_called: 0
! do concurrent: 1.5 3.0 4.5 6.0
