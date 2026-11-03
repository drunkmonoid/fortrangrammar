! -----------------------------------------------------------------------------
! 06_unformatted_sequential.f90 - binary records
!
! Run:  scripts/run.sh 23-file-io/06_unformatted_sequential.f90
! -----------------------------------------------------------------------------
!
!   open (newunit=u, form='unformatted')      access='sequential' by default
!   write (u) a, b, c          one RECORD with the raw bits of a, b and c
!   read (u) a, b, c           must read with matching types/sizes
!
! * Exact (no rounding), compact and fast - ideal for checkpoints.
! * Each record is framed by length markers (gfortran: 4 bytes before and
!   after), so the file is NOT a plain byte stream - use access='stream'
!   for interchange with other languages.
! * Reading fewer items than a record holds skips the rest of the record;
!   reading more is an error.
! * Not portable between endianness / compilers in general; gfortran's
!   convert='big_endian' (non-standard) helps with legacy files.

program unformatted_sequential
  implicit none (type, external)

  integer :: u, n
  real, allocatable :: data(:), restored(:)
  character(len=8) :: label
  integer :: file_size, i

  data = [(real(i) / 3, i = 1, 5)]

  open (newunit=u, status='scratch', form='unformatted')
  write (u) 'snapshot', size(data)          ! record 1: header
  write (u) data                            ! record 2: payload
  inquire (unit=u, size=file_size)
  print '(a, i0, a)', 'file size: ', file_size, ' bytes (8+4 + 5*4 + 2 records * 8 marker bytes)'

  rewind (u)
  read (u) label, n
  allocate (restored(n))
  read (u) restored
  close (u)

  print '(3a, i0)', 'label=', label, ' n=', n
  print '(a, l1)', 'bit-exact round trip: ', all(restored == data)

end program unformatted_sequential

! Output:
! file size: 48 bytes (8+4 + 5*4 + 2 records * 8 marker bytes)
! label=snapshot n=5
! bit-exact round trip: T
