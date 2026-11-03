! @exit 3
! -----------------------------------------------------------------------------
! 07_stop.f90 - normal termination with STOP
!
! Run:  scripts/run.sh 06-control-flow/07_stop.f90; echo "exit status: $?"
! -----------------------------------------------------------------------------
!
!   stop                          normal termination, status 0
!   stop int-expr                 the value becomes the process exit status
!   stop char-expr                the text is written to stderr; status 0
!   stop code, quiet=logical      (F2018) quiet=.true. suppresses the message
!
! * The stop code may be any scalar integer or character EXPRESSION (F2018),
!   not just a literal.
! * Reaching END PROGRAM is equivalent to a plain STOP.
! * STOP is "normal termination": files are closed and buffers flushed. With
!   coarrays, the image waits for the others (chapter 28).
! * If IEEE floating-point exceptions are signalling at STOP, gfortran
!   prints a note about them on stderr.
!
! Use STOP for a deliberate end of the program. For failures use
! ERROR STOP (08_error_stop.f90), which signals an error to the caller.

program stop_demo
  implicit none (type, external)

  integer :: status

  status = 3
  print '(a)', 'about to stop with status 3'
  stop status, quiet=.true.

  print '(a)', 'never printed'

end program stop_demo
