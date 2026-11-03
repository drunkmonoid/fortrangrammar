! -----------------------------------------------------------------------------
! 01_declaration_syntax.f90 - the shape of a type declaration statement
!
! Run:  scripts/run.sh 04-declarations/01_declaration_syntax.f90
! -----------------------------------------------------------------------------
!
!   type-spec [, attribute]... :: entity [, entity]...
!
!   type-spec   integer, real(dp), character(len=10), type(point), class(shape),
!               typeof(x), classof(x)  (F2023)
!   attribute   parameter, dimension(...), allocatable, pointer, target, ...
!   entity      name [(array-spec)] [[coarray-spec]] [*char-length] [= init]
!               name => null()          (pointer initialisation)
!
! The `::` is required when there are attributes or an initialiser, and
! optional otherwise. Always writing it is the modern convention.
!
! Per-entity overrides: `name(5)` overrides DIMENSION, `name*20` overrides
! the character length for that one entity.

program declaration_syntax
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  ! Simplest forms.
  integer :: i
  integer j                          ! legal without ::, but avoid
  real(dp) :: x, y, z                ! several entities at once

  ! With initialisation (requires ::).
  integer :: count = 0
  real(dp) :: tolerance = 1.0e-10_dp

  ! With attributes.
  real(dp), dimension(3) :: position, velocity
  integer, parameter :: n = 4
  real(dp), allocatable :: samples(:)

  ! Per-entity array spec overrides the DIMENSION attribute.
  real(dp), dimension(3) :: vec3, mat33(3, 3), scalar_like(1)

  ! Per-entity character length override.
  character(len=8) :: short, long*32

  i = 1; j = 2; x = 1; y = 2; z = 3
  position = [1.0_dp, 2.0_dp, 3.0_dp]
  velocity = 0
  vec3 = 1; mat33 = 0; scalar_like = 7
  samples = [real(dp) :: (i * i, i = 1, n)]
  short = 'abc'; long = 'abcdefghijklmnopqrstuvwxyz'

  print '(a, i0, 1x, i0, 1x, i0)', 'i, j, count: ', i, j, count
  print '(a, es8.1)', 'tolerance: ', tolerance
  print '(a, *(1x, f0.1))', 'position:', position
  print '(a, *(1x, i0))', 'shape(mat33):', shape(mat33)
  print '(a, *(1x, f0.1))', 'samples:', samples
  print '(a, i0, a, i0)', 'len(short) = ', len(short), ', len(long) = ', len(long)

end program declaration_syntax

! Output:
! i, j, count: 1 2 0
! tolerance:  1.0E-10
! position: 1.0 2.0 3.0
! shape(mat33): 3 3
! samples: 1.0 4.0 9.0 16.0
! len(short) = 8, len(long) = 32
