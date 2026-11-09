! -----------------------------------------------------------------------------
! 04_block_data.f90 - BLOCK DATA initialises a COMMON block
!
! Run:  scripts/run.sh 32-storage-association/04_block_data.f90
! -----------------------------------------------------------------------------
!
! A block data program unit exists to give common initial values. It is
! not called. The linker must keep its object file; in this file that
! happens because the unit is compiled and linked with the main program.
! Drop the object from the link and n is undefined.
!
! The replacement is a module variable with an initialiser. Initialisation
! implies save (chapter 04).

block data constants
  implicit none (type, external)
  integer :: n
  common /nums/ n
  data n /7/
end block data constants

program block_data_demo
  implicit none (type, external)
  integer :: n
  common /nums/ n

  print '(a, i0)', 'n = ', n

end program block_data_demo

! Output:
! n = 7
