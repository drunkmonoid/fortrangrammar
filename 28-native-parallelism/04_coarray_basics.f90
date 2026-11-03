! @flags -fcoarray=single
! -----------------------------------------------------------------------------
! 04_coarray_basics.f90 - images, codimensions, remote access (F2008)
!
! Run:  scripts/run.sh 28-native-parallelism/04_coarray_basics.f90   (1 image)
!       caf 04_coarray_basics.f90 && cafrun -n 4 ./a.out            (OpenCoarrays)
! -----------------------------------------------------------------------------
!
! A coarray program runs as N IMAGES: N copies of the program, each with
! its own memory, executing asynchronously (SPMD). An image index runs
! from 1 to num_images().
!
!   integer :: x[*]              a COARRAY: every image has an x
!   real :: a(10)[*]             array coarray
!   real :: m(4)[2, *]           codimensions can be multi-dimensional
!   real, allocatable :: b(:)[:] allocatable coarray (allocate b(n)[*])
!
!   x            the local copy
!   x[k]         image k's copy (a remote read or write: "one-sided")
!   this_image() / num_images()
!
! Remote accesses must be ordered by SEGMENT boundaries: SYNC ALL (or
! other image control statements) separate writes on one image from reads
! on another.
!
! gfortran: -fcoarray=single (one image, no library), or -fcoarray=lib with
! OpenCoarrays (the `caf` / `cafrun` wrappers). Intel ifx: -coarray.
! Cray/HPE: native.

program coarray_basics
  implicit none (type, external)

  integer :: x[*]
  real, allocatable :: work(:)[:]
  integer :: me, n, left

  me = this_image()
  n = num_images()

  x = 10 * me                       ! each image writes its own copy
  sync all                          ! all writes done before any reads

  left = merge(n, me - 1, me == 1)  ! ring neighbour
  print '(a, i0, a, i0, a, i0, a, i0)', 'image ', me, ' of ', n, ': my x = ', x, &
      ', left neighbour x = ', x[left]

  allocate (work(3)[*])             ! collective: every image allocates
  work = real(me)
  sync all
  if (me == 1) print '(a, *(1x, f0.1))', 'image 1 reads work[n]:', work(:)[n]
  deallocate (work)                 ! also collective

end program coarray_basics

! Output:
! image 1 of 1: my x = 10, left neighbour x = 10
! image 1 reads work[n]: 1.0 1.0 1.0
