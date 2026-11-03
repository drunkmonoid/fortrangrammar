! @build skip F2023 enumeration types are not implemented in gfortran 15
! -----------------------------------------------------------------------------
! 08_enumeration_type.f90 - F2023 type-safe enumeration types
!
! Run:  needs a compiler with F2023 enumeration types
! -----------------------------------------------------------------------------
!
!   enumeration type [, access-spec] :: name
!     enumerator :: a, b, c
!   end enumeration type [name]
!
! Unlike `enum, bind(c)`, this declares a NEW TYPE whose values are its
! enumerators, in declaration order. Values are not integers:
!   * assignment only between values of the same enumeration type;
!   * comparison with ==, /=, <, <=, >, >= (by ordinal);
!   * usable in SELECT CASE (including ranges);
!   * a counted DO loop is not allowed over them; use next/previous;
!   * conversions:
!       int(e)              ordinal (first enumerator is 1)
!       name(i)             the i-th enumerator (structure-constructor style)
!       huge(e)             last enumerator
!       next(e [, stat])    successor     previous(e [, stat])  predecessor
!   * formatted I/O uses the I edit descriptor (writes the ordinal).
!
! Enumerators may not be given explicit values: that is what
! `enum, bind(c)` is for.

program enumeration_type_demo
  implicit none (type, external)

  enumeration type :: weekday
    enumerator :: monday, tuesday, wednesday, thursday, friday
    enumerator :: saturday, sunday
  end enumeration type weekday

  type(weekday) :: day
  integer :: stat

  day = monday
  print '(a, i0)', 'ordinal of monday: ', int(day)

  do
    select case (day)
    case (monday:friday)
      print '(i0, a)', int(day), ' is a working day'
    case (saturday, sunday)
      print '(i0, a)', int(day), ' is weekend'
    end select
    day = next(day, stat=stat)
    if (stat /= 0) exit                ! next(sunday) fails: end of loop
  end do

  print '(a, l1)', 'friday < saturday: ', friday < saturday
  print '(a, i0)', 'last enumerator ordinal: ', int(huge(day))
  day = weekday(3)
  print '(a, l1)', 'weekday(3) == wednesday: ', day == wednesday

  ! day = 3          <- compile error: integer is not type(weekday)

end program enumeration_type_demo
