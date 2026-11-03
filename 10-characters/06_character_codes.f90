! -----------------------------------------------------------------------------
! 06_character_codes.f90 - char, ichar, achar, iachar, case conversion
!
! Run:  scripts/run.sh 10-characters/06_character_codes.f90
! -----------------------------------------------------------------------------
!
!   iachar(c)     ASCII code of c                  iachar('A') = 65
!   achar(i)      character with ASCII code i      achar(10) = line feed
!   ichar(c)      code in the PROCESSOR's character set
!   char(i [, kind])  character with processor code i (any character kind)
!   new_line(c)   the newline character of c's kind
!
! Prefer the "a" (ASCII) versions for portable code. Fortran has no
! intrinsic to_upper/to_lower; write them with iachar/achar as below.
! Like most character intrinsics they are elemental.

module case_conversion
  implicit none (type, external)
  private
  public :: to_upper, to_lower
contains

  elemental function to_upper(s) result(r)
    character(len=*), intent(in) :: s
    character(len=len(s)) :: r
    integer :: i, code

    do i = 1, len(s)
      code = iachar(s(i:i))
      if (code >= iachar('a') .and. code <= iachar('z')) code = code - 32
      r(i:i) = achar(code)
    end do
  end function to_upper

  elemental function to_lower(s) result(r)
    character(len=*), intent(in) :: s
    character(len=len(s)) :: r
    integer :: i, code

    do i = 1, len(s)
      code = iachar(s(i:i))
      if (code >= iachar('A') .and. code <= iachar('Z')) code = code + 32
      r(i:i) = achar(code)
    end do
  end function to_lower

end module case_conversion

program character_codes
  use case_conversion, only: to_upper, to_lower
  implicit none (type, external)

  integer :: i

  print '(a, i0)', "iachar('A') = ", iachar('A')
  print '(a, a)', 'achar(97)   = ', achar(97)
  print '(a, *(1x, i0))', "iachar of 'Hi!' =", [(iachar('Hi!'(i:i)), i = 1, 3)]
  print '(a, i0)', 'iachar(new_line("a")) = ', iachar(new_line('a'))

  print '(a)', to_upper('Mixed Case 123')
  print '(a)', to_lower('Mixed Case 123')
  print '(a, 2(1x, a))', 'elemental:', to_upper(['ab', 'cd'])

  ! The printable ASCII range.
  print '(a)', 'printable ASCII:'
  print '(*(a))', (achar(i), i = 32, 126)

end program character_codes

! Output:
! iachar('A') = 65
! achar(97)   = a
! iachar of 'Hi!' = 72 105 33
! iachar(new_line("a")) = 10
! MIXED CASE 123
! mixed case 123
! elemental: AB CD
! printable ASCII:
!  !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
