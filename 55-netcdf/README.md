# 55 — NetCDF

[NetCDF](https://www.unidata.ucar.edu/software/netcdf/) (Network Common Data Form)
is an array-oriented scientific data standard widely used in atmospheric and oceanic
sciences, geosciences, and climatology.

This chapter demonstrates how to use the official NetCDF Fortran 90 interface (`use netcdf`)
to:
- Create a NetCDF dataset using `nf90_create`
- Define dimensions using `nf90_def_dim`
- Define multidimensional variables with element type specs (`NF90_DOUBLE`) using `nf90_def_var`
- Attach metadata attributes (such as `"units"`) using `nf90_put_att`
- Exit definition mode (`nf90_enddef`) and write array data with `nf90_put_var`
- Close and reopen the file to query and retrieve variables (`nf90_get_var`) and attributes (`nf90_get_att`)

`build.sh` uses `nf-config` or `pkg-config netcdf-fortran` to locate compiler flags and libraries, exiting with status 77 if unavailable.

## Examples

| Directory | Topic |
|---|---|
| [01_dim_var_attr/](01_dim_var_attr/) | Define a dimension, variable, and attribute, write data and read them back |
