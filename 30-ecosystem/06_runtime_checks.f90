! @exit 2
! -----------------------------------------------------------------------------
! 06_runtime_checks.f90 - letting the compiler catch bugs at run time
!
! Run:  scripts/run.sh 30-ecosystem/06_runtime_checks.f90; echo "exit $?"
! -----------------------------------------------------------------------------
!
! This program has a deliberate out-of-bounds write. Built with the
! tutorial's default flags (-fcheck=all -g -fbacktrace) it stops with
!
!   Fortran runtime error: Index '6' of dimension 1 of array 'a' above
!   upper bound of 5
!
! plus a backtrace pointing at the line, and exit status 2. Without
! -fcheck it would silently corrupt memory.
!
! Other debugging aids (see 06_debugging.md):
!   -ffpe-trap=invalid,zero,overflow    abort on the first NaN/Inf
!   -finit-real=snan -finit-integer=-99999   expose uninitialised variables
!   -fsanitize=address,undefined        AddressSanitizer / UBSan
!   gdb ./a.out  (break, run, bt, print a, ptype a)
!   valgrind ./a.out                    memory errors and leaks

program runtime_checks
  implicit none (type, external)

  integer :: a(5), i, n

  n = 6                                ! one too many
  do i = 1, n
    a(i) = i
  end do
  print *, a

end program runtime_checks
