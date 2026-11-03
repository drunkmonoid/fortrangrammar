! -----------------------------------------------------------------------------
! 05_execute_command_line.f90 - running other programs (F2008)
!
! Run:  scripts/run.sh 24-errors-environment/05_execute_command_line.f90
! -----------------------------------------------------------------------------
!
!   call execute_command_line(command [, wait] [, exitstat] [, cmdstat]
!                             [, cmdmsg])
!
!   wait      .true. (default): block until the command finishes;
!             .false.: run it asynchronously (if supported)
!   exitstat  the command's exit status (when waited for)
!   cmdstat   0 ok; -1 not supported; -2 async not supported; > 0 other
!             failure (e.g. the shell could not be started)
!   cmdmsg    description when cmdstat > 0
!
! The command runs in a shell; its output goes to the same terminal, so
! FLUSH your own output first to keep the ordering. Never build commands
! from untrusted input.

program execute_command_line_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer :: exitstat, cmdstat
  character(len=256) :: cmdmsg

  print '(a)', 'before the command'
  flush (output_unit)
  call execute_command_line('echo "hello from the shell"', exitstat=exitstat, &
                            cmdstat=cmdstat, cmdmsg=cmdmsg)
  print '(a, i0, a, i0)', 'exitstat = ', exitstat, ', cmdstat = ', cmdstat

  call execute_command_line('exit 3', exitstat=exitstat, cmdstat=cmdstat)
  print '(a, i0)', 'exit 3 -> exitstat = ', exitstat

end program execute_command_line_demo

! Output:
! before the command
! hello from the shell
! exitstat = 0, cmdstat = 0
! exit 3 -> exitstat = 3
