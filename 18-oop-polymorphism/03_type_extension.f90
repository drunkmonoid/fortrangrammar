! -----------------------------------------------------------------------------
! 03_type_extension.f90 - inheritance with EXTENDS
!
! Run:  scripts/run.sh 18-oop-polymorphism/03_type_extension.f90
! -----------------------------------------------------------------------------
!
!   type, extends(animal) :: dog
!     character(len=20) :: breed = ''
!   end type dog
!
! * The extended type (child) has all components and bindings of the parent
!   plus its own. Single inheritance only.
! * The parent part is itself a component named after the parent type:
!   d%animal%name is the same as d%name. Useful to pass or copy "the parent
!   part" of an object.
! * Structure constructor: parent components first, then the child's, or
!   use keywords; you may also give the parent part as one value:
!     dog(animal('Rex', 3), 'beagle')
! * Private components of the parent are inherited but only accessible in
!   the parent's module.

module zoo
  implicit none (type, external)

  type :: animal
    character(len=20) :: name = ''
    integer :: age = 0
  contains
    procedure :: describe
  end type animal

  type, extends(animal) :: dog
    character(len=20) :: breed = ''
  end type dog

  type, extends(dog) :: guide_dog                 ! extensions can be extended
    logical :: certified = .false.
  end type guide_dog

contains

  subroutine describe(self)
    class(animal), intent(in) :: self
    print '(3a, i0)', 'animal ', trim(self%name), ', age ', self%age
  end subroutine describe

end module zoo

program type_extension
  use zoo, only: animal, dog, guide_dog
  implicit none (type, external)

  type(dog) :: d
  type(guide_dog) :: g

  d = dog('Rex', 3, 'beagle')                      ! all components in order
  call d%describe()                                ! inherited binding
  print '(2a)', 'breed: ', trim(d%breed)
  print '(2a)', 'd%animal%name: ', trim(d%animal%name)   ! parent component

  d = dog(animal('Fido', 5), breed='collie')       ! parent part as one value
  print '(a, i0, 2a)', 'age ', d%age, ', breed ', trim(d%breed)

  g = guide_dog(name='Buddy', age=4, breed='labrador', certified=.true.)
  call g%describe()
  print '(a, l1)', 'certified: ', g%certified
  print '(2a)', 'g%dog%animal%name: ', trim(g%dog%animal%name)

end program type_extension

! Output:
! animal Rex, age 3
! breed: beagle
! d%animal%name: Rex
! age 5, breed collie
! animal Buddy, age 4
! certified: T
! g%dog%animal%name: Buddy
