! -----------------------------------------------------------------------------
! 10_asynchronous.f90 - asynchronous I/O and WAIT (F2003)
!
! Run:  scripts/run.sh 23-file-io/10_asynchronous.f90
! -----------------------------------------------------------------------------
!
!   open (newunit=u, ..., asynchronous='yes')
!   write (u, asynchronous='yes', id=req) big_array      ! may return early
!   ... do other work, but do NOT touch big_array ...
!   wait (u, id=req)                                      ! now it is done
!
! * Data in a pending transfer must have the ASYNCHRONOUS attribute (given
!   implicitly in the scope of the statement; declare it explicitly in
!   other scopes that access the variable while a transfer is pending).
! * The processor MAY perform the transfer synchronously; the program must
!   be correct either way.
! * inquire(unit, id=req, pending=p) tests completion without waiting.
! * CLOSE, REWIND, etc. also wait for pending transfers.

program asynchronous_io
  implicit none (type, external)

  integer :: u, req
  real, asynchronous, allocatable :: buffer(:), back(:)
  logical :: pending

  allocate (buffer(1000000), back(1000000))
  buffer = 1.0

  open (newunit=u, status='scratch', form='unformatted', access='stream', &
        asynchronous='yes')

  write (u, asynchronous='yes', id=req) buffer
  inquire (unit=u, id=req, pending=pending)
  print '(a, l1)', 'pending right after write (may be F): ', pending
  ! ... independent computation could run here ...
  wait (u, id=req)
  print '(a)', 'write completed'

  read (u, pos=1, asynchronous='yes', id=req) back
  wait (u, id=req)
  print '(a, l1)', 'read back identical: ', all(back == buffer)
  close (u)

end program asynchronous_io
