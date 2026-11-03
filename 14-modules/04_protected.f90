! -----------------------------------------------------------------------------
! 04_protected.f90 - PROTECTED module variables (F2003)
!
! Run:  scripts/run.sh 14-modules/04_protected.f90
! -----------------------------------------------------------------------------
!
!   integer, protected :: n_cells
!
! A PROTECTED variable is readable everywhere the module is used, but can be
! modified only by procedures INSIDE the module. It gives cheap read access
! to state without a getter function, while keeping all writes in one place.
!
! * Outside the module it may not appear in any "variable definition
!   context": assignment, intent(out/inout) actual argument, allocate,
!   READ input item, pointer assignment target change...
! * For a protected POINTER, the association is protected, not the target.
! * Only module variables can be protected.

module grid_config
  implicit none (type, external)
  private
  public :: n_cells, cell_width, configure

  integer, protected :: n_cells = 0
  real, protected :: cell_width = 0.0

contains

  subroutine configure(length, n)
    real, intent(in) :: length
    integer, intent(in) :: n
    if (n <= 0) error stop 'configure: n must be positive'
    n_cells = n
    cell_width = length / n
  end subroutine configure

end module grid_config

program protected_demo
  use grid_config, only: n_cells, cell_width, configure
  implicit none (type, external)

  call configure(10.0, 4)
  print '(a, i0, a, f0.2)', 'n_cells = ', n_cells, ', cell_width = ', cell_width
  ! n_cells = 8        <- compile error: n_cells is PROTECTED

end program protected_demo

! Output:
! n_cells = 4, cell_width = 2.50
