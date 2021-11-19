#ifndef FLAG_H
#define FLAG_H

#include <stddef.h>

#define ARRAY_LEN(arr) sizeof(arr) / sizeof(arr[0])

enum flag_variants {
    ONE = 1 << 0,
    TWO = 1 << 1,
    BOTH   = ONE + TWO,
};

struct Flag {
    char* name;
    enum flag_variants variant;
    int returns;
    int (*func)(int, char**);
    char* description;
};

extern int wait;

extern const struct Flag main_flags[];
extern const size_t main_flags_size;

#endif