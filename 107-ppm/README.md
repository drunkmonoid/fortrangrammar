# 107 — PPM Images

Round-trip ASCII PPM (`P3`) writer and reader using a Fortran `scratch` file so no temporary image file persists on disk.

## Behaviour

- Writes a `2x2` `P3` header (`2 2`, `255`) and four RGB pixels `(255,0,0)`, `(0,255,0)`, `(0,0,255)`, `(128,64,32)`.
- Rewinds the scratch unit, skips the header after validating it, reads all 12 channel values back as integers, and closes the unit (automatically removing the scratch file).

## Files

| File | Description |
|---|---|
| [01_ppm.f90](01_ppm.f90) | 2x2 P3 PPM scratch-file write and read-back |
