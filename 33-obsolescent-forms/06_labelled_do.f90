! -----------------------------------------------------------------------------
! 06_labelled_do.f90 - DO label, ending on CONTINUE or END DO
!
! Run:  scripts/run.sh 33-obsolescent-forms/06_labelled_do.f90
! -----------------------------------------------------------------------------
!
!   do 10 i = 1, 3
!     s = s + i
!10 continue
!
! The label on the do and the label on the terminal statement are the
! same. Ending on continue, or on end do, is obsolescent and still
! accepted. A block do (chapter 06) does not need the label.
!
! Two do statements that share one terminal label were deleted in
! Fortran 2018. Chapter 34 is that form.

program labelled_do
  implicit none (type, external)

  integer :: i, s

  s = 0
  do 10 i = 1, 3
    s = s + i
10 continue
  print '(a, i0)', 'continue-terminated = ', s

  s = 0
  do 20 i = 1, 3
    s = s + i
20 end do
  print '(a, i0)', 'end-do-terminated = ', s

  s = 0
  do i = 1, 3
    s = s + i
  end do
  print '(a, i0)', 'block-do = ', s

end program labelled_do

! Output:
! continue-terminated = 6
! end-do-terminated = 6
! block-do = 6
