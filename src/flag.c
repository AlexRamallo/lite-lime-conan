#include "app.h"
#include "flag.h"

#include <stdio.h>

#ifndef _WIN32

int wait = 1;

static int version(int c, char** v)
{
    puts(LITE_VERSION);
    return 0;
}

static int set_wait(int c, char** v)
{
    wait = 0;

    return 0;
}

const struct Flag main_flags[] = {
    { .name = "version",   .variant = BOTH, .returns = 1, .func = version,   .description = "displays the program version"},
    { .name = "wait",      .variant = BOTH, .returns = 0, .func = set_wait,  .description = "wait for " LITE_NAME " to terminate"}
};

const size_t main_flags_size = ARRAY_LEN(main_flags);

#endif
