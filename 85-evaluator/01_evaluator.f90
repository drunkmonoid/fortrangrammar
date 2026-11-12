! -----------------------------------------------------------------------------
! 01_evaluator.f90 - Tree-walking evaluator for parsed arithmetic expressions
!
! Run:  scripts/run.sh 85-evaluator/01_evaluator.f90
! -----------------------------------------------------------------------------
!
! Evaluates the AST produced by chapter 84's parser against an environment
! mapping variable names (`a = 3`, `b = 4`) to integer values.
! Precedence and grouping are already encoded in the AST structure; the
! evaluator performs a simple post-order traversal and flags division by zero
! or unknown identifiers via `stat`.

module evaluator_m
  implicit none (type, external)
  private
  public :: env_entry_t, eval_expression

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

  type :: env_entry_t
    character(len=:), allocatable :: name
    integer :: val = 0
  end type env_entry_t

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
    integer :: pos = 1
    integer :: stat = 0
  end type parser_state_t

contains

  subroutine tokenize(src, tokens, stat)
    character(len=*), intent(in) :: src
    type(token_t), allocatable, intent(out) :: tokens(:)
    integer, intent(out) :: stat
    integer :: pos, n, n_tok, start, ios, val
    character(len=1) :: ch
    type(token_t) :: tok
    type(token_t), allocatable :: tmp(:)

    n = len(src)
    pos = 1
    n_tok = 0
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

      if (n_tok == size(tokens)) then
        allocate(tmp(size(tokens) * 2))
        tmp(1:n_tok) = tokens(1:n_tok)
        call move_alloc(from=tmp, to=tokens)
      end if
      n_tok = n_tok + 1
      tokens(n_tok) = tok
    end do

    if (n_tok == size(tokens)) then
      allocate(tmp(size(tokens) * 2))
      tmp(1:n_tok) = tokens(1:n_tok)
      call move_alloc(from=tmp, to=tokens)
    end if
    n_tok = n_tok + 1
    tokens(n_tok)%kind = TOK_EOF
    tokens(n_tok)%lexeme = ''
    tokens(n_tok)%int_val = 0
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

  recursive function eval_node(tree, idx, env, stat) result(res)
    type(ast_t), intent(in) :: tree
    integer, intent(in) :: idx
    type(env_entry_t), intent(in) :: env(:)
    integer, intent(out) :: stat
    integer :: res, lhs, rhs, i

    stat = 0
    res = 0
    select case (tree%nodes(idx)%kind)
    case (NODE_INT)
      res = tree%nodes(idx)%int_val
    case (NODE_IDENT)
      do i = 1, size(env)
        if (env(i)%name == tree%nodes(idx)%ident) then
          res = env(i)%val
          return
        end if
      end do
      stat = -11  ! Unknown variable
    case (NODE_BINOP)
      lhs = eval_node(tree, tree%nodes(idx)%left, env, stat)
      if (stat /= 0) return
      rhs = eval_node(tree, tree%nodes(idx)%right, env, stat)
      if (stat /= 0) return

      select case (tree%nodes(idx)%op)
      case ('+'); res = lhs + rhs
      case ('-'); res = lhs - rhs
      case ('*'); res = lhs * rhs
      case ('/')
        if (rhs == 0) then
          stat = -10  ! Division by zero
          return
        end if
        res = lhs / rhs
      end select
    end select
  end function eval_node

  subroutine eval_expression(src, env, val, stat)
    character(len=*), intent(in) :: src
    type(env_entry_t), intent(in) :: env(:)
    integer, intent(out) :: val, stat
    type(parser_state_t) :: st
    type(ast_t) :: tree

    val = 0
    call tokenize(src, st%tokens, stat)
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

    val = eval_node(tree, tree%root, env, stat)
  end subroutine eval_expression

end module evaluator_m

program evaluator_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use evaluator_m, only: env_entry_t, eval_expression
  implicit none (type, external)

  type(env_entry_t) :: env(2)
  integer :: val, stat

  env(1) = env_entry_t('a', 3)
  env(2) = env_entry_t('b', 4)

  call eval_expression('2 * (a + 10)', env, val, stat)
  write(output_unit, '(a,1x,i0,1x,a,1x,i0)') '2 * (a + 10) =', val, 'stat =', stat

  call eval_expression('a + b * 2', env, val, stat)
  write(output_unit, '(a,1x,i0,1x,a,1x,i0)') 'a + b * 2 =', val, 'stat =', stat

  call eval_expression('10 / (a - 3)', env, val, stat)
  write(output_unit, '(a,1x,i0)') 'div by zero stat =', stat

end program evaluator_demo

! Output:
! 2 * (a + 10) = 26 stat = 0
! a + b * 2 = 11 stat = 0
! div by zero stat = -10
