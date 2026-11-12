! -----------------------------------------------------------------------------
! 01_parser.f90 - Recursive-descent parser for arithmetic expressions
!
! Run:  scripts/run.sh 84-parser/01_parser.f90
! -----------------------------------------------------------------------------
!
! Grammar:
!   expr   = term   { ("+" | "-") term }
!   term   = factor { ("*" | "/") factor }
!   factor = integer | identifier | "(" expr ")"
!
! AST nodes are stored in an arena array (chapter 76) rather than pointers.
! Consumes tokens following chapter 83's scanner design.

module expr_parser_m
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)
  private
  public :: ast_t, parse_expression, print_prefix

  integer, parameter :: TOK_INT    = 1
  integer, parameter :: TOK_IDENT  = 2
  integer, parameter :: TOK_PLUS   = 3
  integer, parameter :: TOK_MINUS  = 4
  integer, parameter :: TOK_STAR   = 5
  integer, parameter :: TOK_SLASH  = 6
  integer, parameter :: TOK_LPAREN = 7
  integer, parameter :: TOK_RPAREN = 8
  integer, parameter :: TOK_EOF    = 9

  integer, parameter :: NODE_INT   = 1
  integer, parameter :: NODE_IDENT = 2
  integer, parameter :: NODE_BINOP = 3

  type :: token_t
    integer :: kind = TOK_EOF
    character(len=:), allocatable :: lexeme
    integer :: int_val = 0
  end type token_t

  type :: ast_node_t
    integer :: kind = 0
    character(len=1) :: op = ' '
    integer :: int_val = 0
    character(len=:), allocatable :: ident
    integer :: left = 0
    integer :: right = 0
  end type ast_node_t

  type :: ast_t
    type(ast_node_t), allocatable :: nodes(:)
    integer :: count = 0
    integer :: root = 0
  end type ast_t

  type :: parser_state_t
    type(token_t), allocatable :: tokens(:)
    integer :: n_tokens = 0
    integer :: pos = 1
    integer :: stat = 0
  end type parser_state_t

