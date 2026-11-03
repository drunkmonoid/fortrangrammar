! -----------------------------------------------------------------------------
! 01_hello_world.f90 - the smallest useful Fortran program
!
! Run:  scripts/run.sh 01-getting-started/01_hello_world.f90
! -----------------------------------------------------------------------------
!
! A main program starts with an optional PROGRAM statement and ends with an
! END statement. Repeating the program name after END PROGRAM is optional, but
! the compiler checks it if present, so always write it.
!
! PRINT * writes to standard output using "list-directed" formatting: the
! compiler chooses the layout. The leading blank you will see in the output is
! part of list-directed output, not a typo.

program hello_world
  implicit none (type, external)

  print *, 'Hello, modern Fortran!'

end program hello_world

! Output:
!  Hello, modern Fortran!
