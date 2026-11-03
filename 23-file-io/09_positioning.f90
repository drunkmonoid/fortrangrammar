! -----------------------------------------------------------------------------
! 09_positioning.f90 - REWIND, BACKSPACE, ENDFILE, FLUSH
!
! Run:  scripts/run.sh 23-file-io/09_positioning.f90
! -----------------------------------------------------------------------------
!
!   rewind (u)       go to the beginning of the file
!   backspace (u)    go back one record (sequential files)
!   endfile (u)      write an end-of-file: the file is truncated here
!                    (afterwards BACKSPACE or REWIND before further I/O)
!   flush (u)        make written data visible to other processes / readers
!                    (F2003); also flushes standard output
!
! All accept iostat= and iomsg=. BACKSPACE is often slow and not allowed
! on some devices; prefer re-reading or stream access with pos=.

program positioning
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer :: u, i, ios, value

  open (newunit=u, status='scratch')
  do i = 1, 5
    write (u, '(i0)') i * 10
  end do

  rewind (u)
  read (u, *) value
  print '(a, i0)', 'after rewind, first record : ', value

  read (u, *) value
  backspace (u)
  read (u, *) value
  print '(a, i0)', 'backspace re-reads record  : ', value

  ! We are positioned after record 2: truncate the file here.
  endfile (u)
  rewind (u)
  write (output_unit, '(a)', advance='no') 'file now holds:'
  do
    read (u, *, iostat=ios) value
    if (ios /= 0) exit
    write (output_unit, '(1x, i0)', advance='no') value
  end do
  print '(a)', ''
  close (u)

  flush (output_unit)

end program positioning

! Output:
! after rewind, first record : 10
! backspace re-reads record  : 20
! file now holds: 10 20
