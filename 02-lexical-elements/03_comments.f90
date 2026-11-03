! -----------------------------------------------------------------------------
! 03_comments.f90 - comments
!
! Run:  scripts/run.sh 02-lexical-elements/03_comments.f90
! -----------------------------------------------------------------------------
!
! In free form, `!` starts a comment that runs to the end of the line,
! unless the `!` is inside a character literal. There is no block-comment
! syntax: comment several lines by starting each with `!`.
!
! Some tools give extra meaning to special comment prefixes. To the compiler
! they are still ordinary comments unless a matching option is enabled:
!
!   !$ code       OpenMP conditional compilation (only with -fopenmp)
!   !$omp ...     OpenMP directive                (chapter 29)
!   !$acc ...     OpenACC directive               (chapter 29)
!   !GCC$ ...     gfortran directive (e.g. !GCC$ ATTRIBUTES)
!   !DIR$ ...     Intel / Cray directives
!   !! or !>     FORD documentation comments     (chapter 30)

program comments
  implicit none (type, external)

  !! FORD would treat this as documentation for the following entity.
  integer :: n   ! a trailing comment after a statement

  n = 1          ! comments may follow any statement
  ! n = 1000     <- this line is commented out, so it has no effect

  ! An exclamation mark inside a string is data, not a comment:
  print '(a)', 'Hello! This ! is not a comment'

  ! A comment may sit between continuation lines (see 04_continuation.f90):
  print '(a, i0)', &
    ! this comment line is skipped while the statement continues
    'n = ', n

  ! Conditional compilation: this line only exists when OpenMP is enabled.
  !$ print '(a)', 'compiled with OpenMP'

end program comments

! Output:
! Hello! This ! is not a comment
! n = 1
