! -----------------------------------------------------------------------------
! 06_volatile.f90 - VOLATILE
!
! Run:  scripts/run.sh 04-declarations/06_volatile.f90
! -----------------------------------------------------------------------------
!
! VOLATILE tells the compiler that a variable can be read or changed by
! means outside the program's visible control flow: another thread, a signal
! handler, memory-mapped hardware, or C code holding its address. The
! compiler must then reload it from memory at every reference instead of
! keeping it in a register, and cannot remove "useless" stores.
!
! VOLATILE is not a synchronisation mechanism: it does not make updates
! atomic and does not order memory between threads. Use atomics, OpenMP or
! coarray synchronisation for that.
!
! Related: ASYNCHRONOUS (chapter 23) is the weaker attribute for variables
! involved in asynchronous I/O or non-blocking MPI.

program volatile_demo
  implicit none (type, external)

  integer, volatile :: status_flag
  integer :: polls

  status_flag = 0
  polls = 0

  ! Without VOLATILE an optimising compiler could hoist the load out of the
  ! loop and spin forever if another agent set the flag. Here we set it
  ! ourselves after a few iterations, so the example terminates.
  do while (status_flag == 0)
    polls = polls + 1
    if (polls == 3) status_flag = 1
  end do

  print '(a, i0, a)', 'flag observed after ', polls, ' polls'

end program volatile_demo

! Output:
! flag observed after 3 polls
