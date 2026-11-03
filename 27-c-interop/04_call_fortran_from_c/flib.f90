! flib.f90 - Fortran procedures and data exported to C.
!
! * bind(c, name='...') on a procedure gives it a C-callable symbol.
! * VALUE dummies receive C by-value arguments; others receive pointers.
! * A BIND(C) module variable is a C global (declare it extern in C).
! * The C side needs prototypes - write a header (here: flib.h).
! * When a C main program calls Fortran, the Fortran runtime is set up
!   automatically by gfortran's library; no init call is needed for plain
!   code (I/O works too).
module flib
  use, intrinsic :: iso_c_binding, only: c_int, c_double
  implicit none (type, external)
  private
  public :: counter, f_norm, f_fill, f_hello

  integer(c_int), bind(c, name='f_counter') :: counter = 0

contains

  function f_norm(x, n) result(r) bind(c, name='f_norm')
    integer(c_int), value :: n
    real(c_double), intent(in) :: x(n)
    real(c_double) :: r
    counter = counter + 1
    r = norm2(x)
  end function f_norm

  subroutine f_fill(x, n, value) bind(c, name='f_fill')
    integer(c_int), value :: n
    real(c_double), intent(out) :: x(n)
    real(c_double), value :: value
    counter = counter + 1
    x = value
  end subroutine f_fill

  subroutine f_hello() bind(c, name='f_hello')
    counter = counter + 1
    print '(a)', 'hello from Fortran, called by C'
    flush (6)
  end subroutine f_hello

end module flib
