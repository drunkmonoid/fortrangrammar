! -----------------------------------------------------------------------------
! 04_computed_goto.f90 - GO TO (labels), integer selector
!
! Run:  scripts/run.sh 33-obsolescent-forms/04_computed_goto.f90
! -----------------------------------------------------------------------------
!
!   go to (10, 20, 30), k
!
! k selects a label by position: 1 takes the first, 2 the second. Out of
! range is not a jump. There is no case default and no overlap check.
! select case (chapter 06) is the replacement.

program computed_goto_demo
  implicit none (type, external)

  integer :: k

  do k = 1, 3
    go to (10, 20, 30), k
    print '(a)', 'computed: none'
    cycle
10  print '(a)', 'computed: one'
    cycle
20  print '(a)', 'computed: two'
    cycle
30  print '(a)', 'computed: three'
  end do

  do k = 1, 3
    select case (k)
    case (1)
      print '(a)', 'select: one'
    case (2)
      print '(a)', 'select: two'
    case (3)
      print '(a)', 'select: three'
    end select
  end do

end program computed_goto_demo

! Output:
! computed: one
! computed: two
! computed: three
! select: one
! select: two
! select: three
