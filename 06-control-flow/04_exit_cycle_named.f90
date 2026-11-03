! -----------------------------------------------------------------------------
! 04_exit_cycle_named.f90 - EXIT, CYCLE and construct names
!
! Run:  scripts/run.sh 06-control-flow/04_exit_cycle_named.f90
! -----------------------------------------------------------------------------
!
!   cycle [do-name]      skip to the next iteration of the named DO
!                        (default: the innermost DO)
!   exit [name]          leave the named construct
!                        (default: the innermost DO)
!
! Since F2008, EXIT with a name can leave ANY named construct: associate,
! block, if, select case, select type, select rank - not only DO loops.
! CYCLE applies to DO loops only.
!
! Names are ordinary identifiers followed by a colon, and must be repeated
! on the END statement. Name every loop that an EXIT or CYCLE in a nested
! loop refers to; it documents intent and prevents mistakes.
!
! EXIT and CYCLE may not leave a DO CONCURRENT or CRITICAL construct.

program exit_cycle_named
  implicit none (type, external)

  integer :: i, j
  integer :: grid(3, 4)

  grid = reshape([1, 2, 3, 4, 5, -6, 7, 8, 9, 10, 11, 12], shape(grid))

  ! CYCLE: skip odd numbers.
  write (*, '(a)', advance='no') 'even:'
  do i = 1, 10
    if (mod(i, 2) /= 0) cycle
    write (*, '(1x, i0)', advance='no') i
  end do
  print '(a)', ''

  ! EXIT from an outer loop: search a 2-D grid for the first negative.
  search: do j = 1, size(grid, 2)
    do i = 1, size(grid, 1)
      if (grid(i, j) < 0) then
        print '(a, i0, a, i0, a)', 'first negative at (', i, ',', j, ')'
        exit search
      end if
    end do
  end do search

  ! CYCLE an outer loop: skip a whole column once a condition holds.
  columns: do j = 1, size(grid, 2)
    do i = 1, size(grid, 1)
      if (grid(i, j) > 10) then
        print '(a, i0, a)', 'column ', j, ' has a value > 10, skipping rest'
        cycle columns
      end if
    end do
    print '(a, i0, a)', 'column ', j, ' is all <= 10'
  end do columns

  ! EXIT from a named BLOCK (no loop involved).
  validate: block
    if (size(grid) == 0) exit validate
    if (any(grid < 0)) then
      print '(a)', 'validation: grid has negative values'
      exit validate
    end if
    print '(a)', 'validation: all good'
  end block validate

  ! EXIT from a named IF construct.
  check: if (grid(1, 1) > 0) then
    if (grid(2, 1) > 0) exit check
    print '(a)', 'not reached'
  end if check
  print '(a)', 'after check'

end program exit_cycle_named

! Output:
! even: 2 4 6 8 10
! first negative at (3,2)
! column 1 is all <= 10
! column 2 is all <= 10
! column 3 is all <= 10
! column 4 has a value > 10, skipping rest
! validation: grid has negative values
! after check
