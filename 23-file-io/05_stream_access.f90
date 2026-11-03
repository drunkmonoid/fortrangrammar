! -----------------------------------------------------------------------------
! 05_stream_access.f90 - byte streams (F2003)
!
! Run:  scripts/run.sh 23-file-io/05_stream_access.f90
! -----------------------------------------------------------------------------
!
!   open (newunit=u, access='stream', form='unformatted', ...)
!
! Stream access treats the file as a sequence of bytes ("file storage
! units") with NO record structure and no record markers - exactly what C
! fread/fwrite produce. That makes it the way to read and write binary
! formats defined by other software.
!
! * pos=p in READ/WRITE positions at byte p (1-based).
! * inquire(unit, pos=p) returns the current position, size=s the file size.
! * Formatted stream files are text; new_line('a') or '/' writes line ends.

program stream_access
  use, intrinsic :: iso_fortran_env, only: int32, real64
  implicit none (type, external)

  integer :: u, file_size, position
  integer(int32) :: header, value
  real(real64) :: x
  character(len=*), parameter :: path = 'tutorial_23_05.bin'

  open (newunit=u, file=path, status='replace', access='stream', form='unformatted')
  write (u) 1179011410_int32               ! a 4-byte "magic number"
  write (u) 7_int32, 2.5_real64            ! 4 + 8 bytes, no markers
  inquire (unit=u, pos=position, size=file_size)
  print '(a, i0, a, i0)', 'after writing: pos=', position, ' size=', file_size
  close (u)

  open (newunit=u, file=path, status='old', access='stream', form='unformatted')
  read (u) header
  read (u, pos=9) x                         ! jump straight to byte 9
  read (u, pos=5) value                     ! and back to byte 5
  print '(a, i0, a, i0, a, f0.2)', 'header=', header, ' value=', value, ' x=', x
  close (u, status='delete')

  ! Formatted stream: text without record bookkeeping.
  open (newunit=u, status='scratch', access='stream', form='formatted')
  write (u, '(a)') 'line one'
  write (u, '(a)', advance='no') 'line two' // new_line('a')
  flush (u)                                 ! inquire(size=) sees flushed bytes
  inquire (unit=u, size=file_size)
  print '(a, i0, a)', 'formatted stream holds ', file_size, ' bytes'
  close (u)

end program stream_access

! Output:
! after writing: pos=17 size=16
! header=1179011410 value=7 x=2.50
! formatted stream holds 18 bytes
