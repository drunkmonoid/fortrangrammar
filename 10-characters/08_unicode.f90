! -----------------------------------------------------------------------------
! 08_unicode.f90 - ISO 10646 (UCS-4) characters and UTF-8 output
!
! Run:  scripts/run.sh 10-characters/08_unicode.f90
! -----------------------------------------------------------------------------
!
! * selected_char_kind('ISO_10646') gives a kind that holds any Unicode code
!   point (UCS-4: 4 bytes per character); negative if unsupported.
! * A literal of that kind is written with a kind PREFIX: ucs4_'text'.
!   Source files are read as bytes, so non-ASCII letters typed directly in a
!   literal are not portable - build them with char(code, kind=ucs4).
! * To write such strings as UTF-8, open the unit with encoding='UTF-8'
!   (an output_unit can be re-opened that way).
! * Assignment between default/ASCII and ISO_10646 kinds converts
!   automatically (F2003).
! * len() counts characters, not bytes.

program unicode
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer, parameter :: ucs4 = selected_char_kind('ISO_10646')
  character(kind=ucs4, len=:), allocatable :: greeting, wide
  character(len=:), allocatable :: narrow
  integer :: i

  open (output_unit, encoding='UTF-8')

  ! Build "Grüße, 世界" from code points.
  greeting = ucs4_'Gr' // char(int(z'FC'), ucs4) // char(int(z'DF'), ucs4) // ucs4_'e, ' &
             // char(int(z'4E16'), ucs4) // char(int(z'754C'), ucs4)
  write (output_unit, '(a)') greeting
  write (output_unit, '(a, i0)') 'characters: ', len(greeting)
  write (output_unit, '(a, *(1x, z0))') 'code points:', (ichar(greeting(i:i)), i = 1, len(greeting))

  ! Conversion between kinds on assignment.
  narrow = 'plain ASCII'
  wide = narrow
  write (output_unit, '(a, a, i0)') wide, '  kind=', kind(wide)

  ! Box-drawing characters.
  write (output_unit, '(a)') repeat(char(int(z'2500'), ucs4), 20)

end program unicode

! Output:
! Grüße, 世界
! characters: 9
! code points: 47 72 FC DF 65 2C 20 4E16 754C
! plain ASCII  kind=4
! ────────────────────
