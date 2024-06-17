#include <pinc.h>

// We don't want to have all of the win32 symbols when this header is included elsewhere.
// But, since they are still needed sometimes, we define our own ABI compatible versions.
#ifndef PINC_WIN32_INCLUDED


#endif

bool win32_init(void);
void win32_deinit(void);