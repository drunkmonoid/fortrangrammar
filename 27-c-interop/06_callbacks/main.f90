! main.f90 - passing Fortran procedures to C as callbacks.
!
! * The callback must itself be BIND(C) so C can call it with C
!   conventions (arguments by value or pointer as declared).
! * c_funloc(proc) gives a type(c_funptr) - a C function pointer.
! * Example 1: the C library function qsort sorts a Fortran array using a
!   Fortran comparison function.
! * Example 2: C code (callback.c) calls back into Fortran repeatedly.
module callbacks
  use, intrinsic :: iso_c_binding, only: c_int, c_double, c_ptr, c_f_pointer
  implicit none (type, external)
contains

  ! int (*compar)(const void *, const void *)
  integer(c_int) function compare_ints(a, b) bind(c)
    type(c_ptr), value :: a, b
    integer(c_int), pointer :: x, y
    call c_f_pointer(a, x)
    call c_f_pointer(b, y)
    compare_ints = merge(-1, merge(1, 0, x > y), x < y)
  end function compare_ints

  real(c_double) function square(x) bind(c)
    real(c_double), value :: x
    square = x * x
  end function square

end module callbacks

program callbacks_demo
  use, intrinsic :: iso_c_binding, only: c_int, c_double, c_size_t, c_ptr, c_funptr, &
                                         c_loc, c_funloc, c_sizeof
  use callbacks, only: compare_ints, square
  implicit none (type, external)

  interface
    ! void qsort(void *base, size_t nmemb, size_t size, int (*compar)(...));
    subroutine qsort(base, nmemb, size, compar) bind(c, name='qsort')
      import :: c_ptr, c_size_t, c_funptr
      type(c_ptr), value :: base
      integer(c_size_t), value :: nmemb, size
      type(c_funptr), value :: compar
    end subroutine qsort

    ! double integrate(double (*f)(double), double a, double b, int n);
    real(c_double) function integrate(f, a, b, n) bind(c, name='integrate')
      import :: c_funptr, c_double, c_int
      type(c_funptr), value :: f
      real(c_double), value :: a, b
      integer(c_int), value :: n
    end function integrate
  end interface

  integer(c_int), target :: values(8) = [42, 7, -3, 19, 0, 7, 100, -50]

  call qsort(c_loc(values), size(values, kind=c_size_t), c_sizeof(values(1)), &
             c_funloc(compare_ints))
  print '(a, *(1x, i0))', 'sorted by C qsort:', values

  print '(a, f0.6)', 'C integrates Fortran x**2 on [0,1]: ', &
      integrate(c_funloc(square), 0.0_c_double, 1.0_c_double, 1000_c_int)
end program callbacks_demo
