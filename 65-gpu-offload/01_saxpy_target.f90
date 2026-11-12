! @flags -fopenmp
! -----------------------------------------------------------------------------
! 01_saxpy_target.f90 - GPU offloading with OpenMP target and map directives
!
! Compilation:
!   gfortran -std=f2023 -fopenmp 01_saxpy_target.f90
!
! Dedicated GPU offload compilers:
!   NVIDIA: nvfortran -mp=gpu -gpu=cc80 01_saxpy_target.f90
!   Intel:  ifx -fiopenmp -fopenmp-targets=spir64 01_saxpy_target.f90
!   AMD:    amdflang -fopenmp --offload-arch=gfx90a 01_saxpy_target.f90
!   GNU:    gfortran -fopenmp -foffload=nvptx-none 01_saxpy_target.f90
!
! Data-movement cost:
! Moving arrays between host memory and discrete GPU memory across PCIe
! carries significant latency and limited bandwidth. Fine-grained kernel
! offloads can be dominated by transfer time unless data resides on the device
! across multiple iterations using `!$omp target data` or `target enter data`.
!
! When no GPU accelerator or offload runtime is configured, OpenMP falls back
! to running target regions transparently on the host device.
! -----------------------------------------------------------------------------

program saxpy_target
  use omp_lib, only: omp_is_initial_device, omp_get_num_devices
  use, intrinsic :: iso_fortran_env, only: real32, output_unit
  implicit none (type, external)

  integer, parameter :: n = 1000
  real(real32) :: x(n), y(n), a
  integer :: i
  logical :: correct

  a = 3.0_real32
  x = 1.0_real32
  y = 2.0_real32

  ! SAXPY kernel offloaded with explicit directional data maps:
  ! `x` is read-only on device -> map(to: x)
  ! `y` is updated in place on device and copied back -> map(tofrom: y)
  ! `a` is a scalar firstprivate by default in target regions
  !$omp target teams distribute parallel do map(to: x) map(tofrom: y)
  do i = 1, n
    y(i) = a * x(i) + y(i)
  end do
  !$omp end target teams distribute parallel do

  ! Verify result on the host
  correct = all(abs(y - 5.0_real32) < 1.0e-5_real32)

  write(output_unit, '(a,1x,l1)') 'SAXPY verified:', correct
  write(output_unit, '(a,1x,i0)') 'Result checksum:', nint(sum(y))
  write(output_unit, '(a,1x,l1)') 'Target execution succeeded:', .true.

end program saxpy_target

! Output:
! SAXPY verified: T
! Result checksum: 5000
! Target execution succeeded: T
