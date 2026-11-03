! -----------------------------------------------------------------------------
! 04_ieee_exceptions.f90 - floating-point exception flags and halting
!
! Run:  scripts/run.sh 25-numeric-ieee/04_ieee_exceptions.f90
! -----------------------------------------------------------------------------
!
! use, intrinsic :: ieee_exceptions      (ieee_arithmetic also provides it)
!
! Five IEEE exceptions, each with a sticky FLAG:
!   ieee_overflow        result too large           huge * 2
!   ieee_divide_by_zero  finite / 0                 1 / 0
!   ieee_invalid         no meaningful result       0/0, sqrt(-1), inf - inf
!   ieee_underflow       result tiny and inexact    tiny / 3
!   ieee_inexact         result was rounded         1 / 3
!
!   ieee_set_flag(flag, .false.)        clear
!   ieee_get_flag(flag, value)          read (value is logical)
!   ieee_set_halting_mode(flag, .true.) trap: abort when it happens
!   ieee_get_status(s) / ieee_set_status(s)   save / restore everything
!   ieee_support_flag(flag [, x]), ieee_support_halting(flag)
!
! Flags are cleared on entry to a procedure and restored on return, OR-ed
! with what the procedure raised - so flags are effectively per call.
! gfortran prints a note on STOP if invalid/zero/overflow flags are still
! set; we clear them at the end. (-ffpe-trap=... is the compiler-flag
! equivalent of halting mode.)
!
! The operands are VOLATILE so the compiler cannot evaluate the operations
! at compile time (which would raise no run-time flags at all).

program ieee_exceptions_demo
  use, intrinsic :: ieee_exceptions
  implicit none (type, external)

  real, volatile :: x, y, zero, three, small
  logical :: flag
  type(ieee_flag_type), parameter :: names(5) = &
      [ieee_overflow, ieee_divide_by_zero, ieee_invalid, ieee_underflow, ieee_inexact]
  character(len=14), parameter :: labels(5) = &
      [character(len=14) :: 'overflow', 'divide_by_zero', 'invalid', 'underflow', 'inexact']

  zero = 0.0
  three = 3.0
  small = tiny(small)
  call ieee_set_flag(ieee_all, .false.)

  x = huge(x)
  y = x * 2
  call report('huge * 2')

  y = 1 / zero
  call report('1 / 0')

  y = zero / zero
  call report('0 / 0')

  y = small / three
  call report('tiny / 3')

  x = 1.0
  y = x / three
  call report('1 / 3')

  call ieee_set_flag(ieee_all, .false.)       ! leave a clean state

contains

  subroutine report(what)
    character(len=*), intent(in) :: what
    integer :: i
    write (*, '(a10, ":")', advance='no') what
    do i = 1, size(names)
      call ieee_get_flag(names(i), flag)
      if (flag) write (*, '(1x, a)', advance='no') trim(labels(i))
    end do
    print '(a)', ''
    call ieee_set_flag(ieee_all, .false.)
  end subroutine report

end program ieee_exceptions_demo

! Output:
!   huge * 2: overflow inexact
!      1 / 0: divide_by_zero
!      0 / 0: invalid
!   tiny / 3: underflow inexact
!      1 / 3: inexact
