! @flags -std=f2008 -fcoarray=single
! -----------------------------------------------------------------------------
! 03_coarray.f90 - one image, so this_image and num_images are both 1
!
! Run:  scripts/run.sh 117-fortran-2008/03_coarray.f90
! -----------------------------------------------------------------------------

program f2008_coarray
  implicit none

  integer :: slot[*]

  slot = this_image()
  print '(i0, 1x, i0, 1x, i0)', this_image(), num_images(), slot

end program f2008_coarray

! Output:
! 1 1 1
