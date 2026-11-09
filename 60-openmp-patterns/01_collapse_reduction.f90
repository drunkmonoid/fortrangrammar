! @flags -fopenmp
! -----------------------------------------------------------------------------
! 01_collapse_reduction.f90 - collapse, reduction, simd
!
! Run:  scripts/run.sh 60-openmp-patterns/01_collapse_reduction.f90
! -----------------------------------------------------------------------------
!
! collapse(2) hands the (i, j) pairs out as one iteration space. The
! loop indices are private. reduction(+: s) gives each thread a private
! s and adds those copies at the end, so the result does not depend on
! which thread ran which pair.
!
! The racy form, not compiled here, is a shared s updated from the loop:
!
!   s = 0
!   !$omp parallel do
!   do i = 1, 4
!     s = s + i          ! two threads can read the same s
!   end do
!
! That needs reduction(+: s), or a private partial sum.

program collapse_reduction
  implicit none (type, external)

  integer :: i, j, s, t

  s = 0
  !$omp parallel do collapse(2) reduction(+: s)
  do j = 1, 3
    do i = 1, 4
      s = s + i
    end do
  end do
  !$omp end parallel do

  t = 0
  !$omp simd reduction(+: t)
  do i = 1, 4
    t = t + i
  end do
  !$omp end simd

  print '(a, i0)', 'collapse = ', s
  print '(a, i0)', 'simd = ', t

end program collapse_reduction

! Output:
! collapse = 30
! simd = 10
