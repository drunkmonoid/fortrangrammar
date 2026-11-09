! -----------------------------------------------------------------------------
! 02_corrected.f90 - the loop bound is the array size, and x is defined
!
! Run:  scripts/run.sh 72-debugging-numerics/02_corrected.f90
! -----------------------------------------------------------------------------
!
! The trip count comes from size(a), so the subscript stays inside the
! array. x is given a value before anything reads it. The sum of
! 1..5 is 15.

program corrected
  implicit none (type, external)

  integer :: a(5), i
  real :: x

  x = 0
  do i = 1, size(a)
    a(i) = i
  end do
  x = real(sum(a))
  print '(a, i0)', 'sum = ', sum(a)
  print '(a, i0)', 'x = ', nint(x)

end program corrected

! Output:
! sum = 15
! x = 15
