! @args --size 42 input.dat
! -----------------------------------------------------------------------------
! 03_command_line.f90 - command-line arguments (F2003)
!
! Run:  scripts/run.sh 24-errors-environment/03_command_line.f90 --size 42 input.dat
! -----------------------------------------------------------------------------
!
!   command_argument_count()                      number of arguments
!   call get_command_argument(i [, value] [, length] [, status])
!       i = 0 gives the program name. length is the full length even if
!       value is too short; status: 0 ok, -1 truncated, > 0 failure.
!   call get_command([command] [, length] [, status])
!       the whole command line as one string
!
! Query the length first to allocate a deferred-length string of exactly
! the right size - the robust pattern below.

module cli
  implicit none (type, external)
  private
  public :: argument

contains

  function argument(i) result(arg)
    integer, intent(in) :: i
    character(len=:), allocatable :: arg
    integer :: n, status
    call get_command_argument(i, length=n, status=status)
    if (status > 0) error stop 'cannot read command argument'
    allocate (character(len=n) :: arg)
    call get_command_argument(i, value=arg)
  end function argument

end module cli

program command_line
  use cli, only: argument
  implicit none (type, external)

  integer :: i, n, size_value, ios
  character(len=:), allocatable :: text   ! internal files must be variables

  n = command_argument_count()
  print '(a, i0)', 'argument count: ', n
  do i = 1, n
    print '(a, i0, 3a)', '  arg ', i, ': "', argument(i), '"'
  end do

  ! A tiny option parser.
  size_value = 10
  i = 1
  do while (i <= n)
    select case (argument(i))
    case ('--size')
      if (i + 1 > n) error stop '--size needs a value'
      text = argument(i + 1)
      read (text, *, iostat=ios) size_value
      if (ios /= 0) error stop '--size needs an integer'
      i = i + 2
    case default
      print '(3a)', 'positional argument: "', argument(i), '"'
      i = i + 1
    end select
  end do
  print '(a, i0)', 'size = ', size_value

end program command_line

! Output:
! argument count: 3
!   arg 1: "--size"
!   arg 2: "42"
!   arg 3: "input.dat"
! positional argument: "input.dat"
! size = 42
