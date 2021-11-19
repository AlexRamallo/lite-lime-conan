#ifndef APP_H
#define APP_H

#ifndef LITE_NAME
#define LITE_NAME "Lite Lime"
#endif

#ifndef LITE_VERSION
#define LITE_VERSION "master"
#endif

extern char* progname;

int app(int argc, char **argv);

#endif