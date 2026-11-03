! @flags -fcoarray=single
! -----------------------------------------------------------------------------
! 05_synchronisation.f90 - SYNC ALL, SYNC IMAGES, SYNC MEMORY, CRITICAL
!
! Run:  scripts/run.sh 28-native-parallelism/05_synchronisation.f90
!       caf 05_synchronisation.f90 && cafrun -n 4 ./a.out
! -----------------------------------------------------------------------------
!
! IMAGE CONTROL STATEMENTS divide execution into segments:
!
!   sync all                       barrier over all images
!   sync images (list | *)         pairwise: wait for the listed images,
!                                  which must execute a matching sync images
!   sync memory                    memory fence (for user-built protocols)
!   critical ... end critical      one image at a time in the block
!   lock / unlock, event post / wait, form / change / end team, sync team,
!   allocate / deallocate of coarrays, stop / end program
!
! All accept stat= and errmsg= (stat_stopped_image, stat_failed_image ...).

program synchronisation
  implicit none (type, external)

  integer :: token[*]
  integer :: total[*]
  integer :: me, n, i

  me = this_image()
  n = num_images()

  ! A token passed around a ring with SYNC IMAGES.
  if (me == 1) then
    token = 1
  else
    sync images (me - 1)             ! wait until the left image is done
    token = token[me - 1] + 1
  end if
  if (me < n) sync images (me + 1)   ! release the right neighbour
  print '(a, i0, a, i0)', 'image ', me, ' holds token ', token

  ! CRITICAL: serialised update of a value on image 1.
  total = 0
  sync all
  critical
    total[1] = total[1] + me
  end critical
  sync all
  if (me == 1) print '(a, i0, a, i0)', 'sum of image numbers = ', total, &
      ', expected ', sum([(i, i = 1, n)])

end program synchronisation

! Output:
! image 1 holds token 1
! sum of image numbers = 1, expected 1
