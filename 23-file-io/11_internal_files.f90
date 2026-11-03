! -----------------------------------------------------------------------------
! 11_internal_files.f90 - READ and WRITE on character variables
!
! Run:  scripts/run.sh 23-file-io/11_internal_files.f90
! -----------------------------------------------------------------------------
!
! An INTERNAL FILE is a character variable used as a unit:
!   * a scalar character variable is ONE record;
!   * a character ARRAY is a file with one record per element, so '/' in a
!     format moves to the next element; elements not written by the
!     statement become UNDEFINED (they are not blanked);
!   * must be a variable (not a literal) for READ and WRITE alike;
!   * only sequential, formatted I/O - no OPEN/CLOSE, no advance='no'.
!
! Chapter 10 used scalar internal files for number <-> string conversion;
! this file shows multi-record use.

program internal_files
  implicit none (type, external)

  character(len=20) :: page(4)
  character(len=40) :: csv
  integer :: a, b, c, i

  ! Writing several records into an array of strings.
  write (page, '(a, /, a, i0, /, "x = ", f0.3)') 'header', 'count: ', 42, 3.14159
  do i = 1, 3                               ! only 3 records were written
    print '(3a)', '[', page(i), ']'
  end do

  ! Parsing a comma-separated record with list-directed input.
  csv = '10,20,30'
  read (csv, *) a, b, c
  print '(a, i0)', 'sum of csv fields: ', a + b + c

end program internal_files

! Output:
! [header              ]
! [count: 42           ]
! [x = 3.142           ]
! sum of csv fields: 60
