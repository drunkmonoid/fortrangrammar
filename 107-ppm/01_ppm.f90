! Write a 2x2 ASCII PPM (P3) image to a scratch file, rewind, skip the header,
! and read back all 12 RGB channel integers before closing (auto-deleting) the scratch file.

program ppm_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer, parameter :: width = 2, height = 2, maxval = 255
  integer, parameter :: pixels(12) = [ &
    255,   0,   0, &
      0, 255,   0, &
      0,   0, 255, &
    128,  64,  32 ]
  integer :: read_back(12)
  integer :: u, w, h, mv, i
  character(len=2) :: magic

  open(newunit=u, status='scratch', form='formatted', action='readwrite')
  write(u, '(a)') 'P3'
  write(u, '(i0,1x,i0)') width, height
  write(u, '(i0)') maxval
  do i = 1, 12, 3
    write(u, '(i0,1x,i0,1x,i0)') pixels(i), pixels(i + 1), pixels(i + 2)
  end do

  rewind(u)
  read(u, '(a2)') magic
  read(u, *) w, h
  read(u, *) mv
  read(u, *) read_back
  close(u)

  if (magic /= 'P3' .or. w /= width .or. h /= height .or. mv /= maxval) then
    error stop 'unexpected PPM header'
  end if

  write(output_unit, '(12(i0, :, 1x))') read_back

end program ppm_demo

! Output:
! 255 0 0 0 255 0 0 0 255 128 64 32
