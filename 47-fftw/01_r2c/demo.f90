! -----------------------------------------------------------------------------
! demo.f90 - one real-to-complex FFTW plan, then destroy it
!
! Build: scripts/run.sh 47-fftw/01_r2c/
! -----------------------------------------------------------------------------
!
! FFTW_ESTIMATE is 64. A wisdom file is not read. The input [1, 1, 1, 1]
! has an unnormalised DC bin of 4 and zeros in the other bins.

program fftw_demo
  use, intrinsic :: iso_c_binding, only: c_int, c_double, c_ptr, c_associated
  implicit none (type, external)

  integer, parameter :: n = 4
  integer, parameter :: estimate = 64
  real(c_double) :: input(n), output(2, n / 2 + 1)
  type(c_ptr) :: plan
  real(c_double) :: rest

  interface
    function fftw_plan_dft_r2c_1d(n, in, out, flags) bind(c, name='fftw_plan_dft_r2c_1d')
      import :: c_int, c_double, c_ptr
      integer(c_int), value :: n
      real(c_double), intent(inout) :: in(*)
      real(c_double), intent(out) :: out(*)
      integer(c_int), value :: flags
      type(c_ptr) :: fftw_plan_dft_r2c_1d
    end function fftw_plan_dft_r2c_1d

    subroutine fftw_execute(plan) bind(c, name='fftw_execute')
      import :: c_ptr
      type(c_ptr), value :: plan
    end subroutine fftw_execute

    subroutine fftw_destroy_plan(plan) bind(c, name='fftw_destroy_plan')
      import :: c_ptr
      type(c_ptr), value :: plan
    end subroutine fftw_destroy_plan
  end interface

  input = 1.0_c_double
  output = 0.0_c_double
  plan = fftw_plan_dft_r2c_1d(n, input, output, estimate)
  if (.not. c_associated(plan)) error stop 'null plan'
  call fftw_execute(plan)
  call fftw_destroy_plan(plan)

  rest = sum(abs(output(:, 2:)))
  if (abs(output(1, 1) - real(n, c_double)) > 1.0e-8_c_double) error stop 'dc bin'
  if (abs(output(2, 1)) > 1.0e-8_c_double .or. rest > 1.0e-8_c_double) error stop 'other bins'
  print '(a, i0)', 'dc = ', nint(output(1, 1))
  print '(a, i0)', 'rest = ', nint(rest)

end program fftw_demo
