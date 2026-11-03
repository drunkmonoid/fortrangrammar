! @flags -fcoarray=single
! -----------------------------------------------------------------------------
! 07_locks_events_atomics.f90 - LOCK, EVENTS, ATOMIC subroutines
!
! Run:  scripts/run.sh 28-native-parallelism/07_locks_events_atomics.f90
!       caf 07_locks_events_atomics.f90 && cafrun -n 4 ./a.out
! -----------------------------------------------------------------------------
!
! LOCKS (lock_type from iso_fortran_env, always a coarray):
!   lock (l[k] [, acquired_lock=got] [, stat=])   unlock (l[k])
!   With acquired_lock= the statement does not block: got tells whether
!   the lock was obtained.
!
! EVENTS (event_type, F2018): a counting semaphore.
!   event post (ev[k])               increment image k's event count
!   event wait (ev [, until_count=n]) wait for the LOCAL event, decrement
!   call event_query(ev, count)      current count, non-blocking
!
! ATOMICS (on integer(atomic_int_kind) / logical(atomic_logical_kind)
! coarrays): indivisible updates without locks:
!   atomic_define(a[k], v)   atomic_ref(v, a[k])
!   atomic_add/and/or/xor(a[k], v)
!   atomic_fetch_add/and/or/xor(a[k], v, old)
!   atomic_cas(a[k], old, compare, new)          compare-and-swap

program locks_events_atomics
  use, intrinsic :: iso_fortran_env, only: lock_type, event_type, atomic_int_kind
  implicit none (type, external)

  type(lock_type) :: queue_lock[*]
  type(event_type) :: ready[*]
  integer(atomic_int_kind) :: hits[*]
  integer(atomic_int_kind) :: old, value
  integer :: me, n, count
  logical :: got

  me = this_image()
  n = num_images()

  ! Lock on image 1 protecting a shared resource.
  lock (queue_lock[1], acquired_lock=got)
  if (got) then
    print '(a, i0, a)', 'image ', me, ' got the lock without waiting'
    unlock (queue_lock[1])
  else
    lock (queue_lock[1])
    print '(a, i0, a)', 'image ', me, ' waited for the lock'
    unlock (queue_lock[1])
  end if

  ! Atomic counter on image 1.
  if (me == 1) call atomic_define(hits, 0_atomic_int_kind)
  sync all
  call atomic_fetch_add(hits[1], 1_atomic_int_kind, old)
  sync all
  if (me == 1) then
    call atomic_ref(value, hits)
    print '(a, i0, a, i0)', 'atomic hits = ', value, ', expected ', n
  end if

  ! Events: every image signals image 1, which waits for all of them.
  event post (ready[1])
  if (me == 1) then
    event wait (ready, until_count=n)
    call event_query(ready, count)
    print '(a, i0, a, i0)', 'image 1 received ', n, ' events, remaining count ', count
  end if

end program locks_events_atomics

! Output:
! image 1 got the lock without waiting
! atomic hits = 1, expected 1
! image 1 received 1 events, remaining count 0
