! -----------------------------------------------------------------------------
! 07_aos_vs_soa.f90 - array of structures vs structure of arrays
!
! Run:  scripts/run.sh 16-derived-types/07_aos_vs_soa.f90
! -----------------------------------------------------------------------------
!
! Two layouts for many particles:
!
!   AoS  type(particle) :: p(n)          p(i)%x, p(i)%y ...
!        each particle's fields are adjacent; p%x is a STRIDED section.
!
!   SoA  type(particles) :: ps           ps%x(i), ps%y(i) ...
!        each field is a contiguous array: best for vectorised whole-array
!        operations and for passing to numerical libraries.
!
! Both are idiomatic. Choose by access pattern: AoS when you process one
! object at a time, SoA when you sweep one field over all objects. The
! component-section syntax p%x makes AoS look like SoA in expressions,
! but the memory layout (and so speed) differs.

module layout_demo
  implicit none (type, external)

  type :: particle                     ! AoS element
    real :: x = 0, y = 0, mass = 1
  end type particle

  type :: particle_set                 ! SoA container
    real, allocatable :: x(:), y(:), mass(:)
  end type particle_set

end module layout_demo

program aos_vs_soa
  use layout_demo, only: particle, particle_set
  implicit none (type, external)

  integer, parameter :: n = 5
  type(particle) :: aos(n)
  type(particle_set) :: soa
  integer :: i

  aos%x = [(real(i), i = 1, n)]          ! assignment through a component section
  aos%y = 2 * aos%x
  print '(a, l1)', 'aos%x contiguous? ', is_contiguous(aos%x)
  print '(a, f0.2)', 'AoS centre of mass x = ', sum(aos%mass * aos%x) / sum(aos%mass)

  allocate (soa%x(n), soa%y(n), soa%mass(n))
  soa%x = [(real(i), i = 1, n)]
  soa%y = 2 * soa%x
  soa%mass = 1
  print '(a, l1)', 'soa%x contiguous? ', is_contiguous(soa%x)
  print '(a, f0.2)', 'SoA centre of mass x = ', sum(soa%mass * soa%x) / sum(soa%mass)

end program aos_vs_soa

! Output:
! aos%x contiguous? F
! AoS centre of mass x = 3.00
! soa%x contiguous? T
! SoA centre of mass x = 3.00
