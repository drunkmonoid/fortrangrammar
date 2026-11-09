! -----------------------------------------------------------------------------
! scale.f90 - double each element of a contiguous buffer
!
! Build: scripts/run.sh 57-cxx-interop/01_vector/
! -----------------------------------------------------------------------------

subroutine scale(n, x) bind(c, name='scale')
  use, intrinsic :: iso_c_binding, only: c_int, c_double
  implicit none (type, external)
  integer(c_int), value, intent(in) :: n
  real(c_double), intent(inout) :: x(n)
  integer :: i

  do i = 1, n
    x(i) = 2.0_c_double * x(i)
  end do
end subroutine scale
