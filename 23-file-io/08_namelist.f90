! -----------------------------------------------------------------------------
! 08_namelist.f90 - NAMELIST: self-describing input/output
!
! Run:  scripts/run.sh 23-file-io/08_namelist.f90
! -----------------------------------------------------------------------------
!
!   namelist /config/ n_steps, dt, method, enabled
!   read (u, nml=config)        write (u, nml=config)
!
! A namelist file names every variable, so input files are readable and
! order-independent - the classic format for simulation parameters:
!
!   &config
!     n_steps = 200,
!     dt = 0.01,          ! comments after ! (F2003)
!     method = 'rk4'
!   /
!
! * Variables missing from the input KEEP their current values, so set
!   defaults before reading.
! * Arrays: x = 1, 2, 3   or   x(2) = 5   or   x = 3*0.
! * Derived-type components: p%x = 1.0.
! * Internal files work too (F2003), as used below.

program namelist_demo
  implicit none (type, external)

  integer :: n_steps = 100
  real :: dt = 0.1
  character(len=8) :: method = 'euler'
  logical :: enabled = .false.
  real :: weights(3) = 1.0
  namelist /config/ n_steps, dt, method, enabled, weights

  character(len=200) :: input
  integer :: u, ios
  character(len=256) :: msg

  ! Input with comments, any order, some variables omitted.
  input = "&config  method = 'rk4', ! integrator" // new_line('a') // &
          "         n_steps = 250, weights(2) = 5.0 /"

  open (newunit=u, status='scratch')
  write (u, '(a)') input
  rewind (u)
  read (u, nml=config, iostat=ios, iomsg=msg)
  if (ios /= 0) error stop trim(msg)
  close (u)

  print '(a, i0)', 'n_steps = ', n_steps
  print '(a, f0.2, a)', 'dt      = ', dt, '   (kept its default)'
  print '(2a)', 'method  = ', trim(method)
  print '(a, *(1x, f0.1))', 'weights =', weights

  ! Writing a namelist produces the same format.
  write (*, nml=config)

end program namelist_demo

! Output:
! n_steps = 250
! dt      = .10   (kept its default)
! method  = rk4
! weights = 1.0 5.0 1.0
! &CONFIG
!  N_STEPS=250        ,
!  DT= 0.100000001    ,
!  METHOD="rk4     ",
!  ENABLED=F,
!  WEIGHTS=  1.00000000    ,  5.00000000    ,  1.00000000    ,
!  /
