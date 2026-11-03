! @build fail
! -----------------------------------------------------------------------------
! 05_implicit_none_external_error.f90 - a program that must NOT compile
!
! Try: scripts/run.sh 01-getting-started/05_implicit_none_external_error.f90
! -----------------------------------------------------------------------------
!
! `implicit none (external)` forbids calling a procedure that has neither an
! explicit interface nor the EXTERNAL attribute. Without it, the call below
! would compile and only fail at link time (or, worse, link against some
! unrelated symbol with a different argument list).
!
! gfortran reports something like:
!   Error: Procedure 'undeclared_helper' called at (1) is not explicitly
!          declared

program implicit_none_external_error
  implicit none (type, external)

  call undeclared_helper(42)

end program implicit_none_external_error
