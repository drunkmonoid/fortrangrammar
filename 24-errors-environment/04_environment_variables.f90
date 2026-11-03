! -----------------------------------------------------------------------------
! 04_environment_variables.f90 - reading environment variables (F2003)
!
! Run:  scripts/run.sh 24-errors-environment/04_environment_variables.f90
!       MY_SETTING=hello scripts/run.sh 24-errors-environment/04_environment_variables.f90
! -----------------------------------------------------------------------------
!
!   call get_environment_variable(name [, value] [, length] [, status]
!                                 [, trim_name] [, errmsg])
!
!   status:  0  exists (value assigned)
!            1  does not exist
!           -1  value too short for the content (truncated)
!            2  environment variables not supported
!   length:  the full length of the value (0 if unset or empty)
!   errmsg:  F2023 - explanation on failure (gfortran 15: not yet)
!
! There is no standard way to SET environment variables; use the C library
! (setenv) through C interoperability, or execute_command_line for children.

program environment_variables
  implicit none (type, external)

  character(len=:), allocatable :: value
  integer :: n, status

  call get_environment_variable('MY_SETTING', length=n, status=status)
  if (status == 1) then
    print '(a)', 'MY_SETTING is not set; using the default "none"'
    value = 'none'
  else
    allocate (character(len=n) :: value)
    call get_environment_variable('MY_SETTING', value)
  end if
  print '(2a)', 'MY_SETTING = ', value

  call get_environment_variable('PATH', length=n, status=status)
  print '(a, i0, a, l1)', 'PATH has ', n, ' characters; set: ', status == 0

end program environment_variables
