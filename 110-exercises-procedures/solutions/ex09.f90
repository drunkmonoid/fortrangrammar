! Exercise 19: abstract type with deferred binding + final cleanup triggered at block exit.

module ex19_m
  implicit none (type, external)
  private
  public :: token_base_t, scoped_token_t, finalized_count

  integer :: finalized_count = 0

  type, abstract :: token_base_t
  contains
    procedure(eval_i), deferred :: value
  end type token_base_t

  abstract interface
    pure integer function eval_i(self)
      import :: token_base_t
      class(token_base_t), intent(in) :: self
    end function eval_i
  end interface

  type, extends(token_base_t) :: scoped_token_t
    integer :: val = 0
  contains
    procedure :: value => scoped_value
    final :: destroy_token
  end type scoped_token_t

contains

  pure integer function scoped_value(self)
    class(scoped_token_t), intent(in) :: self
    scoped_value = self%val
  end function scoped_value

  subroutine destroy_token(self)
    type(scoped_token_t), intent(inout) :: self
    finalized_count = finalized_count + 1
    self%val = 0
  end subroutine destroy_token

end module ex19_m

program ex19_oop_advanced
  use, intrinsic :: iso_fortran_env, only: output_unit
  use ex19_m, only: scoped_token_t, finalized_count
  implicit none (type, external)

  integer :: v

  v = 0
  block
    type(scoped_token_t) :: tok
    tok%val = 42
    v = tok%value()
  end block

  write(output_unit, '(a,1x,i0,1x,i0)') 'value, finalized:', v, finalized_count

end program ex19_oop_advanced

! Output:
! value, finalized: 42 1
