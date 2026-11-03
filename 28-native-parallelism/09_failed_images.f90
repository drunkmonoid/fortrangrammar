! @flags -fcoarray=single
! -----------------------------------------------------------------------------
! 09_failed_images.f90 - fault tolerance (F2018)
!
! Run:  scripts/run.sh 28-native-parallelism/09_failed_images.f90
! -----------------------------------------------------------------------------
!
! F2018 lets a program survive the failure of some images (support is
! optional and requires a capable runtime):
!
!   failed_images([team] [, kind])    indices of images known to have failed
!   stopped_images([team] [, kind])   indices of images that executed STOP
!   image_status(image [, team])      0, stat_failed_image or
!                                     stat_stopped_image
!   fail image                        simulate a failure of this image
!   stat= on image control statements returns stat_failed_image instead
!   of terminating.
!
! A resilient program checks stat= on every sync and redistributes work of
! failed images.

program failed_images_demo
  use, intrinsic :: iso_fortran_env, only: stat_failed_image, stat_stopped_image
  implicit none (type, external)

  integer :: status

  sync all (stat=status)
  print '(a, i0)', 'sync all stat          = ', status
  print '(a, i0)', 'size(failed_images())  = ', size(failed_images())
  print '(a, i0)', 'size(stopped_images()) = ', size(stopped_images())
  print '(a, i0)', 'image_status(1)        = ', image_status(1)
  print '(a, i0, 1x, i0)', 'stat_failed/stopped    = ', stat_failed_image, stat_stopped_image

end program failed_images_demo

! Output:
! sync all stat          = 0
! size(failed_images())  = 0
! size(stopped_images()) = 0
! image_status(1)        = 0
! stat_failed/stopped    = 6001 6000
