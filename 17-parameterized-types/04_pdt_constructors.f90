! @build skip gfortran 15 rejects PDT structure constructors and kind-dependent default init
! -----------------------------------------------------------------------------
! 04_pdt_constructors.f90 - standard PDT syntax gfortran 15 does not accept
!
! Run:  needs a compiler with complete PDT support (e.g. ifx, nagfor, flang)
! -----------------------------------------------------------------------------
!
! Structure constructor of a parameterized type:
!
!   point(real64)(1.0_real64, 2.0_real64)      type parameters, then values
!   point(k=real64)(x=1.0_real64, y=2.0_real64)
!   point(1.0, 2.0)                            all parameters defaulted
!
! Default initialisation that depends on a kind parameter:
!
!   real(k) :: x = 0                           converted to real(k)
!
! gfortran 15 reports "Unclassifiable statement" for the first and
! "Cannot convert INTEGER(4) to REAL(0)" for the second. PDTs are the least
! mature area of most compilers - test them on every compiler you target.

module pdt_full
  use, intrinsic :: iso_fortran_env, only: real32, real64
  implicit none (type, external)

  type :: point(k)
    integer, kind :: k = real32
    real(k) :: x = 0, y = 0
  end type point

  type :: buffer(k, n)
    integer, kind :: k = real64
    integer, len :: n = 4
    real(k) :: data(n) = 0
  end type buffer

end module pdt_full

program pdt_constructors
  use, intrinsic :: iso_fortran_env, only: real64
  use pdt_full, only: point, buffer
  implicit none (type, external)

  type(point) :: a
  type(point(real64)) :: b
  type(buffer(real64, 3)) :: c

  a = point(1.0, 2.0)
  b = point(real64)(x=1.0_real64, y=2.0_real64)
  c = buffer(real64, 3)([1, 2, 3])

  print *, a%x, b%y, c%data

end program pdt_constructors
