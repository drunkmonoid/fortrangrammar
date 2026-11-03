! -----------------------------------------------------------------------------
! 05_statement_labels.f90 - numeric statement labels
!
! Run:  scripts/run.sh 02-lexical-elements/05_statement_labels.f90
! -----------------------------------------------------------------------------
!
! A statement label is 1 to 5 digits (at least one nonzero) written before a
! statement: `100 format (...)`. Leading zeros are not significant, so 10 and
! 010 are the same label. Labels are local to their scoping unit and must be
! unique within it.
!
! In modern code labels are needed only for:
!   * FORMAT statements referenced from READ/WRITE  (also see chapter 22)
!   * GO TO targets                                 (rarely justified)
!   * ERR= / END= / EOR= in I/O statements           (prefer IOSTAT=)
!
! Not to be confused with construct NAMES (`outer: do ...`), which are
! identifiers, not numbers, and are covered in chapter 06.
!
! Obsolescent label uses NOT shown: labelled DO loops (`do 10 i = ...`),
! computed GO TO, arithmetic IF (deleted), alternate returns.

program statement_labels
  implicit none (type, external)

  integer :: i

  ! A FORMAT statement is non-executable; it can be placed anywhere in the
  ! execution part and is referenced by its label.
  write (*, 100) 'pi is about', 3.14159
100 format (a, 1x, f7.4)

  ! The same format given as a character string - usually clearer:
  write (*, '(a, 1x, f7.4)') 'e  is about', 2.71828

  ! GO TO jumps to a labelled statement in the same scoping unit. Shown for
  ! completeness: a DO loop with EXIT says the same thing more clearly.
  i = 0
10 continue
  i = i + 1
  if (i < 3) go to 10
  print '(a, i0)', 'after the goto loop i = ', i

end program statement_labels

! Output:
! pi is about  3.1416
! e  is about  2.7183
! after the goto loop i = 3
