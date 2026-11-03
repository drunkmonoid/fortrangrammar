! -----------------------------------------------------------------------------
! 07_c_pointers.f90 - type(c_ptr), c_loc, c_f_pointer, c_associated
!
! Run:  scripts/run.sh 27-c-interop/07_c_pointers.f90
! -----------------------------------------------------------------------------
!
!   c_loc(x)                      C address of a TARGET (or pointer) x
!   c_f_pointer(cptr, fptr [, shape] [, lower])
!                                 make a Fortran pointer to C memory;
!                                 SHAPE is required for array pointers;
!                                 LOWER (F2023) sets lower bounds
!   c_associated(c1 [, c2])       is c1 non-null (and equal to c2)?
!   c_null_ptr, c_null_funptr     null C pointers
!   c_funloc / c_f_procpointer    the same for procedures
!
! Here we call the C library's malloc and free directly: memory owned by C
! is used through a Fortran array pointer, then returned to C. libc is
! linked automatically, so this is a single-file program.

program c_pointers
  use, intrinsic :: iso_c_binding, only: c_ptr, c_size_t, c_double, c_null_ptr, &
                                         c_loc, c_f_pointer, c_associated, c_sizeof
  implicit none (type, external)

  interface
    type(c_ptr) function malloc(size) bind(c, name='malloc')
      import :: c_ptr, c_size_t
      integer(c_size_t), value :: size
    end function malloc

    subroutine free(ptr) bind(c, name='free')
      import :: c_ptr
      type(c_ptr), value :: ptr
    end subroutine free
  end interface

  type(c_ptr) :: mem
  real(c_double), pointer :: grid(:, :)
  real(c_double), target :: x
  integer, parameter :: n = 3, m = 4

  mem = malloc(n * m * c_sizeof(0.0_c_double))
  if (.not. c_associated(mem)) error stop 'malloc failed'

  call c_f_pointer(mem, grid, [n, m])        ! view C memory as a 3x4 array
  grid = 1.5_c_double
  grid(2, :) = -1
  print '(a, *(1x, i0))', 'shape of C-allocated grid:', shape(grid)
  print '(a, f0.2)', 'sum(grid) = ', sum(grid)

  call free(mem)
  nullify (grid)
  mem = c_null_ptr
  print '(a, l1)', 'c_associated after free: ', c_associated(mem)

  ! c_loc of a Fortran TARGET and back again.
  x = 42
  mem = c_loc(x)
  block
    real(c_double), pointer :: px
    call c_f_pointer(mem, px)
    px = px + 1
  end block
  print '(a, f0.1, a, l1)', 'x via C pointer: ', x, ', same address: ', c_associated(mem, c_loc(x))

end program c_pointers

! Output:
! shape of C-allocated grid: 3 4
! sum(grid) = 8.00
! c_associated after free: F
! x via C pointer: 43.0, same address: T
