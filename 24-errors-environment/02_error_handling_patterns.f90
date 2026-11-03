! -----------------------------------------------------------------------------
! 02_error_handling_patterns.f90 - designing procedures that can fail
!
! Run:  scripts/run.sh 24-errors-environment/02_error_handling_patterns.f90
! -----------------------------------------------------------------------------
!
! Three idioms, from simplest to richest:
!
!  1. OPTIONAL STATUS, like the intrinsics: if the caller passes stat=, set
!     it and return; otherwise stop with a message. Callers who do not care
!     still get a clear failure.
!
!  2. STATUS + MESSAGE: an integer code plus a deferred-length message.
!
!  3. ERROR OBJECT: a derived type carrying code, message and context,
!     returned or passed intent(out). Easy to extend; can be checked with a
!     type-bound `ok()`.
!
! ERROR STOP is allowed in pure procedures (F2018), so even pure library
! code can enforce preconditions.

module safe_math
  implicit none (type, external)
  private
  public :: safe_sqrt, parse_positive, error_t, checked_divide

  type :: error_t
    integer :: code = 0
    character(len=:), allocatable :: message
  contains
    procedure :: ok
  end type error_t

contains

  ! 1. Optional status.
  real function safe_sqrt(x, stat)
    real, intent(in) :: x
    integer, intent(out), optional :: stat
    if (present(stat)) stat = 0
    if (x < 0) then
      if (present(stat)) then
        stat = 1
        safe_sqrt = 0
        return
      end if
      error stop 'safe_sqrt: negative argument'
    end if
    safe_sqrt = sqrt(x)
  end function safe_sqrt

  ! 2. Status + message.
  subroutine parse_positive(text, value, stat, msg)
    character(len=*), intent(in) :: text
    integer, intent(out) :: value, stat
    character(len=:), allocatable, intent(out) :: msg
    character(len=256) :: iomsg
    read (text, *, iostat=stat, iomsg=iomsg) value
    if (stat /= 0) then
      msg = 'not an integer: "' // text // '"'
    else if (value <= 0) then
      stat = 2
      msg = 'not positive: "' // text // '"'
    else
      msg = ''
    end if
  end subroutine parse_positive

  ! 3. Error object.
  logical function ok(self)
    class(error_t), intent(in) :: self
    ok = self%code == 0
  end function ok

  real function checked_divide(a, b, err)
    real, intent(in) :: a, b
    type(error_t), intent(out) :: err
    if (b == 0) then
      err = error_t(10, 'division by zero')
      checked_divide = 0
    else
      checked_divide = a / b
    end if
  end function checked_divide

end module safe_math

program error_handling_patterns
  use safe_math, only: safe_sqrt, parse_positive, error_t, checked_divide
  implicit none (type, external)

  integer :: stat, value
  character(len=:), allocatable :: msg
  type(error_t) :: err
  real :: r

  r = safe_sqrt(-4.0, stat)
  print '(a, i0)', 'safe_sqrt(-4) with stat: stat = ', stat

  call parse_positive('12', value, stat, msg)
  print '(a, i0, a, i0)', "parse '12' : stat=", stat, ' value=', value
  call parse_positive('-3', value, stat, msg)
  print '(a, i0, 2a)', "parse '-3' : stat=", stat, ' ', msg
  call parse_positive('abc', value, stat, msg)
  print '(a, i0, 2a)', "parse 'abc': stat=", stat, ' ', msg

  r = checked_divide(1.0, 0.0, err)
  if (.not. err%ok()) print '(a, i0, 2a)', 'checked_divide: code ', err%code, ', ', err%message
  r = checked_divide(1.0, 4.0, err)
  if (err%ok()) print '(a, f0.2)', 'checked_divide(1, 4) = ', r

end program error_handling_patterns

! Output:
! safe_sqrt(-4) with stat: stat = 1
! parse '12' : stat=0 value=12
! parse '-3' : stat=2 not positive: "-3"
! parse 'abc': stat=5010 not an integer: "abc"
! checked_divide: code 10, division by zero
! checked_divide(1, 4) = .25
