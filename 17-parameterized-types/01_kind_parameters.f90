! -----------------------------------------------------------------------------
! 01_kind_parameters.f90 - KIND type parameters
!
! Run:  scripts/run.sh 17-parameterized-types/01_kind_parameters.f90
! -----------------------------------------------------------------------------
!
!   type :: point(k)
!     integer, kind :: k = real32        ! a KIND parameter, with a default
!     real(k) :: x, y                    ! used like any kind value
!   end type point
!
! gfortran 15 limitations worked around here (see 04_pdt_constructors.f90
! for the standard syntax): no default initialisation of components whose
! kind depends on k, and no structure constructor point(real64)(x, y).
!
!   type(point) :: a                     ! k = real32 (the default)
!   type(point(real64)) :: b             ! positional
!   type(point(k=real128)) :: c          ! keyword
!
! * Kind parameters must be compile-time constants, like intrinsic kinds.
!   Different kind values make DIFFERENT types: a point(real32) cannot be
!   passed where a point(real64) is expected.
! * They are written in the type's parameter list AND declared inside as
!   `integer, kind ::`.
! * Inquiry: b%k gives the parameter value (it is not a component).
! * Procedures must be written per kind; a generic interface hides that.

module pdt_kinds
  use, intrinsic :: iso_fortran_env, only: real32, real64, real128
  implicit none (type, external)

  type :: point(k)
    integer, kind :: k = real32
    real(k) :: x, y
  end type point

  interface norm
    module procedure norm32, norm64
  end interface

contains

  real(real32) function norm32(p)
    type(point(real32)), intent(in) :: p
    norm32 = hypot(p%x, p%y)
  end function norm32

  real(real64) function norm64(p)
    type(point(real64)), intent(in) :: p
    norm64 = hypot(p%x, p%y)
  end function norm64

end module pdt_kinds

program kind_parameters
  use, intrinsic :: iso_fortran_env, only: real32, real64
  use pdt_kinds, only: point, norm
  implicit none (type, external)

  type(point) :: a                       ! default k = real32
  type(point(real64)) :: b
  type(point(k=real64)) :: c

  a%x = 1.0
  a%y = 1.0
  b%x = 1.0_real64
  b%y = 1.0_real64
  c = b

  print '(a, i0, a, g0)', 'a%k = ', a%k, ', norm(a) = ', norm(a)
  print '(a, i0, a, g0)', 'b%k = ', b%k, ', norm(b) = ', norm(b)
  print '(a, i0)', 'kind(c%x) = ', kind(c%x)

end program kind_parameters

! Output:
! a%k = 4, norm(a) = 1.41421354
! b%k = 8, norm(b) = 1.4142135623730951
! kind(c%x) = 8
