/* cdesc.c - C functions receiving Fortran arrays through C descriptors
 * (ISO_Fortran_binding.h, F2018). A descriptor carries the base address,
 * rank, element size, type code and, per dimension, lower bound, extent and
 * stride in BYTES - so C can walk strided sections without copies. */
#include <stdio.h>
#include <ISO_Fortran_binding.h>

/* double sum_any(double a(..)) : assumed rank. */
double sum_any(const CFI_cdesc_t *a) {
    if (a->type != CFI_type_double) return -1.0;
    size_t total = 1;
    for (int d = 0; d < a->rank; ++d) total *= (size_t) a->dim[d].extent;
    double s = 0.0;
    CFI_index_t sub[CFI_MAX_RANK] = {0};
    for (size_t k = 0; k < total; ++k) {
        s += *(double *) CFI_address(a, sub);
        for (int d = 0; d < a->rank; ++d) {          /* odometer increment */
            if (++sub[d] < a->dim[d].extent) break;
            sub[d] = 0;
        }
    }
    return s;
}

/* void describe(double a(:)) : print what the descriptor says. */
void describe(const CFI_cdesc_t *a) {
    printf("rank %d, elem_len %zu, extent %ld, stride %ld bytes, contiguous %d\n",
           (int) a->rank, a->elem_len, (long) a->dim[0].extent,
           (long) a->dim[0].sm, CFI_is_contiguous(a));
    fflush(stdout);
}

/* void make_range(double, allocatable :: a(:), int n) : C allocates. */
int make_range(CFI_cdesc_t *a, int n) {
    CFI_index_t lower[1] = {1}, upper[1] = {n};
    int status = CFI_allocate(a, lower, upper, 0);
    if (status != CFI_SUCCESS) return status;
    for (CFI_index_t i = 0; i < n; ++i) ((double *) a->base_addr)[i] = (double) (i + 1);
    return 0;
}
