! -----------------------------------------------------------------------------
! fill.f90 - a bind(c) kernel that fills a contiguous real64 array
!
! Build: scripts/run.sh 56-python-interop/01_ctypes/
! -----------------------------------------------------------------------------
!
! n is passed by value. The array is a C pointer to n doubles. Element
! i (Fortran, starting at 1) becomes i.

subroutine fill(n, a) bind(c, name='fill')
  use, intrinsic :: iso_c_binding, only: c_int, c_double
  implicit none (type, external)
  integer(c_int), value, intent(in) :: n
  real(c_double), intent(out) :: a(n)
  integer :: i

  do i = 1, n
    a(i) = real(i, c_double)
  end do
end subroutine fill
