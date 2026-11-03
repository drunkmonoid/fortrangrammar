! -----------------------------------------------------------------------------
! 01_do_concurrent.f90 - DO CONCURRENT (F2008)
!
! Run:  scripts/run.sh 28-native-parallelism/01_do_concurrent.f90
! -----------------------------------------------------------------------------
!
!   do concurrent (i = 1:n, j = 1:m [, mask])  [locality-specs]
!     ...
!   end do
!
! The programmer ASSERTS that iterations are independent: they may run in
! any order, interleaved, vectorised or in parallel. The compiler does not
! check this in general - a loop with dependences gives wrong results.
!
! Header: index-name = lower:upper[:stride], several indices separated by
! commas, plus an optional logical MASK selecting iterations. (The standard
! also allows a leading `integer ::` type-spec; gfortran 15 rejects it.)
!
! Body restrictions: only PURE procedures may be called; no EXIT, no RETURN,
! no branch out (CYCLE is fine); no image control statements; a variable
! assigned in one iteration must not be read by another.
!
! Whether it really runs in parallel is up to the compiler:
! gfortran -ftree-parallelize-loops=N, nvfortran -stdpar=gpu, ifx -fopenmp
! with -fopenmp-target-do-concurrent, flang -fdo-concurrent-to-openmp.

program do_concurrent_demo
  implicit none (type, external)

  integer, parameter :: n = 6
  real :: a(n), b(n), grid(3, 4)
  integer :: i, j

  b = [(real(i), i = 1, n)]

  do concurrent (i = 1:n)
    a(i) = sqrt(b(i)) + 1
  end do
  print '(a, *(1x, f0.3))', 'a =', a

  ! Two indices: every (i, j) pair is independent.
  do concurrent (i = 1:3, j = 1:4)
    grid(i, j) = 10 * i + j
  end do
  print '(a, *(1x, f0.0))', 'grid(2, :) =', grid(2, :)

  ! A mask selects iterations.
  a = 0
  do concurrent (i = 1:n, mod(i, 2) == 0)
    a(i) = b(i)**2
  end do
  print '(a, *(1x, f0.0))', 'even squares =', a

  ! Strides work like in DO.
  do concurrent (i = n:1:-2)
    a(i) = -1
  end do
  print '(a, *(1x, f0.0))', 'stride -2 =', a

end program do_concurrent_demo

! Output:
! a = 2.000 2.414 2.732 3.000 3.236 3.449
! grid(2, :) = 21. 22. 23. 24.
! even squares = 0. 4. 0. 16. 0. 36.
! stride -2 = 0. -1. 0. -1. 0. -1.
