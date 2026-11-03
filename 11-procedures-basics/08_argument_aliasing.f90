! -----------------------------------------------------------------------------
! 08_argument_aliasing.f90 - the no-aliasing rule for arguments
!
! Run:  scripts/run.sh 11-procedures-basics/08_argument_aliasing.f90
! -----------------------------------------------------------------------------
!
! Fortran lets the compiler assume that dummy arguments do not overlap
! each other (or a module/host variable the procedure accesses) when one of
! them is modified. This is why Fortran loops vectorise so well - and it is
! a rule for the PROGRAMMER, not checked by the compiler:
!
!   call add_into(a, a)        ! WRONG if add_into writes one and reads the
!                              ! other: results are undefined
!   call add_into(a(1:5), a(3:7))   ! WRONG: overlapping sections
!
! Exceptions: dummies with the POINTER or TARGET attribute may alias
! (and then the compiler must assume they can).
!
! Safe alternatives: pass a copy (an expression such as (a) or a + 0 is a
! temporary), or write the procedure to accept a single inout argument.

module aliasing
  implicit none (type, external)
contains

  subroutine add_into(src, dst)
    real, intent(in) :: src(:)
    real, intent(inout) :: dst(:)
    integer :: i
    do i = 1, size(dst)
      dst(i) = dst(i) + src(i)
    end do
  end subroutine add_into

  subroutine double_in_place(a)
    real, intent(inout) :: a(:)
    a = a + a
  end subroutine double_in_place

end module aliasing

program argument_aliasing
  use aliasing, only: add_into, double_in_place
  implicit none (type, external)

  real :: a(4) = [1.0, 2.0, 3.0, 4.0]
  real :: b(4)

  ! Correct: distinct arrays.
  b = 10.0
  call add_into(a, b)
  print '(a, *(1x, f0.1))', 'b = b + a      :', b

  ! Correct: (a) is an expression, so src is a temporary copy.
  call add_into((a), a)
  print '(a, *(1x, f0.1))', 'a = a + copy(a):', a

  ! Correct: an interface designed for the in-place case.
  call double_in_place(a)
  print '(a, *(1x, f0.1))', 'double in place:', a

end program argument_aliasing

! Output:
! b = b + a      : 11.0 12.0 13.0 14.0
! a = a + copy(a): 2.0 4.0 6.0 8.0
! double in place: 4.0 8.0 12.0 16.0
