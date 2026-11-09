! -----------------------------------------------------------------------------
! 01_csv.f90 - read and write a small CSV subset
!
! Run:  scripts/run.sh 50-csv/01_csv.f90
! -----------------------------------------------------------------------------
!
! Quoted fields may contain commas. A quote inside a quoted field is
! written twice. Rows may have different numbers of fields. The driver
! parses three rows, writes the quoted one back out, and parses that line
! again.

module csv_m
  implicit none (type, external)
  private
  public :: field_t, parse_row, write_row

  type :: field_t
    character(len=:), allocatable :: text
  end type field_t

contains

  subroutine parse_row(line, fields, stat)
    character(len=*), intent(in) :: line
    type(field_t), allocatable, intent(out) :: fields(:)
    integer, intent(out) :: stat
    type(field_t) :: found(16)
    character(len=:), allocatable :: text
    integer :: i, n, start

    stat = 0
    n = 0
    i = 1
    do
      if (n == size(found)) then
        stat = 1
        return
      end if
      n = n + 1
      ! .and. does not skip the second operand (chapter 05), so the
      ! length test has to be a separate statement from the substring.
      if (i <= len(line)) then
        if (line(i:i) == '"') then
          call quoted(line, i, text, stat)
          if (stat /= 0) return
        else
          start = i
          do
            if (i > len(line)) exit
            if (line(i:i) == ',') exit
            i = i + 1
          end do
          text = line(start:i - 1)
        end if
      else
        text = ''
      end if
      found(n)%text = text
      if (i <= len(line)) then
        if (line(i:i) == ',') then
          i = i + 1
          cycle
        end if
      end if
      exit
    end do
    allocate (fields(n))
    fields = found(1:n)
  end subroutine parse_row

  subroutine quoted(line, i, text, stat)
    character(len=*), intent(in) :: line
    integer, intent(inout) :: i
    character(len=:), allocatable, intent(out) :: text
    integer, intent(out) :: stat

    stat = 0
    text = ''
    i = i + 1
    do
      if (i > len(line)) then
        stat = 2
        return
      end if
      if (line(i:i) == '"') then
        if (i < len(line)) then
          if (line(i + 1:i + 1) == '"') then
            text = text // '"'
            i = i + 2
            cycle
          end if
        end if
        i = i + 1
        exit
      else
        text = text // line(i:i)
        i = i + 1
      end if
    end do
  end subroutine quoted

  subroutine write_row(fields, line)
    type(field_t), intent(in) :: fields(:)
    character(len=:), allocatable, intent(out) :: line
    integer :: i

    line = ''
    do i = 1, size(fields)
      if (i > 1) line = line // ','
      line = line // quote_if_needed(fields(i)%text)
    end do
  end subroutine write_row

  function quote_if_needed(text) result(out)
    character(len=*), intent(in) :: text
    character(len=:), allocatable :: out
    integer :: i

    if (index(text, ',') == 0 .and. index(text, '"') == 0) then
      out = text
      return
    end if
    out = '"'
    do i = 1, len(text)
      if (text(i:i) == '"') out = out // '"'
      out = out // text(i:i)
    end do
    out = out // '"'
  end function quote_if_needed

end module csv_m

program csv_demo
  use csv_m, only: field_t, parse_row, write_row
  implicit none (type, external)

  type(field_t), allocatable :: fields(:)
  character(len=:), allocatable :: line
  integer :: stat

  call parse_row('a,b,c', fields, stat)
  call show('plain', fields)
  call parse_row('"a,b",c', fields, stat)
  call show('quoted', fields)
  call parse_row('"say ""hi""",x', fields, stat)
  call show('escaped', fields)

  call write_row(fields, line)
  call parse_row(line, fields, stat)
  call show('round trip', fields)

contains

  subroutine show(label, fields)
    character(len=*), intent(in) :: label
    type(field_t), intent(in) :: fields(:)
    character(len=:), allocatable :: text
    integer :: i

    text = ''
    do i = 1, size(fields)
      if (i > 1) text = text // ' | '
      text = text // fields(i)%text
    end do
    print '(a, a)', label // ': ', text
  end subroutine show

end program csv_demo

! Output:
! plain: a | b | c
! quoted: a,b | c
! escaped: say "hi" | x
! round trip: say "hi" | x
