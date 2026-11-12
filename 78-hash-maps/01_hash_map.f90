! -----------------------------------------------------------------------------
! 01_hash_map.f90 - Open addressing hash map with linear probing and tombstones
!
! Run:  scripts/run.sh 78-hash-maps/01_hash_map.f90
! -----------------------------------------------------------------------------
!
! Demonstrates open addressing with linear probing:
!   - Modulo hash: mod(key, capacity) + 1
!   - Collision resolution: (idx mod capacity) + 1
!   - Deletion uses a TOMBSTONE marker to maintain search probe chains
!   - Dynamic resizing when load factor reaches 0.5

module hash_map_m
  use, intrinsic :: iso_fortran_env, only: output_unit
  implicit none (type, external)
  private
  public :: hash_map_t

  integer, parameter :: STATE_EMPTY = 0
  integer, parameter :: STATE_OCCUPIED = 1
  integer, parameter :: STATE_TOMBSTONE = 2

  type :: entry_t
    integer :: key = 0
    integer :: val = 0
    integer :: state = STATE_EMPTY
  end type entry_t

  type :: hash_map_t
    private
    type(entry_t), allocatable :: table(:)
    integer :: n_items = 0
    integer :: cap = 0
  contains
    procedure :: init
    procedure :: put
    procedure :: get
    procedure :: delete
    procedure :: resize
  end type hash_map_t

contains

  subroutine init(self, initial_cap)
    class(hash_map_t), intent(inout) :: self
    integer, intent(in) :: initial_cap
    integer :: i

    self%cap = initial_cap
    self%n_items = 0
    allocate(self%table(self%cap))
    do i = 1, self%cap
      self%table(i)%state = STATE_EMPTY
    end do
  end subroutine init

  subroutine resize(self, new_cap)
    class(hash_map_t), intent(inout) :: self
    integer, intent(in) :: new_cap
    type(entry_t), allocatable :: old_table(:)
    integer :: i, old_cap

    old_cap = self%cap
    call move_alloc(from=self%table, to=old_table)

    call self%init(new_cap)
    do i = 1, old_cap
      if (old_table(i)%state == STATE_OCCUPIED) then
        call self%put(old_table(i)%key, old_table(i)%val)
      end if
    end do
  end subroutine resize

  subroutine put(self, key, val)
    class(hash_map_t), intent(inout) :: self
    integer, intent(in) :: key, val
    integer :: idx, first_tombstone, i

    ! Grow if load factor exceeds 0.5
    if (self%n_items * 2 >= self%cap) then
      call self%resize(self%cap * 2)
    end if

    idx = mod(abs(key), self%cap) + 1
    first_tombstone = 0

    do i = 1, self%cap
      if (self%table(idx)%state == STATE_OCCUPIED) then
        if (self%table(idx)%key == key) then
          self%table(idx)%val = val  ! Overwrite existing key
          return
        end if
      else if (self%table(idx)%state == STATE_TOMBSTONE) then
        if (first_tombstone == 0) first_tombstone = idx
      else if (self%table(idx)%state == STATE_EMPTY) then
        exit
      end if
      idx = mod(idx, self%cap) + 1
    end do

    ! Place at first available tombstone or empty slot
    if (first_tombstone /= 0) then
      idx = first_tombstone
    end if

    self%table(idx)%key = key
    self%table(idx)%val = val
    self%table(idx)%state = STATE_OCCUPIED
    self%n_items = self%n_items + 1
  end subroutine put

  function get(self, key, val) result(stat)
    class(hash_map_t), intent(in) :: self
    integer, intent(in) :: key
    integer, intent(out) :: val
    integer :: stat
    integer :: idx, i

    idx = mod(abs(key), self%cap) + 1
    do i = 1, self%cap
      if (self%table(idx)%state == STATE_EMPTY) then
        stat = -1  ! Key not found
        val = 0
        return
      else if (self%table(idx)%state == STATE_OCCUPIED) then
        if (self%table(idx)%key == key) then
          val = self%table(idx)%val
          stat = 0
          return
        end if
      end if
      idx = mod(idx, self%cap) + 1
    end do

    stat = -1
    val = 0
  end function get

  subroutine delete(self, key, stat)
    class(hash_map_t), intent(inout) :: self
    integer, intent(in) :: key
    integer, intent(out) :: stat
    integer :: idx, i

    idx = mod(abs(key), self%cap) + 1
    do i = 1, self%cap
      if (self%table(idx)%state == STATE_EMPTY) then
        stat = -1
        return
      else if (self%table(idx)%state == STATE_OCCUPIED) then
        if (self%table(idx)%key == key) then
          self%table(idx)%state = STATE_TOMBSTONE
          self%n_items = self%n_items - 1
          stat = 0
          return
        end if
      end if
      idx = mod(idx, self%cap) + 1
    end do

    stat = -1
  end subroutine delete

end module hash_map_m

program hash_map_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use hash_map_m, only: hash_map_t
  implicit none (type, external)

  type(hash_map_t) :: map
  integer :: val, stat

  call map%init(16)

  ! Insert colliding keys: mod(10, 16)+1=11, mod(26, 16)+1=11
  call map%put(10, 100)
  call map%put(26, 260)
  call map%put(42, 420)
  call map%put(5, 50)

  ! Overwrite key 26
  call map%put(26, 265)

  ! Delete key 10 (sets tombstone at index 11)
  call map%delete(10, stat)

  ! Look up surviving colliding keys (probes across the tombstone)
  stat = map%get(26, val)
  write(output_unit, '(a,i0,a,i0)') 'Key 26: val = ', val, ', stat = ', stat

  stat = map%get(42, val)
  write(output_unit, '(a,i0,a,i0)') 'Key 42: val = ', val, ', stat = ', stat

  stat = map%get(5, val)
  write(output_unit, '(a,i0,a,i0)') 'Key 5: val = ', val, ', stat = ', stat

  ! Lookup deleted key
  stat = map%get(10, val)
  write(output_unit, '(a,i0)') 'Key 10 deleted lookup stat = ', stat

end program hash_map_demo

! Output:
! Key 26: val = 265, stat = 0
! Key 42: val = 420, stat = 0
! Key 5: val = 50, stat = 0
! Key 10 deleted lookup stat = -1
