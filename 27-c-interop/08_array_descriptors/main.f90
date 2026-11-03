! main.f90 - assumed-shape, assumed-rank and allocatable dummies in BIND(C)
! interfaces (F2018). The C side receives a CFI_cdesc_t * and uses the
! macros/functions of ISO_Fortran_binding.h (CFI_address, CFI_allocate,
! CFI_is_contiguous, CFI_establish, CFI_section, ...).
!
! Also interoperable through descriptors: type(*) (assumed type: any type,
! like void *), character(len=*) dummies, pointer dummies.
program array_descriptors
  use, intrinsic :: iso_c_binding, only: c_double, c_int
  implicit none (type, external)

  interface
    real(c_double) function sum_any(a) bind(c, name='sum_any')
      import :: c_double
      real(c_double), intent(in) :: a(..)
    end function sum_any

    subroutine describe(a) bind(c, name='describe')
      import :: c_double
      real(c_double), intent(in) :: a(:)
    end subroutine describe

    integer(c_int) function make_range(a, n) bind(c, name='make_range')
      import :: c_double, c_int
      real(c_double), allocatable, intent(out) :: a(:)
      integer(c_int), value :: n
    end function make_range
  end interface

  real(c_double) :: v(10), m(3, 4)
  real(c_double), allocatable :: r(:)
  integer :: i

  v = [(real(i, c_double), i = 1, 10)]
  m = 1

  print '(a, f0.1)', 'sum_any(v)       = ', sum_any(v)
  print '(a, f0.1)', 'sum_any(m)       = ', sum_any(m)
  print '(a, f0.1)', 'sum_any(v(::3))  = ', sum_any(v(::3))
  print '(a, f0.1)', 'sum_any(scalar)  = ', sum_any(2.5_c_double)

  flush (6)
  call describe(v)
  call describe(v(::2))                       ! no copy: stride in descriptor

  if (make_range(r, 5_c_int) /= 0) error stop 'CFI_allocate failed'
  print '(a, *(1x, f0.1))', 'allocated in C:', r
end program array_descriptors
