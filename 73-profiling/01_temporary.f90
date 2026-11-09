! -----------------------------------------------------------------------------
! 01_temporary.f90 - a whole-array expression and the loop that avoids it
!
! Run:  scripts/run.sh 73-profiling/01_temporary.f90
! -----------------------------------------------------------------------------
!
!   b = a + a
!
! is allowed to evaluate the right-hand side into a temporary and then
! copy it into b. The loop writes c(i) from a(i) with no extra array.
! -Warray-temporaries reports the copy when the compiler makes one.
! The sums match either way: 2 * (1+2+3+4) = 20.

program temporary
  implicit none (type, external)

  integer :: a(4), b(4), c(4), i

  a = [1, 2, 3, 4]
  b = a + a
  do i = 1, size(a)
    c(i) = a(i) + a(i)
  end do

  print '(a, i0)', 'expression = ', sum(b)
  print '(a, i0)', 'loop = ', sum(c)

end program temporary

! Output:
! expression = 20
! loop = 20
