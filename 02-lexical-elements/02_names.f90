! -----------------------------------------------------------------------------
! 02_names.f90 - rules for names, and the fact that keywords are not reserved
!
! Run:  scripts/run.sh 02-lexical-elements/02_names.f90
! -----------------------------------------------------------------------------
!
! A name:
!   * starts with a letter (A-Z, a-z),
!   * continues with letters, digits (0-9) and underscores,
!   * has at most 63 characters,
!   * is case-insensitive.
!
! Illegal:  2fast   _private   my-var   café   (non-ASCII letters)
!
! Fortran has NO reserved words. Keywords are recognised by context, so a
! variable may be called `if`, `end` or `real`. That is legal but confusing;
! the second half of this file shows it only so you recognise it when you see
! it in old code. Do not write code like that.

program names
  implicit none (type, external)

  ! Good, descriptive names.
  integer :: particle_count
  real :: x1, x_2, velocity_magnitude
  ! Exactly 63 characters - the maximum length:
  integer :: a_name_that_is_exactly_sixty_three_characters_long_xxxxxxxxxxxx

  ! Keywords as variable names - LEGAL, but never do this.
  integer :: if, then, else, end, do, real
  real :: integer

  particle_count = 3
  x1 = 1.0; x_2 = 2.0
  velocity_magnitude = sqrt(x1**2 + x_2**2)
  a_name_that_is_exactly_sixty_three_characters_long_xxxxxxxxxxxx = 63

  print '(a, i0)', 'particles: ', particle_count
  print '(a, f0.4)', '|v| = ', velocity_magnitude
  print '(a, i0)', 'long name holds ', &
      a_name_that_is_exactly_sixty_three_characters_long_xxxxxxxxxxxx

  ! The compiler parses each statement by its shape, not by spotting words.
  if = 1; then = 2; else = 3; end = 4; do = 5; real = 6
  integer = 7.5
  if (if < then) print '(a, i0)', 'if + else = ', if + else
  do do = 1, 2
    print '(a, i0)', 'do = ', do
  end do
  print '(a, f0.1)', 'integer = ', integer

end program names

! Output:
! particles: 3
! |v| = 2.2361
! long name holds 63
! if + else = 4
! do = 1
! do = 2
! integer = 7.5
