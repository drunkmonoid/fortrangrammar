! -----------------------------------------------------------------------------
! 02_interoperable_types.f90 - what can cross the language boundary
!
! Run:  scripts/run.sh 27-c-interop/02_interoperable_types.f90
! -----------------------------------------------------------------------------
!
! INTEROPERABLE entities:
!   * scalars of the iso_c_binding kinds;
!   * explicit-shape and assumed-size arrays of them (C sees a pointer);
!   * derived types with BIND(C) whose components are interoperable
!     (no allocatable/pointer components, no type-bound procedures) -
!     they match a C struct with the same members in the same order;
!   * enum, bind(c) enumerators;
!   * type(c_ptr) / type(c_funptr) for void* and function pointers;
!   * module variables with BIND(C) match C global variables.
!
! Since F2018, assumed-shape, assumed-rank, allocatable and pointer dummies
! are interoperable too, through C descriptors (08_array_descriptors/).

module c_structs
  use, intrinsic :: iso_c_binding, only: c_int, c_double, c_char, c_ptr, c_null_ptr
  implicit none (type, external)

  ! struct particle { int id; double pos[3]; char tag[4]; void *user; };
  type, bind(c) :: particle
    integer(c_int) :: id
    real(c_double) :: pos(3)
    character(kind=c_char) :: tag(4)
    type(c_ptr) :: user = c_null_ptr
  end type particle

  ! enum colour { RED, GREEN = 5, BLUE };
  enum, bind(c)
    enumerator :: red, green = 5, blue
  end enum

end module c_structs

program interoperable_types
  use, intrinsic :: iso_c_binding, only: c_sizeof
  use c_structs, only: particle, red, green, blue
  implicit none (type, external)

  type(particle) :: p

  p%id = 7
  p%pos = [1.0d0, 2.0d0, 3.0d0]
  p%tag = ['a', 'b', 'c', achar(0)]
  print '(a, i0, a)', 'c_sizeof(particle) = ', c_sizeof(p), ' bytes (4 + pad 4 + 24 + 4 + pad 4 + 8)'
  print '(a, 3(1x, i0))', 'enum values red green blue:', red, green, blue

end program interoperable_types

! Output:
! c_sizeof(particle) = 48 bytes (4 + pad 4 + 24 + 4 + pad 4 + 8)
! enum values red green blue: 0 5 6
