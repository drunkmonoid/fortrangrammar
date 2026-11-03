! -----------------------------------------------------------------------------
! 09_allocatable_dummies_results.f90 - allocatable arguments and results
!
! Run:  scripts/run.sh 08-arrays-dynamic/09_allocatable_dummies_results.f90
! -----------------------------------------------------------------------------
!
! ALLOCATABLE DUMMY ARGUMENTS (F2003) let a procedure allocate, resize or
! deallocate the caller's array. The actual argument must also be
! allocatable, with the same rank.
!   * intent(out): the actual argument is DEALLOCATED on entry. Use it for
!     "produce a new array" procedures.
!   * intent(inout): the procedure sees the current allocation status and
!     may keep, change or free it.
!   * intent(in): may be inspected (allocated(), size()) but not changed.
!
! ALLOCATABLE FUNCTION RESULTS: the function allocates the result and the
! caller's temporary is freed automatically. The natural way to return
! arrays whose size is only known inside the function.

module alloc_args
  implicit none (type, external)
contains

  subroutine read_values(values)
    integer, allocatable, intent(out) :: values(:)   ! deallocated on entry
    integer :: i

    allocate (values(4))
    values = [(i * 100, i = 1, 4)]
  end subroutine read_values

  subroutine append(values, x)
    integer, allocatable, intent(inout) :: values(:)
    integer, intent(in) :: x

    if (allocated(values)) then
      values = [values, x]
    else
      values = [x]
    end if
  end subroutine append

  function primes_below(n) result(p)
    integer, intent(in) :: n
    integer, allocatable :: p(:)
    logical :: is_prime(n)
    integer :: i

    is_prime = .true.
    if (n >= 1) is_prime(1) = .false.
    do i = 2, int(sqrt(real(n)))
      if (is_prime(i)) is_prime(i * i::i) = .false.
    end do
    p = pack([(i, i = 1, n)], is_prime)              ! size known only now
  end function primes_below

end module alloc_args

program allocatable_dummies_results
  use alloc_args, only: read_values, append, primes_below
  implicit none (type, external)

  integer, allocatable :: v(:)

  v = [1, 2, 3, 4, 5, 6, 7, 8]
  call read_values(v)                 ! old contents discarded (intent(out))
  print '(a, *(1x, i0))', 'read_values:', v

  call append(v, 999)
  print '(a, *(1x, i0))', 'appended   :', v

  deallocate (v)
  call append(v, 1)                   ! works on an unallocated array too
  print '(a, *(1x, i0))', 'from empty :', v

  print '(a, *(1x, i0))', 'primes < 30:', primes_below(30)

end program allocatable_dummies_results

! Output:
! read_values: 100 200 300 400
! appended   : 100 200 300 400 999
! from empty : 1
! primes < 30: 2 3 5 7 11 13 17 19 23 29
