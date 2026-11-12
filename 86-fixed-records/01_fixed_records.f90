! -----------------------------------------------------------------------------
! 01_fixed_records.f90 - Fixed-width columnar records via scratch file I/O
!
! Run:  scripts/run.sh 86-fixed-records/01_fixed_records.f90
! -----------------------------------------------------------------------------
!
! Fixed-width column layout (18 chars per record):
!   Columns  1..4  (width 4): integer id
!   Columns  5..12 (width 8): character name (blank-padded on write, trimmed on read)
!   Columns 13..18 (width 6): integer value
!
! Unlike delimited CSV (phase 50), fields are located strictly by character
! offset. Uses a Fortran scratch file (chapter 23) that disappears on close.

program fixed_records
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  type :: record_t
    integer :: id
    character(len=8) :: name
    integer :: val
  end type record_t

  type(record_t) :: input_rows(3)
  integer :: u, i, id, val, ios
  character(len=18) :: line
  character(len=:), allocatable :: trimmed_name

  input_rows(1) = record_t(101,  'alpha', 42)
  input_rows(2) = record_t(2,    'beta',  999)
  input_rows(3) = record_t(3004, 'gamma', 7)

  open(newunit=u, status='scratch', action='readwrite', form='formatted')

  do i = 1, size(input_rows)
    write(u, '(i4,a8,i6)') input_rows(i)%id, input_rows(i)%name, input_rows(i)%val
  end do

  rewind(u)

  do
    read(u, '(a)', iostat=ios) line
    if (ios /= 0) exit

    read(line(1:4), '(i4)') id
    trimmed_name = trim(adjustl(line(5:12)))
    read(line(13:18), '(i6)') val

    write(output_unit, '(a,i0,1x,a,a,1x,a,i0)') &
      'id=', id, 'name=', trimmed_name, 'val=', val
  end do

  close(u)

end program fixed_records

! Output:
! id=101 name=alpha val=42
! id=2 name=beta val=999
! id=3004 name=gamma val=7
