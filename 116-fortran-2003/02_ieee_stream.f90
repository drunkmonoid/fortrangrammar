! @flags -std=f2003
! -----------------------------------------------------------------------------
! 02_ieee_stream.f90 - ieee_is_finite, c_loc, and one unformatted stream value
!
! Run:  scripts/run.sh 116-fortran-2003/02_ieee_stream.f90
! -----------------------------------------------------------------------------

program f2003_io
  use, intrinsic :: ieee_arithmetic, only: ieee_is_finite
  use, intrinsic :: iso_c_binding, only: c_associated, c_int, c_loc
  implicit none

  integer(c_int), target :: n
  integer :: stored

  n = 4
  open (unit=10, status='scratch', access='stream', form='unformatted')
  write (10) n
  read (10, pos=1) stored
  close (10)
  print '(l1, 1x, l1, 1x, i0)', ieee_is_finite(1.0), c_associated(c_loc(n)), stored

end program f2003_io

! Output:
! T T 4
