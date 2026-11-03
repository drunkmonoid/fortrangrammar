! -----------------------------------------------------------------------------
! 02_substrings.f90 - selecting parts of a string
!
! Run:  scripts/run.sh 10-characters/02_substrings.f90
! -----------------------------------------------------------------------------
!
!   s(i:j)     characters i..j (positions start at 1)
!   s(i:)      from i to the end          s(:j)   from the start to j
!   s(i:i)     a single character - there is no s(i) for scalars
!   s(i:j) with j < i                     a ZERO-LENGTH string (not an error)
!   a(k)(i:j)  substring of an array element
!   a(:)(i:j)  the same substring of every element (an array section)
!   'literal'(i:j)  substrings of constants are allowed too
!
! Out-of-range positions (i < 1 or j > len) are errors; -fcheck=all
! (bounds) catches them. A substring of a variable is itself a variable:
! you can assign to it, but the lengths must match (padding/truncation
! applies as in any assignment).

program substrings
  implicit none (type, external)

  character(len=:), allocatable :: s
  character(len=5) :: words(3) = ['alpha', 'bravo', 'delta']
  character(len=10) :: buffer
  integer :: i

  s = 'Hello, world'

  print '(3a)', 's(1:5)    = [', s(1:5), ']'
  print '(3a)', 's(8:)     = [', s(8:), ']'
  print '(3a)', 's(:4)     = [', s(:4), ']'
  print '(3a)', 's(5:5)    = [', s(5:5), ']'
  print '(a, i0)', 'len(s(5:4)) = ', len(s(5:4))

  print '(3a)', 'words(2)(1:3)  = [', words(2)(1:3), ']'
  print '(a, 3(1x, a))', 'words(:)(1:1)  =', words(:)(1:1)
  print '(3a)', "'abcdef'(3:4)  = [", 'abcdef'(3:4), ']'

  ! Assign to a substring.
  buffer = 'xxxxxxxxxx'
  buffer(3:5) = 'ABC'
  buffer(9:) = 'yz'
  print '(3a)', 'buffer         = [', buffer, ']'

  ! Character-by-character loop: reverse a string.
  s = 'stressed'
  block
    character(len=len(s)) :: reversed
    do i = 1, len(s)
      reversed(i:i) = s(len(s) - i + 1:len(s) - i + 1)
    end do
    print '(4a)', s, ' reversed is ', reversed
  end block

end program substrings

! Output:
! s(1:5)    = [Hello]
! s(8:)     = [world]
! s(:4)     = [Hell]
! s(5:5)    = [o]
! len(s(5:4)) = 0
! words(2)(1:3)  = [bra]
! words(:)(1:1)  = a b d
! 'abcdef'(3:4)  = [cd]
! buffer         = [xxABCxxxyz]
! stressed reversed is desserts
