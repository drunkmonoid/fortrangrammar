! -----------------------------------------------------------------------------
! 04_continuation.f90 - continuing a statement over several lines
!
! Run:  scripts/run.sh 02-lexical-elements/04_continuation.f90
! -----------------------------------------------------------------------------
!
! Rules (free form):
!
!   * An `&` as the last non-blank, non-comment character of a line means
!     "the statement continues on the next line".
!   * The next line may optionally start with `&` (after blanks). If it
!     does, the statement resumes right after that `&`; if not, it resumes at
!     the first character of the line.
!   * To split a token (a name, number or keyword) or a character literal
!     across lines you MUST use the leading `&`.
!   * Comment lines and blank lines between continuation lines are skipped.
!   * F2023 has no limit on the number of continuation lines; the limit is
!     the total statement length (1 000 000 characters).

program continuation
  implicit none (type, external)

  real :: result
  character(len=:), allocatable :: message

  ! Ordinary continuation between tokens: no leading & needed.
  result = 1.0 + 2.0 + 3.0 + &
           4.0 + 5.0
  print '(a, f0.1)', 'sum = ', result

  ! Leading & is allowed even when not needed; some styles use it always.
  result = 10.0 * &
         & 2.0
  print '(a, f0.1)', 'product = ', result

  ! Splitting a character literal: the leading & is required. Text resumes
  ! immediately after it, so "two " + "lines" joins without extra blanks.
  message = 'this literal spans two &
            &lines'
  print '(a)', message

  ! Inside a literal, the leading & on the next line is not optional: the
  ! standard requires it, and compilers that accept code without it
  ! disagree about what the resulting text is.

  ! Splitting a single token (here the name `result`). Legal, never useful.
  res&
  &ult = 42.0
  print '(a, f0.1)', 'result = ', result

  ! Comments and blank lines in the middle of a continued statement.
  result = 1.0 &   ! first term
           + 2.0 & ! second term

           ! a full comment line here is fine too
           + 3.0
  print '(a, f0.1)', 'with comments = ', result

end program continuation

! Output:
! sum = 15.0
! product = 20.0
! this literal spans two lines
! result = 42.0
! with comments = 6.0
