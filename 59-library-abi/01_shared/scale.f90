! -----------------------------------------------------------------------------
! scale.f90 - the private module behind the C API in scale.h
!
! Build: scripts/run.sh 59-library-abi/01_shared/
! -----------------------------------------------------------------------------
!
! The module is not part of the ABI. Callers link the shared library and
! include scale.h.

module scale_m
  use, intrinsic :: iso_c_binding, only: c_int, c_double
  implicit none (type, external)
  private
  public :: library_version, scale

contains

  integer(c_int) function library_version() result(version) bind(c, name='library_version')
    version = 1
  end function library_version

  subroutine scale(n, x) bind(c, name='scale')
    integer(c_int), value, intent(in) :: n
    real(c_double), intent(inout) :: x(n)
    integer :: i
    do i = 1, n
      x(i) = 2.0_c_double * x(i)
    end do
  end subroutine scale

end module scale_m
