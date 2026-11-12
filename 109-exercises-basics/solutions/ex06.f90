! Exercise 06: named outer do loop with exit and inner select case classification.

program ex06_control_flow
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)

  integer, parameter :: stream(6) = [1, 2, 0, -1, 2, 1]
  integer :: i, pos_cnt, zero_cnt

  pos_cnt = 0
  zero_cnt = 0

  outer: do i = 1, size(stream)
    select case (stream(i))
    case (:-1)
      exit outer
    case (0)
      zero_cnt = zero_cnt + 1
    case (1:)
      pos_cnt = pos_cnt + 1
    end select
  end do outer

  write(output_unit, '(a,1x,i0,1x,i0)') 'pos zero:', pos_cnt, zero_cnt

end program ex06_control_flow

! Output:
! pos zero: 2 1
