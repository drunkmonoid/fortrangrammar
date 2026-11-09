# 50 — CSV

A dependency-free reader and writer for a small CSV subset: commas, quoted
fields, and a quote escaped by doubling it. Fields in one row can have
different lengths, so each field is a derived type holding its own
allocatable character string. A `character(len=:), allocatable :: fields(:)`
array would force every field to the same length.

## Example

| File | Topic |
|---|---|
| [01_csv.f90](01_csv.f90) | Parse three rows, write one back, parse it again |

The round trip is the test. A field that contains a comma or a quote is
quoted on output, and parsing that output returns the original text.
