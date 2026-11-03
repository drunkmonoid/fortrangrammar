! -----------------------------------------------------------------------------
! 11_contiguous.f90 - CONTIGUOUS and is_contiguous (F2008 / F2018)
!
! Run:  scripts/run.sh 08-arrays-dynamic/11_contiguous.f90
! -----------------------------------------------------------------------------
!
! An array is contiguous when its elements occupy consecutive memory in
! array element order. Whole arrays and sections like a(2:5) or m(:, j) are
! contiguous; a(::2) and m(i, :) are not.
!
! * Assumed-shape dummies may receive non-contiguous sections, so the
!   compiler must generate code that handles strides.
! * Declaring a dummy `contiguous` promises the procedure will only see
!   contiguous data. If the actual argument is not contiguous, the CALLER
!   makes a contiguous temporary copy (copy-in/copy-out). The procedure
!   body can then be vectorised more aggressively.
! * A CONTIGUOUS pointer may only point at contiguous targets.
! * is_contiguous(a) (F2018) asks at run time.

module contiguity
  implicit none (type, external)
contains

  subroutine report(label, a)
    character(len=*), intent(in) :: label
    real, intent(in) :: a(:)

    print '(a, a, l1)', label, ' is_contiguous = ', is_contiguous(a)
  end subroutine report

  real function fast_sum(a)
    real, intent(in), contiguous :: a(:)

    ! Inside, `a` is guaranteed contiguous (a copy was made if needed).
    fast_sum = sum(a)
  end function fast_sum

end module contiguity

program contiguous_demo
  use contiguity, only: report, fast_sum
  implicit none (type, external)

  real, target :: v(10), m(3, 3)
  real, pointer, contiguous :: p(:)
  integer :: i

  v = [(real(i), i = 1, 10)]
  m = 1.0

  call report('v         ', v)
  call report('v(2:5)    ', v(2:5))
  call report('v(::2)    ', v(::2))
  call report('m(:, 2)   ', m(:, 2))
  call report('m(2, :)   ', m(2, :))

  print '(a, f0.1)', 'fast_sum(v(::2)) via copy-in = ', fast_sum(v(::2))

  p => v(3:6)                         ! contiguous target: allowed
  print '(a, *(1x, f0.0))', 'contiguous pointer:', p
  ! p => v(::2)   <- not allowed: target is not contiguous

end program contiguous_demo

! Output:
! v          is_contiguous = T
! v(2:5)     is_contiguous = T
! v(::2)     is_contiguous = F
! m(:, 2)    is_contiguous = T
! m(2, :)    is_contiguous = F
! fast_sum(v(::2)) via copy-in = 25.0
! contiguous pointer: 3. 4. 5. 6.
