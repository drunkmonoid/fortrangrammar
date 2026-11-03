! @build skip F2023 typeof/classof are not implemented in gfortran 15
! -----------------------------------------------------------------------------
! 09_typeof_classof.f90 - F2023 TYPEOF and CLASSOF type specifiers
!
! Run:  needs a compiler with F2023 typeof/classof
! -----------------------------------------------------------------------------
!
!   typeof(data-ref)     declares with the same type AND type parameters
!                        (kind, len) as the referenced entity
!   classof(data-ref)    same, but polymorphic: class(...) of the declared
!                        type of the referenced entity
!
! Useful to keep declarations in sync: change the type of `x` and every
! `typeof(x)` follows. Rank, attributes and array shape are NOT copied -
! only the type. The referenced entity must not be an assumed-type or
! unlimited polymorphic object, and must be declared earlier.

module shapes
  implicit none (type, external)
  type :: shape
    real :: area = 0
  end type shape
end module shapes

program typeof_classof
  use, intrinsic :: iso_fortran_env, only: real64
  use shapes, only: shape
  implicit none (type, external)

  real(real64) :: x
  typeof(x) :: y                  ! real(real64)
  typeof(x), allocatable :: v(:)  ! arrays of the same type

  character(len=12) :: label
  typeof(label) :: other_label    ! character(len=12)

  type(shape), target :: s
  classof(s), pointer :: ps       ! class(shape), pointer

  x = 1.0_real64
  y = x / 3
  v = [x, y]
  label = 'twelve chars'
  other_label = label
  ps => s

  print '(a, i0)', 'kind(y) = ', kind(y)
  print '(a, i0)', 'len(other_label) = ', len(other_label)
  print '(a, *(1x, g0))', 'v:', v

end program typeof_classof
