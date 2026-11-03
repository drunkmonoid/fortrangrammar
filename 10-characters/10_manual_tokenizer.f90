! -----------------------------------------------------------------------------
! 10_manual_tokenizer.f90 - splitting a string without F2023 intrinsics
!
! Run:  scripts/run.sh 10-characters/10_manual_tokenizer.f90
! -----------------------------------------------------------------------------
!
! Until compilers ship F2023 split/tokenize, a tokenizer is a short loop
! over scan(). Tokens of different lengths are stored in a derived type with
! a deferred-length component.

module tokenizer
  implicit none (type, external)
  private
  public :: token, split_on

  type :: token
    character(len=:), allocatable :: text
  end type token

contains

  function split_on(line, delimiters) result(tokens)
    character(len=*), intent(in) :: line, delimiters
    type(token), allocatable :: tokens(:)
    integer :: start, offset

    allocate (tokens(0))
    start = 1
    do
      offset = scan(line(start:), delimiters)
      if (offset == 0) then
        tokens = [tokens, token(line(start:))]
        exit
      end if
      tokens = [tokens, token(line(start:start + offset - 2))]
      start = start + offset
    end do
  end function split_on

end module tokenizer

program manual_tokenizer
  use tokenizer, only: token, split_on
  implicit none (type, external)

  type(token), allocatable :: parts(:)
  integer :: i

  parts = split_on('alpha,beta;;gamma delta', ',; ')
  do i = 1, size(parts)
    print '(a, i0, 3a)', 'token ', i, ': [', parts(i)%text, ']'
  end do

end program manual_tokenizer

! Output:
! token 1: [alpha]
! token 2: [beta]
! token 3: []
! token 4: [gamma]
! token 5: [delta]
