! -----------------------------------------------------------------------------
! 01_class_star.f90 - unlimited polymorphic entities: CLASS(*)
!
! Run:  scripts/run.sh 20-unlimited-polymorphism/01_class_star.f90
! -----------------------------------------------------------------------------
!
!   class(*), intent(in) :: x            accepts ANY type: intrinsic or derived
!   class(*), allocatable :: box         can hold a value of any type
!   class(*), pointer :: p               can point at any target
!
! * There is no declared type, so nothing can be done with the value
!   directly - SELECT TYPE recovers it, with TYPE IS for intrinsic types
!   (and their kinds/lengths) and TYPE IS / CLASS IS for derived types.
! * Assignment to a class(*) allocatable (F2008) or allocate(..., source=)
!   gives it the dynamic type and value of the right-hand side.
! * Typical uses: generic containers, "any value" arguments (printers,
!   loggers, serialisers), interop with type-erased libraries.

module anything
  use, intrinsic :: iso_fortran_env, only: real64, int64
  implicit none (type, external)

  type :: point
    real :: x = 0, y = 0
  end type point

contains

  subroutine describe(x)
    class(*), intent(in) :: x
    select type (x)
    type is (integer)
      print '(a, i0)', 'default integer: ', x
    type is (integer(int64))
      print '(a, i0)', 'int64          : ', x
    type is (real)
      print '(a, g0)', 'default real   : ', x
    type is (real(real64))
      print '(a, g0)', 'real64         : ', x
    type is (logical)
      print '(a, l1)', 'logical        : ', x
    type is (character(len=*))
      print '(a, a, a, i0, a)', 'character      : "', x, '" (len ', len(x), ')'
    type is (point)
      print '(a, 2(1x, f0.1))', 'point          :', x%x, x%y
    class default
      print '(a)', 'something else'
    end select
  end subroutine describe

end module anything

program class_star
  use, intrinsic :: iso_fortran_env, only: real64, int64
  use anything, only: describe, point
  implicit none (type, external)

  class(*), allocatable :: box

  call describe(42)
  call describe(42_int64)
  call describe(1.5)
  call describe(2.0_real64)
  call describe(.true.)
  call describe('text')
  call describe(point(1, 2))
  call describe((1.0, 2.0))

  ! A box that changes type at run time.
  box = 7
  call describe(box)
  box = 'now a string'
  call describe(box)
  box = point(3, 4)
  call describe(box)

end program class_star

! Output:
! default integer: 42
! int64          : 42
! default real   : 1.50000000
! real64         : 2.0000000000000000
! logical        : T
! character      : "text" (len 4)
! point          : 1.0 2.0
! something else
! default integer: 7
! character      : "now a string" (len 12)
! point          : 3.0 4.0
