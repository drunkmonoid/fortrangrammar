! -----------------------------------------------------------------------------
! 07_number_conversion.f90 - numbers <-> strings with internal I/O
!
! Run:  scripts/run.sh 10-characters/07_number_conversion.f90
! -----------------------------------------------------------------------------
!
! Fortran has no str()/atoi(): conversion uses INTERNAL FILES - READ and
! WRITE on a character variable instead of a unit.
!
!   write (buffer, '(i0)') n        integer -> text (minimal width)
!   write (buffer, '(g0)') x        any intrinsic value -> text
!   read (text, *, iostat=ios) n    text -> integer, ios /= 0 on bad input
!
! The buffer must be long enough; wrap the pattern in functions returning a
! deferred-length string so callers never see the buffer.

module str_convert
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)
  private
  public :: to_string, parse_int, parse_real

  interface to_string
    module procedure int_to_string, real_to_string
  end interface

contains

  function int_to_string(n) result(s)
    integer, intent(in) :: n
    character(len=:), allocatable :: s
    character(len=32) :: buffer

    write (buffer, '(i0)') n
    s = trim(buffer)
  end function int_to_string

  function real_to_string(x, fmt) result(s)
    real(dp), intent(in) :: x
    character(len=*), intent(in), optional :: fmt
    character(len=:), allocatable :: s
    character(len=64) :: buffer

    if (present(fmt)) then
      write (buffer, '(' // fmt // ')') x
    else
      write (buffer, '(g0)') x
    end if
    s = trim(adjustl(buffer))
  end function real_to_string

  subroutine parse_int(text, n, ok)
    character(len=*), intent(in) :: text
    integer, intent(out) :: n
    logical, intent(out) :: ok
    integer :: ios

    read (text, *, iostat=ios) n
    ok = ios == 0
  end subroutine parse_int

  subroutine parse_real(text, x, ok)
    character(len=*), intent(in) :: text
    real(dp), intent(out) :: x
    logical, intent(out) :: ok
    integer :: ios

    read (text, *, iostat=ios) x
    ok = ios == 0
  end subroutine parse_real

end module str_convert

program number_conversion
  use, intrinsic :: iso_fortran_env, only: dp => real64
  use str_convert, only: to_string, parse_int, parse_real
  implicit none (type, external)

  integer :: n
  real(dp) :: x
  logical :: ok

  print '(a)', 'file_' // to_string(7) // '.dat'
  print '(a)', 'pi = ' // to_string(acos(-1.0_dp))
  print '(a)', 'pi = ' // to_string(acos(-1.0_dp), 'f0.3')
  print '(a)', 'big = ' // to_string(6.02214076e23_dp, 'es12.4')

  call parse_int('  123 ', n, ok)
  print '(a, l1, a, i0)', "parse_int('  123 '): ok=", ok, ' n=', n
  call parse_int('12x', n, ok)
  print '(a, l1)', "parse_int('12x')   : ok=", ok
  call parse_real('-2.5e-3', x, ok)
  print '(a, l1, a, es10.3)', "parse_real('-2.5e-3'): ok=", ok, ' x=', x

end program number_conversion

! Output:
! file_7.dat
! pi = 3.1415926535897931
! pi = 3.142
! big = 6.0221E+23
! parse_int('  123 '): ok=T n=123
! parse_int('12x')   : ok=F
! parse_real('-2.5e-3'): ok=T x=-2.500E-03
