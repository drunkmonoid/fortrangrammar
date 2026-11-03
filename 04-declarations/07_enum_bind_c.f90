! -----------------------------------------------------------------------------
! 07_enum_bind_c.f90 - interoperable enumerations: ENUM, BIND(C)
!
! Run:  scripts/run.sh 04-declarations/07_enum_bind_c.f90
! -----------------------------------------------------------------------------
!
!   enum, bind(c)
!     enumerator :: red = 1, green, blue   ! 1, 2, 3
!     enumerator :: alpha = 10             ! more lines allowed
!   end enum
!
! This F2003 form creates INTEGER named constants with the kind a C
! compiler would use for an enum, so values match a C `enum`. Rules:
!   * without a value, an enumerator is previous + 1 (first one is 0);
!   * there is no new type: enumerators are plain integers and can be mixed
!     freely with any integer (no type safety);
!   * the kind of the constants is available as kind(red).
!
! For a real, type-safe enumeration use F2023 `enumeration type`, see
! 08_enumeration_type.f90.

program enum_bind_c
  implicit none (type, external)

  enum, bind(c)
    enumerator :: red = 1, green, blue
    enumerator :: alpha = 10, beta
    enumerator :: first_default
  end enum

  ! An unnamed enum starting at zero.
  enum, bind(c)
    enumerator :: mon, tue, wed
  end enum

  integer(kind(red)) :: colour

  colour = green
  print '(a, *(1x, i0))', 'red green blue:', red, green, blue
  print '(a, *(1x, i0))', 'alpha beta next:', alpha, beta, first_default
  print '(a, *(1x, i0))', 'mon tue wed:', mon, tue, wed
  print '(a, i0)', 'kind of enumerators: ', kind(red)

  select case (colour)
  case (red)
    print '(a)', 'colour is red'
  case (green)
    print '(a)', 'colour is green'
  case default
    print '(a)', 'some other colour'
  end select

  ! No type safety: this compiles, although it makes no sense.
  colour = wed + alpha
  print '(a, i0)', 'nonsense but legal: ', colour

end program enum_bind_c

! Output:
! red green blue: 1 2 3
! alpha beta next: 10 11 12
! mon tue wed: 0 1 2
! kind of enumerators: 4
! colour is green
! nonsense but legal: 12
