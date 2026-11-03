! -----------------------------------------------------------------------------
! 08_optional_blanks.f90 - keywords where the blank is optional
!
! Run:  scripts/run.sh 02-lexical-elements/08_optional_blanks.f90
! -----------------------------------------------------------------------------
!
! In free form, a blank is required between adjacent keywords, names and
! constants - EXCEPT in these keyword pairs, where it may be omitted:
!
!   block data      double precision   else if        else where
!   end associate   end block          end block data end critical
!   end do          end enum           end file       end forall
!   end function    end if             end interface  end module
!   end procedure   end program        end select     end submodule
!   end subroutine  end team           end type       end where
!   go to           in out             select case    select rank
!   select type
!
! Every other keyword pair (e.g. `error stop`, `sync all`, `change team`,
! `end enumeration` in F2023 compilers) should be written with the blank.
!
! So `enddo`, `endif`, `elseif`, `goto`, `inout`, `selectcase` are all legal.
! Pick one style and stay consistent; this tutorial uses the spaced forms.

program optional_blanks
  implicit none (type, external)

  integer :: i, total

  total = 0
  do i = 1, 3
    total = total + i
  enddo                         ! same as: end do

  if (total > 10) then
    print '(a)', 'big'
  elseif (total > 5) then       ! same as: else if
    print '(a)', 'medium'
  endif                         ! same as: end if

  call bump(total)
  print '(a, i0)', 'total = ', total

  selectcase (total)            ! same as: select case
  case (7)
    print '(a)', 'seven'
  case default
    print '(a)', 'other'
  endselect                     ! same as: end select

contains

  subroutine bump(n)
    integer, intent(inout) :: n  ! same as: intent(in out)

    n = n + 1
  endsubroutine bump             ! same as: end subroutine

endprogram optional_blanks       ! same as: end program

! Output:
! medium
! total = 7
! seven
