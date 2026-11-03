! -----------------------------------------------------------------------------
! 03_do_loops.f90 - every form of the DO construct
!
! Run:  scripts/run.sh 06-control-flow/03_do_loops.f90
! -----------------------------------------------------------------------------
!
!   do i = start, stop [, step]     counted loop
!   do while (logical-expr)         loop while true (tested before each trip)
!   do                              infinite loop: leave with EXIT
!   do concurrent (...)             independent iterations (chapter 28)
!
! Counted-loop semantics - computed ONCE, before the first iteration:
!   * iteration count = max((stop - start + step) / step, 0)
!   * so changing start/stop/step inside the loop has no effect,
!   * a zero or negative count means the body never runs ("zero-trip"),
!   * the loop variable must be an INTEGER (real loop variables were
!     deleted from the language),
!   * the body must not assign to the loop variable,
!   * after normal completion the variable holds the value it would have on
!     the next iteration (start + count*step).
! step defaults to 1 and must not be 0.

program do_loops
  implicit none (type, external)

  integer :: i, n, total

  ! Counted loop.
  total = 0
  do i = 1, 5
    total = total + i
  end do
  print '(a, i0, a, i0)', 'sum 1..5 = ', total, ', i after loop = ', i

  ! With a step, counting down.
  write (*, '(a)', advance='no') 'countdown:'
  do i = 10, 1, -3
    write (*, '(1x, i0)', advance='no') i
  end do
  print '(a)', ''

  ! Zero-trip loop: start > stop with positive step.
  n = 0
  do i = 5, 1
    n = n + 1
  end do
  print '(a, i0, a)', 'zero-trip body ran ', n, ' times'

  ! Bounds are evaluated once: changing n inside does not extend the loop.
  n = 3
  total = 0
  do i = 1, n
    n = n + 1
    total = total + 1
  end do
  print '(a, i0, a, i0)', 'iterations: ', total, ', n is now ', n

  ! DO WHILE.
  n = 1
  do while (n < 100)
    n = n * 3
  end do
  print '(a, i0)', 'first power of 3 >= 100: ', n

  ! Infinite DO with EXIT - often clearer than DO WHILE when the test
  ! belongs in the middle of the body.
  n = 27
  i = 0
  do
    if (n == 1) exit
    n = merge(n / 2, 3 * n + 1, mod(n, 2) == 0)
    i = i + 1
  end do
  print '(a, i0)', 'Collatz steps for 27: ', i

end program do_loops

! Output:
! sum 1..5 = 15, i after loop = 6
! countdown: 10 7 4 1
! zero-trip body ran 0 times
! iterations: 3, n is now 6
! first power of 3 >= 100: 243
! Collatz steps for 27: 111
