! @flags -fcoarray=single
! -----------------------------------------------------------------------------
! 01_ring_halo.f90 - 1-D periodic ring halo exchange with sync images
!
! Single-image compilation:
!   gfortran -std=f2023 -fcoarray=single 01_ring_halo.f90
!
! Multi-image compilation and execution (e.g. with OpenCoarrays):
!   caf -std=f2023 01_ring_halo.f90 -o ring_halo
!   cafrun -n 4 ./ring_halo
! -----------------------------------------------------------------------------
!
! Deadlock note on pairwise sync images:
! For an image control statement `sync images(list)` to complete between two
! images P and Q, both images must execute a matching statement naming each
! other. If image P executes `sync images(left)` while image `left` executes
! `sync images(its_left)`, every image waits on a different partner in a
! circular dependency chain, resulting in a permanent deadlock.
!
! By providing the symmetric neighbour list `[left, right]` (or by ordering
! communication into odd/even color passes), both directions complete
! without circular waiting.

program ring_halo
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer, parameter :: n = 4
  integer :: u(0:n+1)[*]
  integer :: me, n_images, left, right, i

  me = this_image()
  n_images = num_images()

  ! Compute periodic 1-based neighbours in ring
  left = merge(n_images, me - 1, me == 1)
  right = merge(1, me + 1, me == n_images)

  ! Initialise interior cells
  u(0) = 0
  u(n+1) = 0
  do i = 1, n
    u(i) = me * 10 + i
  end do

  ! Remote write edges to neighbours' halo positions:
  ! Send left boundary u(1) to left neighbour's right halo u(n+1)
  u(n+1)[left] = u(1)
  ! Send right boundary u(n) to right neighbour's left halo u(0)
  u(0)[right]  = u(n)

  ! Synchronise with neighbours.
  ! In single-image mode, an image-set array must not contain duplicate values,
  ! so we pass scalar 1.
  if (n_images == 1) then
    sync images(1)
  else
    sync images([left, right])
  end if

  ! On image 1, print verified halo and checksum
  if (me == 1) then
    write(output_unit, '(a,*(1x,i0))') 'Halo cells (left, right):', u(0), u(n+1)
    write(output_unit, '(a,1x,i0)') 'Interior checksum:', sum(u(1:n))
    write(output_unit, '(a,1x,i0)') 'Full grid checksum:', sum(u(0:n+1))
  end if

end program ring_halo

! Output:
! Halo cells (left, right): 14 11
! Interior checksum: 50
! Full grid checksum: 75
