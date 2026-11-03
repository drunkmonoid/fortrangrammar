! -----------------------------------------------------------------------------
! 04_character_logical.f90 - A and L descriptors
!
! Run:  scripts/run.sh 22-formatted-io/04_character_logical.f90
! -----------------------------------------------------------------------------
!
!   A        as many characters as the item has
!   Aw       output: right-justify in w (pad left with blanks), or keep the
!            LEFTMOST w characters if the item is longer
!            input:  take w characters (rightmost len of them if w > len)
!   Lw       logical: w-1 blanks then T or F
!   L0       (F2023) minimal width logical - not in gfortran 15; use L1
!
! On input, L accepts T, F, .TRUE., .false., t..., f... (first letter counts).
! Note: the internal file of a READ must be a character VARIABLE - a
! literal such as read ('T', '(l1)') is rejected.

program character_logical
  implicit none (type, external)

  character(len=*), parameter :: word = 'Fortran'
  logical :: flags(3) = [.true., .false., .true.]
  logical :: parsed
  character(len=8) :: text

  print '("[", a, "]")', word
  print '("[", a10, "]")', word              ! right-justified
  print '("[", a3, "]")', word               ! truncated: leftmost 3
  print '("[", l1, "] [", l5, "]")', .true., .false.
  print '("[", 3l2, "]")', flags

  text = '.false.'
  read (text, '(l7)') parsed
  print '(a, l1)', "read '.false.' -> ", parsed
  text = 'Tomato'
  read (text, '(l6)') parsed
  print '(a, l1)', "read 'Tomato'  -> ", parsed

end program character_logical

! Output:
! [Fortran]
! [   Fortran]
! [For]
! [T] [    F]
! [ T F T]
! read '.false.' -> F
! read 'Tomato'  -> T
