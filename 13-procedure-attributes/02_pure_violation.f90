! @build fail
! -----------------------------------------------------------------------------
! 02_pure_violation.f90 - what PURE forbids (must not compile)
!
! Try: scripts/run.sh 13-procedure-attributes/02_pure_violation.f90
! -----------------------------------------------------------------------------
!
! Each marked line is a separate violation; gfortran reports all of them:
!   * modifying a module variable,
!   * a local with an initialiser (implicitly SAVEd),
!   * printing to an external unit,
!   * calling an impure procedure.

module impure_things
  implicit none (type, external)
  integer :: counter = 0
contains

  subroutine log_it()
    print *, 'impure'
  end subroutine log_it

  pure integer function bad(n)
    integer, intent(in) :: n
    integer :: calls = 0          ! VIOLATION: implicit SAVE
    counter = counter + 1         ! VIOLATION: modifies module variable
    print *, n                    ! VIOLATION: external I/O
    call log_it()                 ! VIOLATION: calls impure procedure
    bad = n + calls
  end function bad

end module impure_things

program pure_violation
  use impure_things, only: bad
  implicit none (type, external)
  print *, bad(1)
end program pure_violation
