! -----------------------------------------------------------------------------
! 05_sequence_and_bind_c.f90 - storage-controlled types: SEQUENCE, BIND(C)
!
! Run:  scripts/run.sh 16-derived-types/05_sequence_and_bind_c.f90
! -----------------------------------------------------------------------------
!
! Normally the compiler may reorder and pad components freely, and two type
! definitions with the same name in different scopes are DIFFERENT types.
!
!   type :: t
!     sequence          components stored in declaration order; two
!     ...               SEQUENCE types with identical definitions (names,
!   end type            components, attributes) are the SAME type even if
!                       defined in different scoping units. Legacy feature
!                       (COMMON / EQUIVALENCE era); rarely needed today.
!
!   type, bind(c) :: t  laid out like the corresponding C struct, for
!     ...               interoperability (chapter 27). Components must be
!   end type            interoperable: no allocatable/pointer components,
!                       no type-bound procedures.
!
! Modern code: plain types in modules; bind(c) for C structs.

module layouts
  use, intrinsic :: iso_c_binding, only: c_int, c_double, c_char
  implicit none (type, external)

  type, bind(c) :: c_point                 ! struct { int id; double x, y; }
    integer(c_int) :: id
    real(c_double) :: x, y
  end type c_point

  type, bind(c) :: c_label                 ! struct { char text[8]; }
    character(kind=c_char) :: text(8)
  end type c_label

end module layouts

program sequence_and_bind_c
  use layouts, only: c_point, c_label
  implicit none (type, external)

  type :: legacy_pair
    sequence
    integer :: a
    real :: b
  end type legacy_pair

  type(c_point) :: p
  type(c_label) :: label
  type(legacy_pair) :: pair

  p = c_point(1, 2.5d0, -1.0d0)
  label%text = ['h', 'e', 'l', 'l', 'o', achar(0), ' ', ' ']
  pair = legacy_pair(3, 4.0)

  print '(a, i0, 2(1x, f0.2))', 'c_point: ', p%id, p%x, p%y
  ! 4-byte int + 4 bytes of padding + two 8-byte doubles = 24 bytes, exactly
  ! what a C compiler does for the same struct.
  print '(a, i0, a)', 'storage_size(c_point) = ', storage_size(p), ' bits'
  print '(a, 5a1)', 'c_label: ', label%text(1:5)
  print '(a, i0, 1x, f0.1)', 'legacy_pair: ', pair%a, pair%b

end program sequence_and_bind_c

! Output:
! c_point: 1 2.50 -1.00
! storage_size(c_point) = 192 bits
! c_label: hello
! legacy_pair: 3 4.0