contains

  subroutine tokenize(src, tokens, n_tokens, stat)
    character(len=*), intent(in) :: src
    type(token_t), allocatable, intent(out) :: tokens(:)
    integer, intent(out) :: n_tokens, stat
    integer :: pos, n, start, ios, val
    character(len=1) :: ch
    type(token_t) :: tok
    type(token_t), allocatable :: tmp(:)

    n = len(src)
    pos = 1
    n_tokens = 0
    stat = 0
    allocate(tokens(16))

    do while (pos <= n)
      ch = src(pos:pos)
      if (ch == ' ' .or. ch == achar(9)) then
        pos = pos + 1
        cycle
      end if

      if (ch >= '0' .and. ch <= '9') then
        start = pos
        do while (pos <= n)
          if (src(pos:pos) < '0' .or. src(pos:pos) > '9') exit
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
      else if ((ch >= 'a' .and. ch <= 'z') .or. &
               (ch >= 'A' .and. ch <= 'Z') .or. ch == '_') then
        start = pos
        do while (pos <= n)
          ch = src(pos:pos)
          if (.not. ((ch >= 'a' .and. ch <= 'z') .or. &
                     (ch >= 'A' .and. ch <= 'Z') .or. &
                     (ch >= '0' .and. ch <= '9') .or. ch == '_')) exit
          pos = pos + 1
        end do
        tok%kind = TOK_IDENT
        tok%lexeme = src(start:pos - 1)
        tok%int_val = 0
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
        pos = pos + 1
      end if

      if (n_tokens == size(tokens)) then
        allocate(tmp(size(tokens) * 2))
        tmp(1:n_tokens) = tokens(1:n_tokens)
        call move_alloc(from=tmp, to=tokens)
      end if
      n_tokens = n_tokens + 1
      tokens(n_tokens) = tok
    end do

    if (n_tokens == size(tokens)) then
      allocate(tmp(size(tokens) * 2))
      tmp(1:n_tokens) = tokens(1:n_tokens)
      call move_alloc(from=tmp, to=tokens)
    end if
    n_tokens = n_tokens + 1
    tokens(n_tokens)%kind = TOK_EOF
    tokens(n_tokens)%lexeme = ''
    tokens(n_tokens)%int_val = 0
  end subroutine tokenize

  function alloc_node(tree, node) result(idx)
    type(ast_t), intent(inout) :: tree
    type(ast_node_t), intent(in) :: node
    type(ast_node_t), allocatable :: tmp(:)
    integer :: idx

    if (.not. allocated(tree%nodes)) then
      allocate(tree%nodes(16))
    else if (tree%count == size(tree%nodes)) then
      allocate(tmp(size(tree%nodes) * 2))
      tmp(1:tree%count) = tree%nodes(1:tree%count)
      call move_alloc(from=tmp, to=tree%nodes)
    end if
    tree%count = tree%count + 1
    tree%nodes(tree%count) = node
    idx = tree%count
  end function alloc_node

  recursive function parse_expr(st, tree) result(idx)
    type(parser_state_t), intent(inout) :: st
    type(ast_t), intent(inout) :: tree
    integer :: idx, rhs, op_kind
    type(ast_node_t) :: node

    idx = parse_term(st, tree)
    if (st%stat /= 0) return

    do while (st%tokens(st%pos)%kind == TOK_PLUS .or. &
              st%tokens(st%pos)%kind == TOK_MINUS)
      op_kind = st%tokens(st%pos)%kind
      st%pos = st%pos + 1
      rhs = parse_term(st, tree)
      if (st%stat /= 0) return

      node%kind = NODE_BINOP
      node%op = merge('+', '-', op_kind == TOK_PLUS)
      node%left = idx
      node%right = rhs
      idx = alloc_node(tree, node)
    end do
  end function parse_expr

  recursive function parse_term(st, tree) result(idx)
    type(parser_state_t), intent(inout) :: st
    type(ast_t), intent(inout) :: tree
    integer :: idx, rhs, op_kind
    type(ast_node_t) :: node

    idx = parse_factor(st, tree)
    if (st%stat /= 0) return

    do while (st%tokens(st%pos)%kind == TOK_STAR .or. &
              st%tokens(st%pos)%kind == TOK_SLASH)
      op_kind = st%tokens(st%pos)%kind
      st%pos = st%pos + 1
      rhs = parse_factor(st, tree)
      if (st%stat /= 0) return

      node%kind = NODE_BINOP
      node%op = merge('*', '/', op_kind == TOK_STAR)
      node%left = idx
      node%right = rhs
      idx = alloc_node(tree, node)
    end do
  end function parse_term

  recursive function parse_factor(st, tree) result(idx)
    type(parser_state_t), intent(inout) :: st
    type(ast_t), intent(inout) :: tree
    integer :: idx
    type(ast_node_t) :: node

    idx = 0
    select case (st%tokens(st%pos)%kind)
    case (TOK_INT)
      node%kind = NODE_INT
      node%int_val = st%tokens(st%pos)%int_val
      st%pos = st%pos + 1
      idx = alloc_node(tree, node)
    case (TOK_IDENT)
      node%kind = NODE_IDENT
      node%ident = st%tokens(st%pos)%lexeme
      st%pos = st%pos + 1
      idx = alloc_node(tree, node)
    case (TOK_LPAREN)
      st%pos = st%pos + 1
      idx = parse_expr(st, tree)
      if (st%stat /= 0) return
      if (st%tokens(st%pos)%kind /= TOK_RPAREN) then
        st%stat = -3
        return
      end if
      st%pos = st%pos + 1
    case default
      st%stat = -4
    end select
  end function parse_factor

  subroutine parse_expression(src, tree, stat)
    character(len=*), intent(in) :: src
    type(ast_t), intent(out) :: tree
    integer, intent(out) :: stat
    type(parser_state_t) :: st

    call tokenize(src, st%tokens, st%n_tokens, stat)
    if (stat /= 0) return

    st%pos = 1
    st%stat = 0
    tree%count = 0
    tree%root = parse_expr(st, tree)

    if (st%stat /= 0) then
      stat = st%stat
      return
    end if
    if (st%tokens(st%pos)%kind /= TOK_EOF) then
      stat = -5
      return
    end if
    stat = 0
  end subroutine parse_expression

  recursive subroutine print_prefix(tree, idx)
    type(ast_t), intent(in) :: tree
    integer, intent(in) :: idx

    if (idx <= 0) return
    select case (tree%nodes(idx)%kind)
    case (NODE_INT)
      write(output_unit, '(i0)') tree%nodes(idx)%int_val
    case (NODE_IDENT)
      write(output_unit, '(a)') tree%nodes(idx)%ident
    case (NODE_BINOP)
      write(output_unit, '(a)') tree%nodes(idx)%op
      call print_prefix(tree, tree%nodes(idx)%left)
      call print_prefix(tree, tree%nodes(idx)%right)
    end select
  end subroutine print_prefix

end module expr_parser_m

program parser_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use expr_parser_m, only: ast_t, parse_expression, print_prefix
  implicit none (type, external)

  type(ast_t) :: tree
  integer :: stat

  call parse_expression('2 * (a + 10)', tree, stat)
  if (stat == 0) then
    call print_prefix(tree, tree%root)
  end if

  ! Mismatched parenthesis sets stat /= 0 and prints no tree
  call parse_expression('2 * (a + 10', tree, stat)
  write(output_unit, '(a,1x,l1)') 'Mismatched paren rejected:', (stat /= 0)

end program parser_demo

! Output:
! *
! 2
! +
! a
! 10
! Mismatched paren rejected: T
