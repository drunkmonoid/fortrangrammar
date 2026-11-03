! -----------------------------------------------------------------------------
! 05_operator_precedence.f90 - the complete precedence table
!
! Run:  scripts/run.sh 05-expressions/05_operator_precedence.f90
! -----------------------------------------------------------------------------
!
! Highest to lowest:
!
!   1. defined unary operators       .op. x          (user-defined)
!   2. **                             right-assoc
!   3. * /                            left-assoc
!   4. unary + -
!   5. binary + -                     left-assoc
!   6. //                             left-assoc      (concatenation)
!   7. == /= < <= > >=                non-associative (no chaining)
!   8. .not.
!   9. .and.
!  10. .or.
!  11. .eqv. .neqv.                   left-assoc
!  12. defined binary operators      x .op. y        (user-defined)
!
! So: arithmetic binds tighter than //, // tighter than comparisons, and
! comparisons tighter than logical operators. Defined unary operators bind
! tightest of all, defined binary ones loosest - parenthesise when mixing.

program operator_precedence
  implicit none (type, external)

  logical :: p, q, r
  integer :: a, b

  a = 2; b = 3
  p = .true.; q = .false.; r = .true.

  ! Arithmetic before comparison before logical:
  print '(a, l1)', 'a + 1 > b .and. b < 4      : ', a + 1 > b .and. b < 4

  ! .not. binds tighter than .and.:
  print '(a, l1)', '.not. p .and. q            : ', .not. p .and. q
  print '(a, l1)', '.not. (p .and. q)          : ', .not. (p .and. q)

  ! .and. before .or.:
  print '(a, l1)', 'p .or. q .and. .false.     : ', p .or. q .and. .false.
  print '(a, l1)', '(p .or. q) .and. .false.   : ', (p .or. q) .and. .false.

  ! .eqv. is lowest of the intrinsic logical operators:
  print '(a, l1)', 'p .and. q .eqv. q          : ', p .and. q .eqv. q

  ! Concatenation after arithmetic, before comparison:
  print '(a, l1)', "'ab' // 'c' == 'abc'       : ", 'ab' // 'c' == 'abc'

  ! Unary minus is below **, and ** is right-associative:
  print '(a, i0)', '-a**2                      = ', -a**2
  print '(a, i0)', 'a**b**2 = a**(b**2)        = ', a**b**2

  ! Parentheses always win and are always honoured.
  print '(a, i0)', '(a + b) * 2                = ', (a + b) * 2

end program operator_precedence

! Output:
! a + 1 > b .and. b < 4      : F
! .not. p .and. q            : F
! .not. (p .and. q)          : T
! p .or. q .and. .false.     : T
! (p .or. q) .and. .false.   : F
! p .and. q .eqv. q          : T
! 'ab' // 'c' == 'abc'       : T
! -a**2                      = -4
! a**b**2 = a**(b**2)        = 512
! (a + b) * 2                = 10
