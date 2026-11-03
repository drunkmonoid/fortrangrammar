! -----------------------------------------------------------------------------
! 07_character_set.f90 - the Fortran character set and character literals
!
! Run:  scripts/run.sh 02-lexical-elements/07_character_set.f90
! -----------------------------------------------------------------------------
!
! Source text (outside comments and character literals) uses only:
!
!   letters      A-Z a-z
!   digits       0-9
!   underscore   _
!   special      blank = + - * / \ ( ) [ ] { } , . : ; ! " % & ~ < > ? ' ` ^ | $ # @
!
! Not every special character has a meaning in the language: { } ` ^ | # @ ~ $
! are in the set (F2018+) but unused by the syntax ($ and @ may appear in
! literals and comments).
!
! Character literals ("strings") are delimited by ' or ". To put the
! delimiter itself inside, double it. The other quote needs no escaping.
! There are no backslash escapes in standard Fortran: '\n' is two
! characters. Use new_line('a') or achar(10) for a newline.

program character_set
  implicit none (type, external)

  print '(a)', 'single quotes'
  print '(a)', "double quotes"
  print '(a)', 'it''s doubled inside single quotes'
  print '(a)', "say ""hi"" inside double quotes"
  print '(a)', "it's fine to mix: no doubling needed"
  print '(a)', 'backslash is literal: \n \t'
  print '(a)', 'first line' // new_line('a') // 'second line'
  print '(a, i0)', 'length of empty literal: ', len('')

  ! Any character the processor supports may appear inside a literal.
  print '(a)', 'special chars: { } ` ^ | # @ ~ $ ? \'

end program character_set

! Output:
! single quotes
! double quotes
! it's doubled inside single quotes
! say "hi" inside double quotes
! it's fine to mix: no doubling needed
! backslash is literal: \n \t
! first line
! second line
! length of empty literal: 0
! special chars: { } ` ^ | # @ ~ $ ? \
