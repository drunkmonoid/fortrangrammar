# 47 — FFTW

A real-to-complex transform through FFTW's C interface, declared with
`iso_c_binding` (chapter 27). The usual `include 'fftw3.f03'` needs the
FFTW Fortran header, which many installs do not ship, so the declarations
live in the example.

`fftw_plan_dft_r2c_1d` builds a plan, `fftw_execute` runs it, and
`fftw_destroy_plan` releases it. `FFTW_ESTIMATE` (64) does not measure
the machine and does not read a wisdom file. Wisdom is a saved set of
measured plans (`fftw_export_wisdom_to_filename`); this example does not
load one.

The transform is unnormalised. A constant input of ones has a DC bin
equal to the length and zeros elsewhere.

`build.sh` uses `pkg-config --libs fftw3`, then `-lfftw3`, then the
runtime SONAME `libfftw3.so.3` when the development symlink is absent.
It exits 77 when none of those is installed.

## Examples

| File | Topic |
|---|---|
| [01_r2c/](01_r2c/) | Plan, execute, and destroy a real-to-complex transform |
