! -----------------------------------------------------------------------------
! 07_inquire.f90 - asking about files and units
!
! Run:  scripts/run.sh 23-file-io/07_inquire.f90
! -----------------------------------------------------------------------------
!
!   inquire (file='name', exist=e, size=s, ...)      by file name
!   inquire (unit=u, opened=o, name=n, ...)          by unit
!   inquire (iolength=n) item-list                   record length (04_...)
!
! Useful specifiers: exist, opened, number (unit of an open file), named,
! name, access, sequential/direct/stream ('YES'/'NO'/'UNKNOWN'), form,
! action, read/write/readwrite, recl, position, size (bytes, -1 if
! unknown), pos, nextrec, encoding, iostat, iomsg.
! Character results are blank-padded, and UPPERCASE ('SEQUENTIAL').

program inquire_demo
  implicit none (type, external)

  integer :: u, file_size, unit_number
  logical :: exists, is_open
  character(len=32) :: access, form, action
  character(len=256) :: name
  character(len=*), parameter :: path = 'tutorial_23_07.txt'

  inquire (file=path, exist=exists)
  print '(a, l1)', 'exists before creating: ', exists

  open (newunit=u, file=path, status='replace', action='readwrite')
  write (u, '(a)') 'hello'
  flush (u)

  inquire (file=path, exist=exists, opened=is_open, number=unit_number, size=file_size)
  print '(a, l1, a, l1, a, l1, a, i0)', 'exists: ', exists, '  opened: ', is_open, &
      '  same unit: ', unit_number == u, '  size: ', file_size

  inquire (unit=u, name=name, access=access, form=form, action=action)
  print '(a)', 'name  : ' // trim(name)
  print '(a)', 'access: ' // trim(access)
  print '(a)', 'form  : ' // trim(form)
  print '(a)', 'action: ' // trim(action)

  close (u, status='delete')
  inquire (file=path, exist=exists)
  print '(a, l1)', 'exists after delete   : ', exists

end program inquire_demo

! Output:
! exists before creating: F
! exists: T  opened: T  same unit: T  size: 6
! name  : tutorial_23_07.txt
! access: SEQUENTIAL
! form  : FORMATTED
! action: READWRITE
! exists after delete   : F
