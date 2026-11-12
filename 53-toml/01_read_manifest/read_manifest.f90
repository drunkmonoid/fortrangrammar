! Read an fpm-style TOML manifest using toml-f.
program read_manifest
  use, intrinsic :: iso_fortran_env, only: error_unit, output_unit
  use tomlf, only: toml_table, toml_parse, toml_error, get_value
  implicit none (type, external)

  type(toml_table) :: table
  type(toml_table), pointer :: lib_node, dep_node
  type(toml_error), allocatable :: error
  character(len=:), allocatable :: name, src_dir, ver
  integer :: stat

  ! Parse manifest
  call toml_parse(table, "fpm.toml", error)
  if (allocated(error)) then
    write(error_unit, '(a)') error%message
    error stop 1
  end if

  ! Read top-level keys
  call get_value(table, "name", name, stat=stat)
  if (stat == 0) then
    write(output_unit, '(a,a)') 'package: ', name
  end if

  ! Read [library] table
  call get_value(table, "library", lib_node, stat=stat)
  if (stat == 0 .and. associated(lib_node)) then
    call get_value(lib_node, "source-dir", src_dir, default="src")
    write(output_unit, '(a,a)') 'source-dir: ', src_dir
  end if

  ! Read [dependencies] table
  call get_value(table, "dependencies", dep_node, stat=stat)
  if (stat == 0 .and. associated(dep_node)) then
    call get_value(dep_node, "stdlib", ver, stat=stat)
    if (stat == 0) then
      write(output_unit, '(a,a)') 'dependency stdlib: ', ver
    end if
  end if
end program read_manifest
