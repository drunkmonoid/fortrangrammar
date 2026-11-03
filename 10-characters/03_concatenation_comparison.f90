! -----------------------------------------------------------------------------
! 03_concatenation_comparison.f90 - //, ==, and lexical comparison
!
! Run:  scripts/run.sh 10-characters/03_concatenation_comparison.f90
! -----------------------------------------------------------------------------
!
!   a // b       concatenation; result length = len(a) + len(b)
!   ==, /=, <, <=, >, >=
!                compare in the PROCESSOR's collating sequence, after
!                padding the shorter operand with blanks
!   lge, lgt, lle, llt (a, b)
!                compare in ASCII order, whatever the processor uses -
!                the portable choice for sorting
!
! Trailing blanks are insignificant in comparisons ('ab' == 'ab  '), but
! significant in concatenation (fixed-length variables carry their padding:
! trim() before concatenating). Leading blanks are significant everywhere.

program concatenation_comparison
  implicit none (type, external)

  character(len=8) :: first, last

  first = 'Ada'
  last = 'Lovelace'

  print '(3a)', '[', first // last, ']'                  ! padding inside
  print '(3a)', '[', trim(first) // ' ' // last, ']'
  print '(a, i0)', 'len(first // last) = ', len(first // last)

  print '(a, l1)', "'ab' == 'ab   '   : ", 'ab' == 'ab   '
  print '(a, l1)', "'ab' == '  ab'    : ", 'ab' == '  ab'
  print '(a, l1)', "'apple' < 'banana': ", 'apple' < 'banana'
  print '(a, l1)', "'Zebra' < 'apple' : ", 'Zebra' < 'apple'       ! uppercase first in ASCII
  print '(a, l1)', "llt('Zebra','apple'): ", llt('Zebra', 'apple')
  print '(a, l1)', "lge('b', 'abc')   : ", lge('b', 'abc')

end program concatenation_comparison

! Output:
! [Ada     Lovelace]
! [Ada Lovelace]
! len(first // last) = 16
! 'ab' == 'ab   '   : T
! 'ab' == '  ab'    : F
! 'apple' < 'banana': T
! 'Zebra' < 'apple' : T
! llt('Zebra','apple'): T
! lge('b', 'abc')   : T
