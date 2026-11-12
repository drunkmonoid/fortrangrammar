! Exercise 10: trim/adjustl normalisation paired with index(..., back=.true.) and scan.

program ex10_characters
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  character(len=32) :: raw
  character(len=:), allocatable :: clean
  integer :: dot_pos, slash_pos

  raw = '   src/alpha.beta.f90   '
  clean = trim(adjustl(raw))
  dot_pos = index(clean, '.', back=.true.)
  slash_pos = scan(clean, '/\')

  write(output_unit, '(a,1x,a,1x,i0)') 'ext, slash:', clean(dot_pos + 1:), slash_pos

end program ex10_characters

! Output:
! ext, slash: f90 4
