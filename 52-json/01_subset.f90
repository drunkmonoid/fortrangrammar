! -----------------------------------------------------------------------------
! 01_subset.f90 - a JSON subset: objects, arrays, strings, numbers, true, false, null
!
! Run:  scripts/run.sh 52-json/01_subset.f90
! -----------------------------------------------------------------------------
!
! Numbers stay text, so the writer can emit the characters it read.
! Strings understand \" and \\. .and. does not skip its second operand
! (chapter 05), so every bounds test is its own statement.

module json_m
  implicit none (type, external)
  private
  public :: json_t, parse, write_json, json_null

  integer, parameter, public :: json_false = 1, json_true = 2
  integer, parameter, public :: json_number = 3, json_string = 4
  integer, parameter, public :: json_array = 5, json_object = 6
  integer, parameter :: json_null = 0

  ! A deferred-length character array has one length for every element
  ! (chapter 10), so each object key is its own allocatable component.
  type :: key_t
    character(len=:), allocatable :: text
  end type key_t

  type :: json_t
    integer :: kind = json_null
    character(len=:), allocatable :: text
    type(json_t), allocatable :: child(:)
    type(key_t), allocatable :: key(:)
  end type json_t

contains

  subroutine parse(document, value, stat)
    character(len=*), intent(in) :: document
    type(json_t), intent(out) :: value
    integer, intent(out) :: stat
    integer :: i

    stat = 0
    i = 1
    call parse_value(document, i, value, stat)
    if (stat /= 0) return
    call skip(document, i)
    if (i <= len(document)) stat = 1
  end subroutine parse

  recursive subroutine parse_value(document, i, value, stat)
    character(len=*), intent(in) :: document
    integer, intent(inout) :: i
    type(json_t), intent(out) :: value
    integer, intent(out) :: stat
    character(len=1) :: ch

    stat = 0
    call skip(document, i)
    if (i > len(document)) then
      stat = 1
      return
    end if
    ch = document(i:i)
    select case (ch)
    case ('{')
      call parse_object(document, i, value, stat)
    case ('[')
      call parse_array(document, i, value, stat)
    case ('"')
      value%kind = json_string
      call parse_string(document, i, value%text, stat)
    case ('t')
      call expect_word(document, i, 'true', stat)
      value%kind = json_true
    case ('f')
      call expect_word(document, i, 'false', stat)
      value%kind = json_false
    case ('n')
      call expect_word(document, i, 'null', stat)
      value%kind = json_null
    case default
      call parse_number(document, i, value, stat)
    end select
  end subroutine parse_value

  recursive subroutine parse_object(document, i, value, stat)
    character(len=*), intent(in) :: document
    integer, intent(inout) :: i
    type(json_t), intent(out) :: value
    integer, intent(out) :: stat
    type(json_t) :: kids(8)
    type(key_t) :: keys(8)
    character(len=:), allocatable :: key
    integer :: n

    stat = 0
    value%kind = json_object
    n = 0
    i = i + 1
    call skip(document, i)
    if (i <= len(document)) then
      if (document(i:i) == '}') then
        i = i + 1
        allocate (value%child(0), value%key(0))
        return
      end if
    end if
    do
      if (n == size(kids)) then
        stat = 1
        return
      end if
      call parse_string(document, i, key, stat)
      if (stat /= 0) return
      call skip(document, i)
      if (i > len(document)) then
        stat = 1
        return
      end if
      if (document(i:i) /= ':') then
        stat = 1
        return
      end if
      i = i + 1
      n = n + 1
      call parse_value(document, i, kids(n), stat)
      if (stat /= 0) return
      keys(n)%text = key
      call skip(document, i)
      if (i > len(document)) then
        stat = 1
        return
      end if
      if (document(i:i) == ',') then
        i = i + 1
        cycle
      end if
      if (document(i:i) /= '}') then
        stat = 1
        return
      end if
      i = i + 1
      exit
    end do
    allocate (value%child(n), value%key(n))
    do n = 1, size(value%child)
      call copy_json(kids(n), value%child(n))
      value%key(n)%text = keys(n)%text
    end do
  end subroutine parse_object

  recursive subroutine parse_array(document, i, value, stat)
    character(len=*), intent(in) :: document
    integer, intent(inout) :: i
    type(json_t), intent(out) :: value
    integer, intent(out) :: stat
    type(json_t) :: kids(8)
    integer :: n

    stat = 0
    value%kind = json_array
    n = 0
    i = i + 1
    call skip(document, i)
    if (i <= len(document)) then
      if (document(i:i) == ']') then
        i = i + 1
        allocate (value%child(0))
        return
      end if
    end if
    do
      if (n == size(kids)) then
        stat = 1
        return
      end if
      n = n + 1
      call parse_value(document, i, kids(n), stat)
      if (stat /= 0) return
      call skip(document, i)
      if (i > len(document)) then
        stat = 1
        return
      end if
      if (document(i:i) == ',') then
        i = i + 1
        cycle
      end if
      if (document(i:i) /= ']') then
        stat = 1
        return
      end if
      i = i + 1
      exit
    end do
    allocate (value%child(n))
    do n = 1, size(value%child)
      call copy_json(kids(n), value%child(n))
    end do
  end subroutine parse_array

  subroutine parse_string(document, i, text, stat)
    character(len=*), intent(in) :: document
    integer, intent(inout) :: i
    character(len=:), allocatable, intent(out) :: text
    integer, intent(out) :: stat
    character(len=1) :: ch

    stat = 0
    text = ''
    call skip(document, i)
    if (i > len(document)) then
      stat = 1
      return
    end if
    if (document(i:i) /= '"') then
      stat = 1
      return
    end if
    i = i + 1
    do
      if (i > len(document)) then
        stat = 1
        return
      end if
      ch = document(i:i)
      i = i + 1
      if (ch == '"') return
      if (ch == '\') then
        if (i > len(document)) then
          stat = 1
          return
        end if
        ch = document(i:i)
        i = i + 1
        if (ch /= '"' .and. ch /= '\') then
          stat = 1
          return
        end if
      end if
      text = text // ch
    end do
  end subroutine parse_string

  subroutine parse_number(document, i, value, stat)
    character(len=*), intent(in) :: document
    integer, intent(inout) :: i
    type(json_t), intent(out) :: value
    integer, intent(out) :: stat
    integer :: start
    character(len=1) :: ch

    stat = 0
    start = i
    if (document(i:i) == '-') i = i + 1
    if (i > len(document)) then
      stat = 1
      return
    end if
    if (document(i:i) < '0' .or. document(i:i) > '9') then
      stat = 1
      return
    end if
    do
      if (i > len(document)) exit
      ch = document(i:i)
      if (ch >= '0' .and. ch <= '9') then
        i = i + 1
      else if (ch == '.') then
        i = i + 1
      else
        exit
      end if
    end do
    value%kind = json_number
    value%text = document(start:i - 1)
  end subroutine parse_number

  subroutine expect_word(document, i, word, stat)
    character(len=*), intent(in) :: document, word
    integer, intent(inout) :: i
    integer, intent(out) :: stat
    integer :: k

    stat = 0
    do k = 1, len(word)
      if (i > len(document)) then
        stat = 1
        return
      end if
      if (document(i:i) /= word(k:k)) then
        stat = 1
        return
      end if
      i = i + 1
    end do
  end subroutine expect_word

  subroutine skip(document, i)
    character(len=*), intent(in) :: document
    integer, intent(inout) :: i
    do
      if (i > len(document)) return
      select case (document(i:i))
      case (' ', achar(9), achar(10))
        i = i + 1
      case default
        return
      end select
    end do
  end subroutine skip

  ! Whole-array assignment of this type corrupts the integer component
  ! under gfortran 15, so copies are element by element.
  recursive subroutine copy_json(src, dst)
    type(json_t), intent(in) :: src
    type(json_t), intent(out) :: dst
    integer :: k

    dst%kind = src%kind
    if (allocated(src%text)) dst%text = src%text
    if (allocated(src%child)) then
      allocate (dst%child(size(src%child)))
      do k = 1, size(src%child)
        call copy_json(src%child(k), dst%child(k))
      end do
    end if
    if (allocated(src%key)) then
      allocate (dst%key(size(src%key)))
      do k = 1, size(src%key)
        dst%key(k)%text = src%key(k)%text
      end do
    end if
  end subroutine copy_json

  subroutine write_json(value, text)
    type(json_t), intent(in) :: value
    character(len=:), allocatable, intent(out) :: text
    character(len=256) :: buf
    integer :: n

    ! A recursive allocatable concatenation is unreliable in gfortran 15
    ! with -fcheck=all, so the recursion fills a fixed buffer.
    n = 0
    call emit(value, buf, n)
    text = buf(1:n)
  end subroutine write_json

  recursive subroutine emit(value, buf, n)
    type(json_t), intent(in) :: value
    character(len=*), intent(inout) :: buf
    integer, intent(inout) :: n
    character(len=:), allocatable :: quoted
    integer :: k

    select case (value%kind)
    case (json_null)
      call put(buf, n, 'null')
    case (json_false)
      call put(buf, n, 'false')
    case (json_true)
      call put(buf, n, 'true')
    case (json_number)
      call put(buf, n, value%text)
    case (json_string)
      quoted = '"' // escape(value%text) // '"'
      call put(buf, n, quoted)
    case (json_array)
      call put(buf, n, '[')
      do k = 1, size(value%child)
        if (k > 1) call put(buf, n, ',')
        call emit(value%child(k), buf, n)
      end do
      call put(buf, n, ']')
    case (json_object)
      call put(buf, n, '{')
      do k = 1, size(value%child)
        if (k > 1) call put(buf, n, ',')
        quoted = '"' // escape(value%key(k)%text) // '":'
        call put(buf, n, quoted)
        call emit(value%child(k), buf, n)
      end do
      call put(buf, n, '}')
    end select
  end subroutine emit

  subroutine put(buf, n, extra)
    character(len=*), intent(inout) :: buf
    integer, intent(inout) :: n
    character(len=*), intent(in) :: extra
    buf(n + 1:n + len(extra)) = extra
    n = n + len(extra)
  end subroutine put

  function escape(raw) result(text)
    character(len=*), intent(in) :: raw
    character(len=:), allocatable :: text
    integer :: k
    text = ''
    do k = 1, len(raw)
      if (raw(k:k) == '"' .or. raw(k:k) == '\') text = text // '\'
      text = text // raw(k:k)
    end do
  end function escape

end module json_m

program json_demo
  use json_m, only: json_t, parse, write_json, json_null, json_true
  implicit none (type, external)

  character(len=*), parameter :: document = &
    '{"name":"ada","n":2,"ok":true,"tags":["a",null]}'
  type(json_t) :: value, broken
  character(len=:), allocatable :: written
  integer :: stat, name, n, ok, tags

  call parse(document, value, stat)
  if (stat /= 0) error stop 'parse'
  name = index_of(value, 'name')
  n = index_of(value, 'n')
  ok = index_of(value, 'ok')
  tags = index_of(value, 'tags')
  print '(a)', 'name = ' // value%child(name)%text
  print '(a)', 'n = ' // value%child(n)%text
  print '(a, l1)', 'ok: ', value%child(ok)%kind == json_true
  print '(a, l1)', 'second tag null: ', value%child(tags)%child(2)%kind == json_null

  call write_json(value, written)
  print '(a)', 'round trip: ' // written

  call parse('{', broken, stat)
  print '(a, l1)', 'rejects truncated: ', stat /= 0

contains

  integer function index_of(object, key) result(k)
    type(json_t), intent(in) :: object
    character(len=*), intent(in) :: key
    do k = 1, size(object%key)
      if (object%key(k)%text == key) return
    end do
    error stop 'missing key'
  end function index_of

end program json_demo

! Output:
! name = ada
! n = 2
! ok: T
! second tag null: T
! round trip: {"name":"ada","n":2,"ok":true,"tags":["a",null]}
! rejects truncated: T
