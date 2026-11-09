# The gfortran 15 job

The workflow file is [`.github/workflows/check.yml`](../.github/workflows/check.yml).
It checks out the repository, installs gfortran 15, and runs
`scripts/check_all.sh`. See the chapter README for the optional `ifx`
job.
