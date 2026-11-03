! -----------------------------------------------------------------------------
! 10_procedure_prefixes.f90 - combining prefixes and suffixes
!
! Run:  scripts/run.sh 13-procedure-attributes/10_procedure_prefixes.f90
! -----------------------------------------------------------------------------
!
! Full form of a procedure heading:
!
!   [prefix...] function name ([dummies]) [result(r)] [bind(c [, name=])]
!   [prefix...] subroutine name [([dummies])] [bind(c [, name=])]
!
! prefix (any order, each at most once):
!   type-spec           integer, real(dp), type(point), ...   (functions)
!   pure | impure       impure is the default (except for elemental)
!   simple              F2023, implies pure
!   elemental           implies pure unless impure is given
!   recursive | non_recursive
!   module              separate module procedure (chapter 15)
!
! Invalid combinations: pure + impure, recursive + non_recursive,
! elemental + bind(c), simple + impure.

module prefixes
  use, intrinsic :: iso_c_binding, only: c_int
  implicit none (type, external)
contains

  pure elemental integer function sign_of(x) result(s)
    real, intent(in) :: x
    s = merge(1, merge(-1, 0, x < 0), x > 0)
  end function sign_of

  recursive pure integer function fib(n) result(f)
    integer, intent(in) :: n
    if (n < 2) then
      f = n
    else
      f = fib(n - 1) + fib(n - 2)
    end if
  end function fib

  impure elemental subroutine show(x)
    real, intent(in) :: x
    write (*, '(1x, f0.1)', advance='no') x
  end subroutine show

  integer(c_int) function c_callable(n) bind(c, name='c_callable')
    integer(c_int), value :: n
    c_callable = 2 * n
  end function c_callable

end module prefixes

program procedure_prefixes
  use prefixes, only: sign_of, fib, show, c_callable
  implicit none (type, external)

  print '(a, *(1x, i0))', 'sign_of:', sign_of([-3.0, 0.0, 2.0])
  print '(a, i0)', 'fib(20) = ', fib(20)
  write (*, '(a)', advance='no') 'show:'
  call show([1.0, 2.0, 3.0])
  print '(a)', ''
  print '(a, i0)', 'c_callable(21) = ', c_callable(21)

end program procedure_prefixes

! Output:
! sign_of: -1 0 1
! fib(20) = 6765
! show: 1.0 2.0 3.0
! c_callable(21) = 42
