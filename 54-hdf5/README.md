# 54 — HDF5

[HDF5](https://www.hdfgroup.org/solutions/hdf5/) (Hierarchical Data Format version 5)
is a widely used high-performance binary format for scientific arrays and metadata.

This chapter demonstrates how to use the standard HDF5 Fortran module (`use hdf5`)
to:
- Initialise the library environment with `h5open_f`
- Create a file with `h5fcreate_f`
- Define a 1-D dataspace with `h5screate_simple_f` and dataset with `h5dcreate_f`
- Write double-precision data (`real64`) with `h5dwrite_f`
- Create and attach a scalar character attribute with `h5acreate_f` and `h5awrite_f`
- Reopen the file and read back both array and attribute to verify contents
- Cleanly release identifiers and terminate with `h5close_f`

`build.sh` locates the Fortran bindings via `h5fc` or `pkg-config` and exits with status 77 if absent.

## Examples

| Directory | Topic |
|---|---|
| [01_dataset_attr/](01_dataset_attr/) | Create an HDF5 file, write dataset and attribute, and read them back |
