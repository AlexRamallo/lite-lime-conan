#include <string.h>
#include <unistd.h>

#include "flag.h"
#include "app.h"

int main(int argc, char** argv)
{
    progname = argv[0];
#ifndef _WIN32
    for (int i = 1; i < argc; ++i)
    {
        for (unsigned long j = 0; j < main_flags_size; ++j) \
        {
            if ((main_flags[j].variant & ONE && argv[i][1] == main_flags[j].name[0] \
                                                && argv[i][2] == '\0') ||
                (main_flags[j].variant & TWO && argv[i][1] == '-'
                 && !strcmp(main_flags[j].name, argv[i]+2)))
            {
                int retval = main_flags[j].func(0, NULL);
                if (main_flags[j].returns)
                {
                    return retval;
                }
                argv[i] = NULL;
            }
        }
    }

    if (wait)
    {   
        pid_t pid = fork();
        if (pid)
        {
            // fork off the process so we can return control of the terminal to the user
            // not applicable on Windows since applications using the GUI subsystem don't reserve the command prompt
            return 0;
        }
    }
#endif

    return app(argc, argv);
}