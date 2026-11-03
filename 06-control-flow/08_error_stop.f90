! @exit 1
! -----------------------------------------------------------------------------
! 08_error_stop.f90 - error termination with ERROR STOP
!
! Run:  scripts/run.sh 06-control-flow/08_error_stop.f90; echo "exit status: $?"
! -----------------------------------------------------------------------------
!
!   error stop                     error termination, nonzero status
!   error stop int-expr            the value is the exit status
!   error stop char-expr           message to stderr; status nonzero
!                                  (gfortran uses 1)
!   error stop code, quiet=logical (F2018)
!
! Differences from STOP:
!   * it is "error termination": with coarrays, ALL images stop at once;
!   * gfortran also prints a backtrace when compiled with -fbacktrace;
!   * since F2018, ERROR STOP is allowed in PURE procedures, so library code
!     can abort on impossible conditions from anywhere.
!
! Exit with an informative message: what failed and with which values.

program error_stop_demo
  implicit none (type, external)

  real :: denominator

  denominator = 0.0
  print '(a)', 'checking input...'
  call require(denominator /= 0.0, 'denominator must be nonzero')
  print '(a)', 'never printed'

contains

  pure subroutine require(condition, message)
    logical, intent(in) :: condition
    character(len=*), intent(in) :: message

    if (.not. condition) error stop 'requirement failed: ' // message
  end subroutine require

end program error_stop_demo
