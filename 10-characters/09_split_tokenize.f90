! @build skip F2023 split/tokenize are not implemented in gfortran 15
! -----------------------------------------------------------------------------
! 09_split_tokenize.f90 - F2023 SPLIT and TOKENIZE
!
! Run:  needs a compiler with the F2023 string intrinsics
! -----------------------------------------------------------------------------
!
!   call tokenize(string, set, tokens [, separator])
!       tokens: deferred-length allocatable character array receiving every
!       token between characters of SET. separator (optional, same kind of
!       array) receives the delimiter that ended each token.
!
!   call tokenize(string, set, first, last)
!       first, last: allocatable integer arrays of token start/end positions
!       (no copying of text).
!
!   call split(string, set, pos [, back])
!       Incremental scanning: on entry pos is the previous delimiter
!       position (start with 0); on return it is the position of the next
!       delimiter, or len(string) + 1 if there is none. Tokens are
!       string(old_pos + 1 : pos - 1).
!
! Empty tokens between adjacent delimiters are kept.

program split_tokenize
  implicit none (type, external)

  character(len=*), parameter :: line = 'alpha,beta;;gamma delta'
  character(len=:), allocatable :: tokens(:)
  character(len=:), allocatable :: separators(:)
  integer, allocatable :: first(:), last(:)
  integer :: i, pos, previous

  call tokenize(line, ',; ', tokens, separators)
  do i = 1, size(tokens)
    print '(a, i0, 3a)', 'token ', i, ': [', trim(tokens(i)), ']'
  end do

  call tokenize(line, ',; ', first, last)
  print '(a, *(1x, i0))', 'first:', first
  print '(a, *(1x, i0))', 'last :', last

  pos = 0
  do
    previous = pos
    call split(line, ',; ', pos)
    print '(3a)', 'split: [', line(previous + 1:pos - 1), ']'
    if (pos > len(line)) exit
  end do

end program split_tokenize
