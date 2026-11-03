! -----------------------------------------------------------------------------
! 01_open_close.f90 - connecting files to units
!
! Run:  scripts/run.sh 23-file-io/01_open_close.f90
! -----------------------------------------------------------------------------
!
!   open (newunit=u, file='name', status=..., action=..., [other specifiers],
!         iostat=ios, iomsg=msg)
!   close (u [, status='keep'|'delete'] [, iostat=] [, iomsg=])
!
! Most used OPEN specifiers:
!   newunit=u    the processor picks a free (negative) unit number (F2008).
!                Never hard-code unit numbers like 10 again.
!   status=      'old' (must exist), 'new' (must not exist), 'replace'
!                (create or truncate), 'scratch' (temporary, no name,
!                deleted on close), 'unknown' (default, processor-dependent)
!   action=      'read', 'write', 'readwrite'
!   position=    'rewind' (default for sequential), 'append', 'asis'
!   access=      'sequential' (default), 'direct', 'stream'
!   form=        'formatted' (default for sequential), 'unformatted'
!   Others: recl=, blank=, decimal=, delim=, encoding=, pad=, round=,
!   sign=, asynchronous=, convert= (gfortran: endianness).
!
! ALWAYS pass iostat= (and iomsg=): without it any failure aborts the
! program.

program open_close
  implicit none (type, external)

  integer :: u, ios
  character(len=256) :: msg
  character(len=*), parameter :: path = 'tutorial_23_01.txt'

  open (newunit=u, file=path, status='replace', action='write', iostat=ios, iomsg=msg)
  if (ios /= 0) error stop trim(msg)
  print '(a, i0)', 'newunit chose unit ', u
  write (u, '(a)') 'first line'
  close (u)

  ! position='append' adds to the end.
  open (newunit=u, file=path, status='old', position='append', action='write')
  write (u, '(a)') 'appended line'
  close (u)

  ! status='new' fails because the file exists - handled with iostat.
  open (newunit=u, file=path, status='new', iostat=ios, iomsg=msg)
  print '(a, i0, 2a)', "status='new' on existing file: iostat=", ios, ', ', trim(msg)

  ! status='old' on a missing file.
  open (newunit=u, file='does_not_exist.txt', status='old', iostat=ios, iomsg=msg)
  print '(a, i0, 2a)', "status='old' on missing file : iostat=", ios, ', ', trim(msg)

  ! Read it back, then delete it on close.
  block
    character(len=80) :: line
    open (newunit=u, file=path, status='old', action='read')
    do
      read (u, '(a)', iostat=ios) line
      if (ios /= 0) exit
      print '(2a)', 'read: ', trim(line)
    end do
    close (u, status='delete')
  end block

  ! A scratch file has no name and disappears on close.
  open (newunit=u, status='scratch')
  write (u, *) 'temporary'
  close (u)

end program open_close

! Output:
! newunit chose unit -10
! status='new' on existing file: iostat=2, Cannot open file 'tutorial_23_01.txt': File exists
! status='old' on missing file : iostat=2, Cannot open file 'does_not_exist.txt': No such file or directory
! read: first line
! read: appended line
