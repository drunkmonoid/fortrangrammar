! -----------------------------------------------------------------------------
! 01_lexer.f90 - Lexical scanner for arithmetic expressions
!
! Run:  scripts/run.sh 83-lexer/01_lexer.f90
! -----------------------------------------------------------------------------
!
! Scans a character string into tokens:
!   - integer literals (digits 0-9)
!   - identifiers ([a-zA-Z_][a-zA-Z0-9_]*)
!   - operators: + - * /
!   - parentheses: ( )
!   - end of input (EOF)
! Blanks and tabs are skipped. Any unknown character sets stat /= 0 and stops.

module lexer_m
  implicit none (type, external)
  private
  public :: token_t, tokenize, token_kind_name
  public :: TOK_INT, TOK_IDENT, TOK_PLUS, TOK_MINUS, TOK_STAR, TOK_SLASH, &
            TOK_LPAREN, TOK_RPAREN, TOK_EOF

  integer, parameter :: TOK_INT    = 1
  integer, parameter :: TOK_IDENT  = 2
  integer, parameter :: TOK_PLUS   = 3
  integer, parameter :: TOK_MINUS  = 4
  integer, parameter :: TOK_STAR   = 5
  integer, parameter :: TOK_SLASH  = 6
  integer, parameter :: TOK_LPAREN = 7
  integer, parameter :: TOK_RPAREN = 8
  integer, parameter :: TOK_EOF    = 9

  type :: token_t
    integer :: kind = TOK_EOF
    character(len=:), allocatable :: lexeme
    integer :: int_val = 0
  end type token_t

contains

  pure function is_digit(ch) result(res)
    character(len=1), intent(in) :: ch
    logical :: res
    res = (ch >= '0' .and. ch <= '9')
  end function is_digit

  pure function is_alpha(ch) result(res)
    character(len=1), intent(in) :: ch
    logical :: res
    res = ((ch >= 'a' .and. ch <= 'z') .or. &
           (ch >= 'A' .and. ch <= 'Z') .or. ch == '_')
  end function is_alpha

  pure function is_alnum(ch) result(res)
    character(len=1), intent(in) :: ch
    logical :: res
    res = is_alpha(ch) .or. is_digit(ch)
  end function is_alnum

  pure function is_blank(ch) result(res)
    character(len=1), intent(in) :: ch
    logical :: res
    res = (ch == ' ' .or. ch == achar(9))
  end function is_blank

  pure function token_kind_name(kind) result(name)
    integer, intent(in) :: kind
    character(len=:), allocatable :: name
    select case (kind)
    case (TOK_INT);    name = 'INT'
    case (TOK_IDENT);  name = 'IDENT'
    case (TOK_PLUS);   name = 'PLUS'
    case (TOK_MINUS);  name = 'MINUS'
    case (TOK_STAR);   name = 'STAR'
    case (TOK_SLASH);  name = 'SLASH'
    case (TOK_LPAREN); name = 'LPAREN'
    case (TOK_RPAREN); name = 'RPAREN'
    case (TOK_EOF);    name = 'EOF'
    case default;      name = 'UNKNOWN'
    end select
  end function token_kind_name

  subroutine append_token(tokens, count, tok)
    type(token_t), allocatable, intent(inout) :: tokens(:)
    integer, intent(inout) :: count
    type(token_t), intent(in) :: tok
    type(token_t), allocatable :: tmp(:)

    if (.not. allocated(tokens)) then
      allocate(tokens(8))
    else if (count == size(tokens)) then
      allocate(tmp(size(tokens) * 2))
      tmp(1:count) = tokens(1:count)
      call move_alloc(from=tmp, to=tokens)
    end if
    count = count + 1
    tokens(count) = tok
  end subroutine append_token

  subroutine tokenize(src, tokens, n_tokens, stat)
    character(len=*), intent(in) :: src
    type(token_t), allocatable, intent(out) :: tokens(:)
    integer, intent(out) :: n_tokens
    integer, intent(out) :: stat

    integer :: pos, n, start, ios, val
    character(len=1) :: ch
    type(token_t) :: tok

    n = len(src)
    pos = 1
    n_tokens = 0
    stat = 0
    allocate(tokens(8))

    do while (pos <= n)
      ch = src(pos:pos)
      if (is_blank(ch)) then
        pos = pos + 1
        cycle
      end if

      if (is_digit(ch)) then
        start = pos
        do while (pos <= n)
          if (.not. is_digit(src(pos:pos))) exit
          pos = pos + 1
        end do
        tok%lexeme = src(start:pos - 1)
        read(tok%lexeme, *, iostat=ios) val
        if (ios /= 0) then
          stat = -2
          return
        end if
        tok%kind = TOK_INT
        tok%int_val = val
        call append_token(tokens, n_tokens, tok)
      else if (is_alpha(ch)) then
        start = pos
        do while (pos <= n)
          if (.not. is_alnum(src(pos:pos))) exit
          pos = pos + 1
        end do
        tok%kind = TOK_IDENT
        tok%lexeme = src(start:pos - 1)
        tok%int_val = 0
        call append_token(tokens, n_tokens, tok)
      else
        select case (ch)
        case ('+'); tok%kind = TOK_PLUS
        case ('-'); tok%kind = TOK_MINUS
        case ('*'); tok%kind = TOK_STAR
        case ('/'); tok%kind = TOK_SLASH
        case ('('); tok%kind = TOK_LPAREN
        case (')'); tok%kind = TOK_RPAREN
        case default
          stat = -1
          return
        end select
        tok%lexeme = ch
        tok%int_val = 0
        call append_token(tokens, n_tokens, tok)
        pos = pos + 1
      end if
    end do

    tok%kind = TOK_EOF
    tok%lexeme = ''
    tok%int_val = 0
    call append_token(tokens, n_tokens, tok)
  end subroutine tokenize

end module lexer_m

program lexer_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use lexer_m, only: token_t, tokenize, token_kind_name, TOK_EOF
  implicit none (type, external)

  type(token_t), allocatable :: tokens(:)
  integer :: n_tokens, stat, i

  call tokenize('2 * (a + 10)', tokens, n_tokens, stat)
  write(output_unit, '(a,1x,i0)') 'Valid scan stat:', stat
  do i = 1, n_tokens
    if (tokens(i)%kind == TOK_EOF) then
      write(output_unit, '(a)') token_kind_name(tokens(i)%kind)
    else
      write(output_unit, '(a,1x,a)') token_kind_name(tokens(i)%kind), tokens(i)%lexeme
    end if
  end do

  call tokenize('2 @ 3', tokens, n_tokens, stat)
  write(output_unit, '(a,1x,i0)') 'Invalid char stat:', stat

end program lexer_demo

! Output:
! Valid scan stat: 0
! INT 2
! STAR *
! LPAREN (
! IDENT a
! PLUS +
! INT 10
! RPAREN )
! EOF
! Invalid char stat: -1
