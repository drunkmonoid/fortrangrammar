! main.f90 - calling C functions through BIND(C) interfaces.
!
! * bind(c, name='dot') gives the exact C symbol (case-sensitive). Without
!   name=, the lowercase Fortran name is used.
! * C passes by value: scalars that C takes by value need VALUE; pointers
!   (double *x) correspond to ordinary (by-reference) dummies.
! * Arrays: an explicit-shape or assumed-size dummy passes the address of
!   the first element - exactly a C pointer.
! * Remember: Fortran is column-major; C indexes row-major.
program call_c
  use, intrinsic :: iso_c_binding, only: c_int, c_double
  implicit none (type, external)

  interface
    real(c_double) function dot(x, y, n) bind(c, name='dot')
      import :: c_int, c_double
      real(c_double), intent(in) :: x(*), y(*)
      integer(c_int), value :: n
    end function dot

    subroutine scale(x, n, factor) bind(c, name='scale')
      import :: c_int, c_double
      real(c_double), intent(inout) :: x(*)
      integer(c_int), value :: n
      real(c_double), value :: factor
    end subroutine scale

    subroutine minmax(v, n, lo, hi) bind(c, name='minmax')
      import :: c_int
      integer(c_int), intent(in) :: v(*)
      integer(c_int), value :: n
      integer(c_int), intent(out) :: lo, hi      ! int * in C
    end subroutine minmax

    ! Interface bodies do not inherit IMPLICIT NONE: without the line below,
    ! `rows` used in m(rows, cols) before its declaration would be
    ! implicitly REAL. Declare the bounds first.
    subroutine print_matrix(m, rows, cols) bind(c, name='print_matrix')
      import :: c_int, c_double
      implicit none
      integer(c_int), value :: rows, cols
      real(c_double), intent(in) :: m(rows, cols)
    end subroutine print_matrix
  end interface

  real(c_double) :: a(3) = [1, 2, 3], b(3) = [4, 5, 6], m(2, 3)
  integer(c_int) :: v(5) = [7, -2, 9, 4, 0], lo, hi
  integer :: i

  print '(a, f0.1)', 'dot(a, b) = ', dot(a, b, size(a, kind=c_int))
  call scale(a, 3_c_int, 10.0_c_double)
  print '(a, *(1x, f0.1))', 'scaled a  =', a
  call minmax(v, size(v, kind=c_int), lo, hi)
  print '(a, i0, 1x, i0)', 'min, max  = ', lo, hi

  m = reshape([(real(i, c_double), i = 1, 6)], shape(m))
  print '(a)', 'matrix printed by C:'
  flush (6)
  call print_matrix(m, 2_c_int, 3_c_int)
end program call_c
