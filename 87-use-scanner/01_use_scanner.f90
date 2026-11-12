! -----------------------------------------------------------------------------
! 01_use_scanner.f90 - Scan Fortran source lines for non-intrinsic USE modules
!
! Run:  scripts/run.sh 87-use-scanner/01_use_scanner.f90
! -----------------------------------------------------------------------------
!
! Scans an embedded Fortran source sample line by line:
!   - Ignores blank lines and comment lines starting with '!'
!   - Matches statements beginning with `use` (case-insensitive)
!   - Skips `use, intrinsic` statements
!   - Extracts and prints the target module name (handling optional `::` and `, only:`)

module use_scanner_m
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)
  private
  public :: scan_uses

contains

  pure function to_lower(str) result(res)
    character(len=*), intent(in) :: str
    character(len=len(str)) :: res
    integer :: i, c

    res = str
    do i = 1, len(str)
      c = iachar(str(i:i))
      if (c >= iachar('A') .and. c <= iachar('Z')) then
        res(i:i) = achar(c + 32)
      end if
    end do
  end function to_lower

  subroutine scan_uses(source)
    character(len=*), intent(in) :: source
    integer :: pos, n, nl_pos
    character(len=:), allocatable :: line, mod_name

    n = len(source)
    pos = 1
    do while (pos <= n)
      nl_pos = index(source(pos:n), new_line('a'))
      if (nl_pos == 0) then
        line = source(pos:n)
        pos = n + 1
      else
        line = source(pos:pos + nl_pos - 2)
        pos = pos + nl_pos
      end if

      call parse_line(line, mod_name)
      if (len(mod_name) > 0) then
        write(output_unit, '(a)') mod_name
      end if
    end do
  end subroutine scan_uses

  subroutine parse_line(raw_line, mod_name)
    character(len=*), intent(in) :: raw_line
    character(len=:), allocatable, intent(out) :: mod_name
    character(len=:), allocatable :: s, low, rest
    integer :: i, n, end_idx

    mod_name = ''
    s = trim(adjustl(raw_line))
    if (len(s) == 0) return
    if (s(1:1) == '!') return

    low = to_lower(s)
    if (len(low) < 4) return
    if (low(1:3) /= 'use') return

    ! Must be followed by whitespace or comma to be a USE statement
    if (low(4:4) /= ' ' .and. low(4:4) /= achar(9) .and. low(4:4) /= ',') return

    rest = adjustl(s(4:))
    low = to_lower(rest)

    ! Check for `use, intrinsic` or `use , non_intrinsic`
    if (len(rest) > 0 .and. rest(1:1) == ',') then
      rest = adjustl(rest(2:))
      low = to_lower(rest)
      if (index(low, 'intrinsic') == 1) return
      if (index(low, 'non_intrinsic') == 1) then
        rest = adjustl(rest(14:))
      end if
    end if

    ! Skip optional `::`
    if (len(rest) >= 2) then
      if (rest(1:2) == '::') then
        rest = adjustl(rest(3:))
      end if
    end if

    ! Extract module identifier
    n = len_trim(rest)
    if (n == 0) return
    end_idx = n
    do i = 1, n
      if (rest(i:i) == ' ' .or. rest(i:i) == ',' .or. &
          rest(i:i) == '!' .or. rest(i:i) == achar(9)) then
        end_idx = i - 1
        exit
      end if
    end do

    if (end_idx >= 1) then
      mod_name = rest(1:end_idx)
    end if
  end subroutine parse_line

end module use_scanner_m

program use_scanner_demo
  use use_scanner_m, only: scan_uses
  implicit none (type, external)

  character(len=:), allocatable :: sample

  sample = &
    '! use commented_out_module' // new_line('a') // &
    'program sample_prog' // new_line('a') // &
    '  use, intrinsic :: iso_fortran_env, only: output_unit' // new_line('a') // &
    '  use foo, only: bar' // new_line('a') // &
    '  implicit none' // new_line('a') // &
    'end program sample_prog'

  call scan_uses(sample)

end program use_scanner_demo

! Output:
! foo
