! -----------------------------------------------------------------------------
! 05_character.f90 - the CHARACTER type (basics; chapter 10 goes deeper)
!
! Run:  scripts/run.sh 03-intrinsic-types/05_character.f90
! -----------------------------------------------------------------------------
!
! CHARACTER has two type parameters:
!   len   number of characters        character(len=10)  or  character(10)
!   kind  character set               character(kind=ucs4, len=10)
!
! Assignment pads with blanks or truncates to the declared length.
! `len=:` + allocatable gives a string whose length follows the value.
! `len=*` is used for dummy arguments and named constants (length taken
! from the actual argument / the constant's value).
!
! Character kinds: selected_char_kind('DEFAULT'), ('ASCII'), ('ISO_10646').
! A literal gets a non-default kind with a PREFIX: ucs4_'text' (the kind
! goes before the literal, unlike numeric suffixes).

program character_type
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer, parameter :: ascii = selected_char_kind('ASCII')
  integer, parameter :: ucs4 = selected_char_kind('ISO_10646')

  character(len=5) :: fixed
  character(10) :: padded
  character :: one_char                       ! len defaults to 1
  character(len=*), parameter :: greeting = 'hello, world'
  character(len=:), allocatable :: flexible
  character(kind=ascii, len=3) :: ascii_text
  character(kind=ucs4, len=:), allocatable :: unicode

  fixed = 'truncated!'          ! too long: keeps 'trunc'
  padded = 'pad'                ! too short: 'pad' + 7 blanks
  one_char = 'xyz'              ! keeps 'x'
  flexible = 'grows to fit'
  ascii_text = ascii_'abc'

  print '(3a)', '[', fixed, ']'
  print '(3a)', '[', padded, ']'
  print '(3a)', '[', one_char, ']'
  print '(3a)', '[', flexible, ']'
  print '(a, i0)', 'len(greeting) = ', len(greeting)
  print '(a, i0, a, i0)', 'len(flexible) = ', len(flexible), &
      ', after reassign: ', len(reassign(flexible))
  print '(a, 2(1x, i0))', 'kinds ascii, ucs4:', ascii, ucs4
  print '(2a)', 'ascii text: ', ascii_text

  ! Unicode: build the value from code points with char(..., kind=ucs4).
  ! Writing it needs the unit opened with encoding='UTF-8' (chapter 23).
  unicode = ucs4_'caf' // char(int(z'E9'), kind=ucs4) // ucs4_' ' // char(int(z'2615'), kind=ucs4)
  open (output_unit, encoding='UTF-8')
  write (output_unit, '(a, a, i0)') unicode, '  len=', len(unicode)

contains

  function reassign(s) result(r)
    character(len=:), allocatable, intent(inout) :: s
    character(len=:), allocatable :: r

    s = 'short'                 ! the allocation follows the new length
    r = s
  end function reassign

end program character_type

! Output:
! [trunc]
! [pad       ]
! [x]
! [grows to fit]
! len(greeting) = 12
! len(flexible) = 12, after reassign: 5
! kinds ascii, ucs4: 1 4
! ascii text: abc
! café ☕  len=6
