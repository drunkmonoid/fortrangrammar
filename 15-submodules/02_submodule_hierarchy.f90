! -----------------------------------------------------------------------------
! 02_submodule_hierarchy.f90 - nested submodules
!
! Run:  scripts/run.sh 15-submodules/02_submodule_hierarchy.f90
! -----------------------------------------------------------------------------
!
!   submodule (ancestor) child                   parent is the module
!   submodule (ancestor:parent_sub) grandchild   parent is another submodule
!
! The first name in parentheses is always the ANCESTOR MODULE; the optional
! second name is the parent submodule. Each submodule sees everything in its
! ancestors by host association - including PRIVATE entities and entities
! declared in parent submodules. Siblings cannot see each other.
!
! A submodule may also declare its own `module procedure` interfaces for
! descendants to implement, building layered implementations.
!
!         solver (module: public API)
!            |
!         solver_common (submodule: shared private helpers + state)
!          /          \
!   solver_direct    solver_iterative    (submodules: implementations)

module solver
  implicit none (type, external)
  private
  public :: solve_direct, solve_iterative

  interface
    module subroutine solve_direct(a, b, x)
      real, intent(in) :: a, b
      real, intent(out) :: x
    end subroutine solve_direct

    module subroutine solve_iterative(a, b, x)
      real, intent(in) :: a, b
      real, intent(out) :: x
    end subroutine solve_iterative
  end interface

end module solver

submodule (solver) solver_common
  implicit none (type, external)
  integer :: solves = 0                ! shared by all descendants

  interface                            ! helper implemented right here
    module subroutine report(method, x)
      character(len=*), intent(in) :: method
      real, intent(in) :: x
    end subroutine report
  end interface

contains

  module procedure report
    solves = solves + 1
    print '(a, i0, 3a, f0.6)', 'solve #', solves, ' (', method, '): x = ', x
  end procedure report

end submodule solver_common

submodule (solver:solver_common) solver_direct
  implicit none (type, external)
contains
  module procedure solve_direct        ! solves a*x = b
    x = b / a
    call report('direct', x)           ! helper from the parent submodule
  end procedure solve_direct
end submodule solver_direct

submodule (solver:solver_common) solver_iterative
  implicit none (type, external)
contains
  module procedure solve_iterative     ! same equation by fixed-point iteration
    integer :: i
    x = 0
    do i = 1, 50
      x = x + (b - a * x) / (2 * a)
    end do
    call report('iterative', x)
  end procedure solve_iterative
end submodule solver_iterative

program submodule_hierarchy
  use solver, only: solve_direct, solve_iterative
  implicit none (type, external)

  real :: x

  call solve_direct(4.0, 2.0, x)
  call solve_iterative(4.0, 2.0, x)

end program submodule_hierarchy

! Output:
! solve #1 (direct): x = .500000
! solve #2 (iterative): x = .500000
