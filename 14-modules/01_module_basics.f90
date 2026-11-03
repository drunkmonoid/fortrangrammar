! -----------------------------------------------------------------------------
! 01_module_basics.f90 - what a module contains
!
! Run:  scripts/run.sh 14-modules/01_module_basics.f90
! -----------------------------------------------------------------------------
!
!   module name
!     use ...                     other modules
!     implicit none (...)         applies to the whole module
!     declarations                constants, variables, types, interfaces
!   contains
!     module procedures           all get explicit interfaces automatically
!   end module name
!
! A module is the unit of encapsulation and reuse in Fortran:
!   * compiled once into a .mod file (interface) + object code;
!   * other units access it with USE;
!   * module variables live for the whole program (implicitly SAVE);
!   * module procedures see everything in the module by host association;
!   * no executable statements outside procedures.
! Modules replace COMMON blocks, INCLUDE files and external procedures.

module statistics
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none (type, external)

  ! Named constant.
  real(dp), parameter :: tolerance = 1.0e-12_dp

  ! Derived type.
  type :: summary
    integer :: n = 0
    real(dp) :: mean = 0, std = 0, minimum = 0, maximum = 0
  end type summary

  ! Module variable: persistent state.
  integer :: summaries_computed = 0

contains

  function summarise(x) result(s)
    real(dp), intent(in) :: x(:)
    type(summary) :: s

    summaries_computed = summaries_computed + 1
    s%n = size(x)
    if (s%n == 0) return
    s%mean = sum(x) / s%n
    s%std = sqrt(sum((x - s%mean)**2) / max(s%n - 1, 1))
    s%minimum = minval(x)
    s%maximum = maxval(x)
  end function summarise

  subroutine print_summary(s)
    type(summary), intent(in) :: s
    print '(a, i0, 4(a, f0.4))', 'n=', s%n, ' mean=', s%mean, ' std=', s%std, &
        ' min=', s%minimum, ' max=', s%maximum
  end subroutine print_summary

end module statistics

program module_basics
  use, intrinsic :: iso_fortran_env, only: dp => real64
  use statistics                ! everything public; prefer ONLY (02_use_only_rename.f90)
  implicit none (type, external)

  call print_summary(summarise([1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp]))
  call print_summary(summarise([10.0_dp, 10.0_dp]))
  print '(a, i0)', 'summaries computed: ', summaries_computed
  print '(a, es8.1)', 'tolerance: ', tolerance

end program module_basics

! Output:
! n=4 mean=2.5000 std=1.2910 min=1.0000 max=4.0000
! n=2 mean=10.0000 std=.0000 min=10.0000 max=10.0000
! summaries computed: 2
! tolerance:  1.0E-12
