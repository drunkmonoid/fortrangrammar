! -----------------------------------------------------------------------------
! 02_type_inquiry.f90 - same_type_as and extends_type_of
!
! Run:  scripts/run.sh 20-unlimited-polymorphism/02_type_inquiry.f90
! -----------------------------------------------------------------------------
!
!   same_type_as(a, b)       .true. if a and b have the same DYNAMIC type
!   extends_type_of(a, mold) .true. if a's dynamic type is mold's dynamic
!                            type or an extension of it
!
! Both take polymorphic or non-polymorphic objects of EXTENSIBLE derived
! types (not intrinsic types, not SEQUENCE/BIND(C) types). An unallocated
! class(*) object counts as having no type: extends_type_of(x, empty) is
! true for any x.
!
! They answer "is it the same kind of object?" without SELECT TYPE - for
! example in an == operator that must first check both operands match.

module family
  implicit none (type, external)
  type :: animal
  end type animal
  type, extends(animal) :: dog
  end type dog
  type, extends(dog) :: puppy
  end type puppy
end module family

program type_inquiry
  use family, only: animal, dog, puppy
  implicit none (type, external)

  class(animal), allocatable :: a, b
  type(animal) :: plain_animal
  type(dog) :: plain_dog

  a = puppy()
  b = dog()

  print '(a, l1)', 'same_type_as(a, b)            : ', same_type_as(a, b)
  print '(a, l1)', 'extends_type_of(a, b)         : ', extends_type_of(a, b)
  print '(a, l1)', 'extends_type_of(b, a)         : ', extends_type_of(b, a)
  print '(a, l1)', 'extends_type_of(a, plain_animal): ', extends_type_of(a, plain_animal)
  print '(a, l1)', 'same_type_as(b, plain_dog)    : ', same_type_as(b, plain_dog)

end program type_inquiry

! Output:
! same_type_as(a, b)            : F
! extends_type_of(a, b)         : T
! extends_type_of(b, a)         : F
! extends_type_of(a, plain_animal): T
! same_type_as(b, plain_dog)    : T
