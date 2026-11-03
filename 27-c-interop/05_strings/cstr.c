/* cstr.c - C functions taking and returning strings. */
#include <string.h>
#include <ctype.h>

/* Count vowels in a NUL-terminated string. */
int count_vowels(const char *s) {
    int n = 0;
    for (; *s; ++s) if (strchr("aeiouAEIOU", *s)) ++n;
    return n;
}

/* Write an upper-case copy of src into dst (capacity cap, NUL-terminated). */
void to_upper(const char *src, char *dst, int cap) {
    int i = 0;
    for (; src[i] && i < cap - 1; ++i) dst[i] = (char) toupper((unsigned char) src[i]);
    dst[i] = '\0';
}

/* Return a pointer to a static string. */
const char *greeting(void) {
    return "greetings from C";
}
