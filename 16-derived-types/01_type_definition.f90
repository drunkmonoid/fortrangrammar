! -----------------------------------------------------------------------------
! 01_type_definition.f90 - defining and using a derived type
!
! Run:  scripts/run.sh 16-derived-types/01_type_definition.f90
! -----------------------------------------------------------------------------
!
!   type [, attributes ::] name
!     component declarations
!   [contains
!     type-bound procedures]           (chapter 18)
!   end type [name]
!
! * Components are declared like variables: any type (including other
!   derived types), arrays, allocatable, pointer.
! * A component may have a DEFAULT INITIALISATION (= value). Every object of
!   the type starts with those values. Unlike for local variables, this does
!   NOT imply SAVE.
! * Access components with %: obj%component, obj%inner%field, arr(i)%x.
! * Declare objects with type(name).
! * Type definitions usually live in modules so that several program units
!   share the same type.

module particles
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  type :: vector3
    real(dp) :: x = 0, y = 0, z = 0
  end type vector3

  type :: particle
    character(len=16) :: name = 'unnamed'
    real(dp) :: mass = 1.0_dp
    type(vector3) :: position              ! nested type, default (0,0,0)
    type(vector3) :: velocity
    integer :: history(3) = 0              ! array component
  end type particle

end module particles

program type_definition
  use particles, only: particle, vector3, dp
  implicit none (type, external)

  type(particle) :: p
  type(particle) :: swarm(3)
  integer :: i

  print '(3a, f0.1)', 'default name: ', trim(p%name), ', mass: ', p%mass

  p%name = 'electron'
  p%mass = 9.109e-31_dp
  p%position%x = 1.0
  p%velocity = vector3(0.0, 2.0, 0.0)
  p%history(2) = 7

  print '(2a)', 'name    : ', trim(p%name)
  print '(a, es10.3)', 'mass    : ', p%mass
  print '(a, 3(1x, f0.1))', 'position:', p%position
  print '(a, 3(1x, f0.1))', 'velocity:', p%velocity%x, p%velocity%y, p%velocity%z
  print '(a, 3(1x, i0))', 'history :', p%history

  ! Arrays of derived types.
  do i = 1, size(swarm)
    swarm(i)%position%x = real(i)
  end do
  ! A component of an array of structures is an array: swarm%position%x
  print '(a, 3(1x, f0.1))', 'swarm%position%x:', swarm%position%x
  print '(a, f0.1)', 'total mass: ', sum(swarm%mass)

end program type_definition

! Output:
! default name: unnamed, mass: 1.0
! name    : electron
! mass    :  9.109E-31
! position: 1.0 .0 .0
! velocity: .0 2.0 .0
! history : 0 7 0
! swarm%position%x: 1.0 2.0 3.0
! total mass: 3.0
