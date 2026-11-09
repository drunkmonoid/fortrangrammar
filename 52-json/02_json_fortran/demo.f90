! -----------------------------------------------------------------------------
! demo.f90 - the same document read with json-fortran
!
! Build: scripts/run.sh 52-json/02_json_fortran/
! -----------------------------------------------------------------------------
!
! json_file lives in json_module. This file is the optional path; the
! subset in 01_subset.f90 does not need it.

program json_fortran_demo
  use json_module, only: json_file
  implicit none (type, external)

  type(json_file) :: json
  character(len=:), allocatable :: name
  logical :: found

  call json%initialize()
  call json%deserialize('{"name":"ada","n":2}')
  call json%get('name', name, found)
  if (.not. found) error stop 'name'
  print '(a)', 'name = ' // name
  call json%destroy()

end program json_fortran_demo
