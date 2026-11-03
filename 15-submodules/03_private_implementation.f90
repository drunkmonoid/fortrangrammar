! -----------------------------------------------------------------------------
! 03_private_implementation.f90 - hiding implementation details
!
! Run:  scripts/run.sh 15-submodules/03_private_implementation.f90
! -----------------------------------------------------------------------------
!
! What can live in a submodule:
!   * implementations of module procedures (separate module procedures);
!   * variables, constants, types, interfaces and ordinary procedures that
!     are PRIVATE to the submodule and its descendants;
!   * USE statements of other modules needed only by the implementation -
!     so users of the parent module no longer depend on them.
!
! What cannot: PUBLIC entities. Everything a user needs (types, constants,
! interfaces) must be in the parent module.
!
! Submodules can also break a circular dependency between two modules: both
! modules declare interfaces, and each one's submodule USEs the other module.

module text_stats
  implicit none (type, external)
  private
  public :: word_report

  type, public :: report
    integer :: words = 0, letters = 0
  end type report

  interface
    module function word_report(text) result(r)
      character(len=*), intent(in) :: text
      type(report) :: r
    end function word_report
  end interface

end module text_stats

submodule (text_stats) text_stats_impl
  use, intrinsic :: iso_fortran_env, only: int8    ! dependency hidden from users
  implicit none (type, external)

  character(len=*), parameter :: separators = ' ,.;:!?'

contains

  module procedure word_report
    integer :: i
    logical :: in_word

    in_word = .false.
    do i = 1, len(text)
      if (index(separators, text(i:i)) > 0) then
        in_word = .false.
      else
        if (.not. in_word) r%words = r%words + 1
        in_word = .true.
        if (is_letter(text(i:i))) r%letters = r%letters + 1
      end if
    end do
  end procedure word_report

  pure logical function is_letter(c)       ! private helper
    character, intent(in) :: c
    integer(int8) :: code
    code = int(iachar(c), int8)
    is_letter = (code >= iachar('a') .and. code <= iachar('z')) .or. &
                (code >= iachar('A') .and. code <= iachar('Z'))
  end function is_letter

end submodule text_stats_impl

program private_implementation
  use text_stats, only: word_report, report
  implicit none (type, external)

  type(report) :: r

  r = word_report('Submodules hide the details, users see the interface.')
  print '(a, i0, a, i0)', 'words: ', r%words, ', letters: ', r%letters

end program private_implementation

! Output:
! words: 8, letters: 44
