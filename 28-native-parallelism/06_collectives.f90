! @flags -fcoarray=single
! -----------------------------------------------------------------------------
! 06_collectives.f90 - collective subroutines (F2018)
!
! Run:  scripts/run.sh 28-native-parallelism/06_collectives.f90
!       caf 06_collectives.f90 && cafrun -n 4 ./a.out
! -----------------------------------------------------------------------------
!
!   call co_sum(a [, result_image] [, stat] [, errmsg])
!   call co_max(a ...)   call co_min(a ...)
!   call co_reduce(a, operation [, result_image] ...)   pure user operation
!   call co_broadcast(a, source_image [, stat] [, errmsg])
!
! Collectives are called by ALL images (of the current team). The argument
! does NOT need to be a coarray. On return, a holds the combined value on
! every image, or only on result_image if that is given (others: undefined).
! They are usually far faster than hand-written loops over x[i].

module ops
  implicit none (type, external)
contains
  pure integer function gcd(a, b)
    integer, intent(in) :: a, b
    integer :: x, y, t
    x = abs(a); y = abs(b)
    do while (y /= 0)
      t = mod(x, y); x = y; y = t
    end do
    gcd = x
  end function gcd
end module ops

program collectives
  use ops, only: gcd
  implicit none (type, external)

  integer :: me, s, hi, lo, g, config(3)
  real :: v(2)

  me = this_image()

  s = me;         call co_sum(s)
  hi = me * me;   call co_max(hi)
  lo = 100 - me;  call co_min(lo)
  g = 12 * me;    call co_reduce(g, gcd)
  v = [real(me), 1.0]
  call co_sum(v, result_image=1)          ! arrays work element-wise

  if (me == 1) then
    config = [7, 8, 9]                    ! only image 1 knows the config...
  else
    config = 0
  end if
  call co_broadcast(config, source_image=1)   ! ...now everyone does

  print '(a, i0, a, i0, a, i0, a, i0, a, i0, a, *(1x, i0))', 'image ', me, ': sum=', s, &
      ' max=', hi, ' min=', lo, ' gcd=', g, ' config:', config
  if (me == 1) print '(a, *(1x, f0.1))', 'co_sum of vectors on image 1:', v

end program collectives

! Output:
! image 1: sum=1 max=1 min=99 gcd=12 config: 7 8 9
! co_sum of vectors on image 1: 1.0 1.0
