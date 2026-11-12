! Exercise 08: sourced allocation paired with move_alloc buffer growth.

program ex08_arrays_dynamic
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer, allocatable :: buf(:), tmp(:)

  allocate(buf, source=[10, 20, 30])
  allocate(tmp(5))
  tmp(1:size(buf)) = buf
  tmp(4:5) = [40, 50]
  call move_alloc(from=tmp, to=buf)

  write(output_unit, '(a,1x,l1,1x,i0)') 'tmp freed, sum:', .not. allocated(tmp), sum(buf)

end program ex08_arrays_dynamic

! Output:
! tmp freed, sum: T 150
