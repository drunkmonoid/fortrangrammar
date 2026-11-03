! -----------------------------------------------------------------------------
! 06_pointer_results_and_targets.f90 - pointer functions, TARGET dummies
!
! Run:  scripts/run.sh 21-pointers/06_pointer_results_and_targets.f90
! -----------------------------------------------------------------------------
!
! * A function may return a POINTER. Use it with pointer assignment
!   (p => f(x)); with ordinary assignment the target's VALUE is copied.
!   Since F2008 a pointer function reference can even appear on the LEFT of
!   an assignment: f(x) = 5 stores into the returned target.
! * A pointer returned from a function must point at something that
!   outlives the call: a module variable with TARGET, an allocated target,
!   or a TARGET actual argument.
! * TARGET on a dummy argument: pointers associated with the dummy remain
!   valid after return ONLY if the actual argument was itself a TARGET (and
!   not a copy made for copy-in/out). Otherwise they become undefined.
! * A pointer to a non-SAVE local variable is always dangling after return.

module registry
  implicit none (type, external)
  private
  public :: slot, largest

  integer, target :: table(5) = 0         ! module storage outlives calls

contains

  function slot(i) result(p)
    integer, intent(in) :: i
    integer, pointer :: p
    p => table(i)
  end function slot

  function largest(a) result(p)
    integer, target, intent(in) :: a(:)
    integer, pointer :: p
    p => a(maxloc(a, dim=1))
  end function largest

end module registry

program pointer_results_and_targets
  use registry, only: slot, largest
  implicit none (type, external)

  integer, pointer :: p => null()
  integer, target :: data(4) = [3, 9, 2, 7]

  p => slot(2)
  p = 42
  slot(4) = 7                              ! F2008: pointer function as a variable
  print '(a, i0, 1x, i0)', 'slot(2), slot(4) = ', slot(2), slot(4)

  p => largest(data)                       ! data is a TARGET: p stays valid
  p = 0                                    ! zero the largest element in place
  print '(a, *(1x, i0))', 'data after zeroing max:', data

end program pointer_results_and_targets

! Output:
! slot(2), slot(4) = 42 7
! data after zeroing max: 3 0 2 7
