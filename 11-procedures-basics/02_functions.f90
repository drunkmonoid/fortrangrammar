! -----------------------------------------------------------------------------
! 02_functions.f90 - defining and calling functions
!
! Run:  scripts/run.sh 11-procedures-basics/02_functions.f90
! -----------------------------------------------------------------------------
!
! Three ways to declare the result:
!
!   real function area(r)                type in the prefix; the function
!     area = ...                         name is the result variable
!
!   function area(r)                     type declared inside
!     real :: area
!
!   function area(r) result(a)           RESULT clause: a separate name
!     real :: a                          (required for recursive functions
!                                         returning arrays, and clearer)
!
! * A function is referenced inside an expression: y = area(2.0) + 1
! * The result must be defined before the function returns.
! * Results can be arrays, strings of computed length, derived types,
!   allocatables and pointers - use the RESULT form for those.
! * Functions should not change their arguments or global state: the
!   compiler may evaluate a reference fewer times than written (chapter 05).
!   Use intent(in) for all function arguments, or make them PURE (ch. 13).

module function_forms
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)
  real(dp), parameter :: pi = acos(-1.0_dp)
contains

  real(dp) function circle_area(r)
    real(dp), intent(in) :: r
    circle_area = pi * r**2
  end function circle_area

  function sphere_volume(r)
    real(dp), intent(in) :: r
    real(dp) :: sphere_volume
    sphere_volume = 4.0_dp / 3.0_dp * pi * r**3
  end function sphere_volume

  function linspace(a, b, n) result(x)
    real(dp), intent(in) :: a, b
    integer, intent(in) :: n
    real(dp) :: x(n)                       ! array result, size from argument
    integer :: i
    x = [(a + (b - a) * (i - 1) / (n - 1), i = 1, n)]
  end function linspace

  function shout(text) result(s)
    character(len=*), intent(in) :: text
    character(len=:), allocatable :: s     ! deferred-length result
    s = text // '!!!'
  end function shout

  logical function is_even(n)
    integer, intent(in) :: n
    is_even = mod(n, 2) == 0
  end function is_even

end module function_forms

program functions
  use, intrinsic :: iso_fortran_env, only: dp => real64
  use function_forms, only: circle_area, sphere_volume, linspace, shout, is_even
  implicit none (type, external)

  print '(a, f0.4)', 'circle_area(2)   = ', circle_area(2.0_dp)
  print '(a, f0.4)', 'sphere_volume(1) = ', sphere_volume(1.0_dp)
  print '(a, f0.4)', 'in an expression = ', circle_area(1.0_dp) + 2 * sphere_volume(0.5_dp)
  print '(a, *(1x, f0.2))', 'linspace(0,1,5) =', linspace(0.0_dp, 1.0_dp, 5)
  print '(a, f0.2)', 'sum(linspace(...)) = ', sum(linspace(0.0_dp, 1.0_dp, 5))
  print '(a)', shout('functions')
  print '(a, l1, 1x, l1)', 'is_even(4), is_even(7) = ', is_even(4), is_even(7)

end program functions

! Output:
! circle_area(2)   = 12.5664
! sphere_volume(1) = 4.1888
! in an expression = 4.1888
! linspace(0,1,5) = .00 .25 .50 .75 1.00
! sum(linspace(...)) = 2.50
! functions!!!
! is_even(4), is_even(7) = T F
