! main.f90 - strings across the C boundary.
!
! C strings are NUL-terminated arrays of char; Fortran strings carry their
! length. Conversions:
!   Fortran -> C   append c_null_char:  trim(s) // c_null_char
!                  or F2023 f_c_string(s [, asis])  (trims unless asis)
!   C -> Fortran   char array: find the NUL with index(), take the prefix
!                  type(c_ptr): c_f_pointer to a character array, or
!                  F2023 c_f_strpointer (not yet in gfortran 15)
! A character(len=*) dummy is not interoperable; use character(kind=c_char)
! arrays, len=1 scalars passed as arrays, or a CFI descriptor.
program strings
  use, intrinsic :: iso_c_binding, only: c_char, c_int, c_ptr, c_null_char, &
                                         c_f_pointer, f_c_string
  implicit none (type, external)

  interface
    integer(c_int) function count_vowels(s) bind(c, name='count_vowels')
      import :: c_char, c_int
      character(kind=c_char), intent(in) :: s(*)
    end function count_vowels

    subroutine to_upper(src, dst, cap) bind(c, name='to_upper')
      import :: c_char, c_int
      character(kind=c_char), intent(in) :: src(*)
      character(kind=c_char), intent(out) :: dst(*)
      integer(c_int), value :: cap
    end subroutine to_upper

    type(c_ptr) function greeting() bind(c, name='greeting')
      import :: c_ptr
    end function greeting
  end interface

  character(kind=c_char, len=32) :: buffer
  character(kind=c_char), pointer :: chars(:)
  integer :: n

  ! Fortran -> C: a scalar character actual may be passed to a char(*) dummy.
  print '(a, i0)', 'vowels in "interoperability": ', count_vowels('interoperability' // c_null_char)
  print '(a, i0)', 'with f_c_string (F2023)      : ', count_vowels(f_c_string('Fortran and C  '))

  ! C writes into a Fortran buffer; cut at the NUL.
  call to_upper('mixed Case' // c_null_char, buffer, len(buffer, kind=c_int))
  n = index(buffer, c_null_char) - 1
  print '(3a)', 'to_upper: [', buffer(1:n), ']'

  ! C returns a char*: map it onto a Fortran array of chars, then copy.
  call c_f_pointer(greeting(), chars, [64])
  n = findloc(chars, c_null_char, dim=1) - 1
  block
    character(len=n) :: text
    integer :: i
    do i = 1, n
      text(i:i) = chars(i)
    end do
    print '(3a)', 'greeting: [', text, ']'
  end block
end program strings
