! -----------------------------------------------------------------------------
! 10_assumed_rank.f90 - assumed-rank dummies and SELECT RANK (F2018)
!
! Run:  scripts/run.sh 08-arrays-dynamic/10_assumed_rank.f90
! -----------------------------------------------------------------------------
!
!   real, intent(in) :: a(..)        any rank, including scalars (rank 0)
!
! * rank(a) gives the rank; size, shape, lbound, ubound work too.
! * An assumed-rank object cannot be used directly in expressions; select
!   a concrete rank first with SELECT RANK:
!
!     select rank (a)
!     rank (0)          a is a scalar here
!     rank (1)          a is a(:) here
!     rank (2)          a is a(:, :) here
!     rank (*)          the actual argument was assumed-size
!     rank default      any other rank (still assumed-rank)
!     end select
!
! * Assumed rank is also the bridge to C: a C function receives a
!   CFI_cdesc_t descriptor (chapter 27).

module rank_generic
  implicit none (type, external)
contains

  subroutine describe(a)
    real, intent(in) :: a(..)

    write (*, '(a, i0)', advance='no') 'rank ', rank(a)
    select rank (a)
    rank (0)
      print '(a, f0.2)', ' scalar: ', a
    rank (1)
      print '(a, i0, a, f0.2)', ' vector of ', size(a), ', sum = ', sum(a)
    rank (2)
      print '(a, i0, a, i0, a, f0.2)', ' matrix ', size(a, 1), 'x', size(a, 2), ', sum = ', sum(a)
    rank default
      print '(a, i0, a)', ' array with ', size(a), ' elements (no specific case)'
    end select
  end subroutine describe

  ! Assumed rank also allows modifying the actual argument.
  subroutine zero(a)
    real, intent(inout) :: a(..)

    select rank (a)
    rank (0)
      a = 0
    rank (1)
      a = 0
    rank (2)
      a = 0
    rank (3)
      a = 0
    rank default
      error stop 'zero: unsupported rank'
    end select
  end subroutine zero

end module rank_generic

program assumed_rank
  use rank_generic, only: describe, zero
  implicit none (type, external)

  real :: s, v(4), m(2, 3), t(2, 2, 2)

  s = 3.5
  v = 1.0
  m = 2.0
  t = 0.5

  call describe(s)
  call describe(v)
  call describe(m)
  call describe(t)

  call zero(m)
  call describe(m)

end program assumed_rank

! Output:
! rank 0 scalar: 3.50
! rank 1 vector of 4, sum = 4.00
! rank 2 matrix 2x3, sum = 12.00
! rank 3 array with 8 elements (no specific case)
! rank 2 matrix 2x3, sum = .00
