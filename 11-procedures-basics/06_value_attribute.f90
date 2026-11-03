! -----------------------------------------------------------------------------
! 06_value_attribute.f90 - VALUE dummy arguments
!
! Run:  scripts/run.sh 11-procedures-basics/06_value_attribute.f90
! -----------------------------------------------------------------------------
!
! A VALUE dummy receives a private COPY of the actual argument:
!   * the procedure may modify it freely; the caller never sees the change;
!   * the actual argument can be any expression;
!   * it may be combined with intent(in) (documentation) but not with
!     intent(out)/intent(inout);
!   * in BIND(C) procedures it maps to C pass-by-value (chapter 27).
!
! Without VALUE, modifying a dummy modifies the caller's variable.

module value_demo
  implicit none (type, external)
contains

  integer function digit_sum(n)
    integer, value :: n                  ! local copy: we can consume it
    digit_sum = 0
    do while (n > 0)
      digit_sum = digit_sum + mod(n, 10)
      n = n / 10
    end do
  end function digit_sum

  subroutine by_reference(n)
    integer, intent(inout) :: n
    n = 0
  end subroutine by_reference

end module value_demo

program value_attribute
  use value_demo, only: digit_sum, by_reference
  implicit none (type, external)

  integer :: number

  number = 98765
  print '(a, i0)', 'digit_sum = ', digit_sum(number)
  print '(a, i0)', 'number unchanged: ', number

  call by_reference(number)
  print '(a, i0)', 'after by_reference: ', number

end program value_attribute

! Output:
! digit_sum = 35
! number unchanged: 98765
! after by_reference: 0
