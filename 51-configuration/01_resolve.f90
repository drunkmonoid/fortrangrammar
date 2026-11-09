! -----------------------------------------------------------------------------
! 01_resolve.f90 - defaults, a namelist, validation, an environment override
!
! Run:  scripts/run.sh 51-configuration/01_resolve.f90
!       FG_N_STEPS=7 scripts/run.sh 51-configuration/01_resolve.f90
! -----------------------------------------------------------------------------
!
! Set the defaults first. A namelist read only changes the names it
! mentions (chapter 23). FG_N_STEPS, when it is present and a positive
! integer, replaces n_steps afterwards. An absent variable leaves the
! namelist value alone: status 1 means "not set" (chapter 24).
!
! The output block is the run with FG_N_STEPS unset.

program resolve
  implicit none (type, external)

  integer :: n_steps
  character(len=8) :: method
  character(len=80) :: input, env
  integer :: ios, status, env_len
  namelist /job/ n_steps, method

  n_steps = 10
  method = 'euler'
  input = '&job n_steps = 40, method = ''rk4'' /'
  read (input, nml=job, iostat=ios)
  if (ios /= 0) error stop 'namelist'

  call get_environment_variable('FG_N_STEPS', env, length=env_len, status=status)
  if (status == 0) then
    read (env(1:env_len), *, iostat=ios) n_steps
    if (ios /= 0) error stop 'FG_N_STEPS'
  end if

  print '(a, i0)', 'n_steps = ', n_steps
  print '(a, a)', 'method = ', trim(method)
  print '(a, l1)', 'valid: ', valid(n_steps)
  print '(a, l1)', 'rejects negative: ', .not. valid(-1)

contains

  pure logical function valid(n)
    integer, intent(in) :: n
    valid = n > 0
  end function valid

end program resolve

! Output:
! n_steps = 40
! method = rk4
! valid: T
! rejects negative: T
