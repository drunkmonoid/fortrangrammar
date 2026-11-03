! -----------------------------------------------------------------------------
! 04_impure_elemental.f90 - IMPURE ELEMENTAL (F2008)
!
! Run:  scripts/run.sh 13-procedure-attributes/04_impure_elemental.f90
! -----------------------------------------------------------------------------
!
! `impure elemental` keeps the element-wise calling convention but drops the
! purity requirements: the procedure may do I/O or update state.
!
! For an impure elemental procedure the elements ARE processed in array
! element order, so side effects happen in a predictable sequence.
! Typical uses: logging per element, accumulating statistics, random
! perturbation.

module impure_elemental_demo
  implicit none (type, external)
  integer :: negatives_seen = 0
contains

  impure elemental real function checked_sqrt(x)
    real, intent(in) :: x
    if (x < 0) then
      negatives_seen = negatives_seen + 1
      print '(a, f0.2, a)', '  warning: sqrt of ', x, ' replaced by 0'
      checked_sqrt = 0
    else
      checked_sqrt = sqrt(x)
    end if
  end function checked_sqrt

end module impure_elemental_demo

program impure_elemental
  use impure_elemental_demo, only: checked_sqrt, negatives_seen
  implicit none (type, external)

  real :: x(5) = [4.0, -1.0, 9.0, -2.5, 2.0]
  real :: r(5)

  r = checked_sqrt(x)
  print '(a, *(1x, f0.3))', 'results:', r
  print '(a, i0)', 'negatives seen: ', negatives_seen

end program impure_elemental

! Output:
!   warning: sqrt of -1.00 replaced by 0
!   warning: sqrt of -2.50 replaced by 0
! results: 2.000 .000 3.000 .000 1.414
! negatives seen: 2
