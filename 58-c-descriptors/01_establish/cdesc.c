/* Establish a pointer, allocate with a lower bound of 2, and free it.
 * ISO_Fortran_binding.h. The pointer's lower bound comes out of
 * CFI_establish as 0. */
#include <string.h>
#include <ISO_Fortran_binding.h>

static int memory[3] = {1, 2, 3};

void point_at(CFI_cdesc_t *p) {
    CFI_index_t extents[1] = {3};
    CFI_establish(p, memory, CFI_attribute_pointer, CFI_type_int,
                  0, 1, extents);
}

void alloc_from(CFI_cdesc_t *a) {
    CFI_index_t lower[1] = {2};
    CFI_index_t upper[1] = {4};
    int *values;
    CFI_allocate(a, lower, upper, 0);
    values = a->base_addr;
    values[0] = 10;
    values[1] = 20;
    values[2] = 30;
}

void free_it(CFI_cdesc_t *a) {
    CFI_deallocate(a);
}

void put_text(CFI_cdesc_t *s) {
    CFI_allocate(s, NULL, NULL, 3);
    memcpy(s->base_addr, "ada", 3);
}

int c_rank(const CFI_cdesc_t *a) {
    return (int) a->rank;
}
