! -----------------------------------------------------------------------------
! 01_fixed_and_deferred_length.f90 - the three ways to give a length
!
! Run:  scripts/run.sh 10-characters/01_fixed_and_deferred_length.f90
! -----------------------------------------------------------------------------
!
!   character(len=10) :: s               fixed: always exactly 10 characters
!   character(len=*)  :: arg             assumed: dummy arguments and
!                                         named constants take the length of
!                                         the actual argument / value
!   character(len=:), allocatable :: d   deferred: the length follows each
!                                         assignment (F2003)
!
! * Fixed-length strings are blank-padded; use trim() to drop the padding.
! * len(s) is the declared/current length, len_trim(s) ignores trailing
!   blanks.
! * An ARRAY of strings has one length for all elements, even when
!   deferred: character(len=:), allocatable :: list(:). For ragged lists
!   wrap the string in a derived type (the `string` type below).

program fixed_and_deferred_length
  implicit none (type, external)

  type :: string
    character(len=:), allocatable :: s
  end type string

  character(len=10) :: fixed
  character(len=*), parameter :: constant = 'implied length'
  character(len=:), allocatable :: deferred
  character(len=:), allocatable :: list(:)
  type(string) :: ragged(3)
  integer :: i

  fixed = 'hi'
  print '(3a, i0, a, i0)', '[', fixed, '] len=', len(fixed), ' len_trim=', len_trim(fixed)
  print '(3a)', '[', trim(fixed), ']'

  print '(a, i0)', 'len(constant) = ', len(constant)

  deferred = 'grow'
  print '(3a, i0)', '[', deferred, '] len=', len(deferred)
  deferred = deferred // 'ing and growing'
  print '(3a, i0)', '[', deferred, '] len=', len(deferred)

  ! Explicit allocation of a deferred length.
  deallocate (deferred)
  allocate (character(len=5) :: deferred)
  deferred = 'abcdefgh'          ! realloc on assignment: becomes len 8
  print '(3a, i0)', '[', deferred, '] len=', len(deferred)

  ! An array of deferred-length strings: one common length.
  list = [character(len=6) :: 'one', 'three', 'eleven']
  print '(a, i0, a, i0)', 'list: size ', size(list), ', common len ', len(list)

  ! Ragged strings through a derived type.
  ragged(1)%s = 'a'
  ragged(2)%s = 'medium'
  ragged(3)%s = 'much longer string'
  do i = 1, size(ragged)
    print '(a, i0, 3a, i0)', 'ragged(', i, ') = "', ragged(i)%s, '" len=', len(ragged(i)%s)
  end do

  print '(a)', describe('passed to len=* dummy')

contains

  function describe(text) result(r)
    character(len=*), intent(in) :: text     ! assumed length
    character(len=:), allocatable :: r       ! deferred-length result
    character(len=12) :: buffer

    write (buffer, '(i0)') len(text)
    r = '"' // text // '" has ' // trim(buffer) // ' characters'
  end function describe

end program fixed_and_deferred_length

! Output:
! [hi        ] len=10 len_trim=2
! [hi]
! len(constant) = 14
! [grow] len=4
! [growing and growing] len=19
! [abcdefgh] len=8
! list: size 3, common len 6
! ragged(1) = "a" len=1
! ragged(2) = "medium" len=6
! ragged(3) = "much longer string" len=18
! "passed to len=* dummy" has 21 characters
