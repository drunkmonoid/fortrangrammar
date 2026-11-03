! -----------------------------------------------------------------------------
! 02_select_case.f90 - SELECT CASE
!
! Run:  scripts/run.sh 06-control-flow/02_select_case.f90
! -----------------------------------------------------------------------------
!
!   [name:] select case (expr)
!   case (value-list) [name]
!   case default [name]
!   end select [name]
!
! * expr is a scalar INTEGER, CHARACTER or LOGICAL (and F2023 enumeration
!   types). REAL is not allowed: use IF for floating point.
! * Each case-value is a constant, or a range:
!     (5)       exactly 5        (1, 3, 5)  a list
!     (2:7)     2 <= x <= 7      (:0)       x <= 0
!     (100:)    x >= 100         ('a':'m')  character range
! * Cases must not overlap - checked at compile time.
! * No fall-through: exactly one block runs, no `break` needed.
! * case default may appear anywhere (conventionally last), at most once.
! * Character values are compared after blank padding, like ==.

program select_case
  implicit none (type, external)

  integer :: score, k
  integer :: scores(6) = [-1, 0, 55, 75, 95, 101]
  character(len=:), allocatable :: command
  character(len=8) :: commands(4) = [character(len=8) :: 'start', 'STOP', 'help', 'pause']
  logical :: flag

  do k = 1, size(scores)
    score = scores(k)
    select case (score)
    case (:-1, 101:)
      print '(i0, a)', score, ': invalid'
    case (0)
      print '(i0, a)', score, ': nothing'
    case (1:59)
      print '(i0, a)', score, ': fail'
    case (60:89)
      print '(i0, a)', score, ': pass'
    case default
      print '(i0, a)', score, ': excellent'
    end select
  end do

  do k = 1, size(commands)
    command = trim(commands(k))
    dispatch: select case (command)
    case ('start', 'run')
      print '(2a)', command, ' -> starting'
    case ('stop', 'STOP')
      print '(2a)', command, ' -> stopping'
    ! Anything sorting between 'a' and 'p'. 'help' is inside, but 'pause'
    ! is NOT: 'p' is padded to 'p    ', and 'pause' > 'p    ' because
    ! 'a' sorts after a blank.
    case ('a':'p')
      print '(2a)', command, ' -> in range a..p'
    case default dispatch
      print '(2a)', command, ' -> unknown'
    end select dispatch
  end do

  ! LOGICAL selector (rare, but legal).
  flag = score > 100
  select case (flag)
  case (.true.)
    print '(a)', 'last score was over 100'
  case (.false.)
    print '(a)', 'last score was not over 100'
  end select

end program select_case

! Output:
! -1: invalid
! 0: nothing
! 55: fail
! 75: pass
! 95: excellent
! 101: invalid
! start -> starting
! STOP -> stopping
! help -> in range a..p
! pause -> unknown
! last score was over 100
