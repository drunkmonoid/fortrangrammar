# 23 — File I/O

Units, files, the three access methods, binary data, namelists and
asynchronous transfers.

## Examples

| File | Topic |
|---|---|
| [01_open_close.f90](01_open_close.f90) | `open(newunit=)`, `status=`, `position='append'`, `close(status='delete')` |
| [02_reading_lines.f90](02_reading_lines.f90) | Lines of any length: `advance='no'`, `size=`, `iostat_eor`/`iostat_end` |
| [03_non_advancing_output.f90](03_non_advancing_output.f90) | Partial records, progress output |
| [04_direct_access.f90](04_direct_access.f90) | `access='direct'`, `rec=`, `inquire(iolength=)` |
| [05_stream_access.f90](05_stream_access.f90) | `access='stream'`, `pos=`, byte-exact binary |
| [06_unformatted_sequential.f90](06_unformatted_sequential.f90) | Binary records and record markers |
| [07_inquire.f90](07_inquire.f90) | `inquire` by file and by unit |
| [08_namelist.f90](08_namelist.f90) | `namelist` input/output |
| [09_positioning.f90](09_positioning.f90) | `rewind`, `backspace`, `endfile`, `flush` |
| [10_asynchronous.f90](10_asynchronous.f90) | `asynchronous='yes'`, `id=`, `wait`, `pending=` |
| [11_internal_files.f90](11_internal_files.f90) | Character arrays as multi-record files |

## Access methods

| `access=` | Structure | `form=` default | Positioning | Typical use |
|---|---|---|---|---|
| `'sequential'` | records in order | formatted | `rewind`, `backspace` | text files, checkpoints |
| `'direct'` | fixed-length numbered records | unformatted | `rec=` | random access tables |
| `'stream'` | bytes, no records | unformatted | `pos=` | binary formats, C interop |

## Data transfer specifiers

| Specifier | Statements | Meaning |
|---|---|---|
| `iostat=`, `iomsg=` | all | status and message instead of aborting |
| `fmt=` / `nml=` | read, write | format / namelist group |
| `advance='no'` | read, write | non-advancing |
| `size=` | read (non-advancing) | characters transferred |
| `rec=` | read, write (direct) | record number |
| `pos=` | read, write (stream) | byte position |
| `asynchronous='yes'`, `id=` | read, write | asynchronous transfer |
| `decimal=`, `round=`, `sign=`, `blank=`, `pad=`, `delim=` | read, write | per-statement modes |
| `end=`, `err=`, `eor=` | read | legacy label jumps — prefer `iostat` |

## Key points

- Use `newunit=` and always check `iostat`.
- `iostat_end` (end of file) and `iostat_eor` (end of record) come from
  `iso_fortran_env`.
- Unformatted sequential files contain record markers; use stream access
  for files shared with other programs.
- Get record lengths from `inquire(iolength=)`, never by guessing.
- Namelist input leaves unspecified variables unchanged: set defaults first.
- `flush` before inquiring sizes or handing a file to another process.
