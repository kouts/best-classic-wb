#ifndef DEBUG_H
#define DEBUG_H

#define DEBUG 1

#if DEBUG

	#include <clib/debug_protos.h>

	const char *attr_name (ULONG id);
	const char *method_name (ULONG id);

#else

	#define kprintf(...)

#endif /* DEBUG */
#endif /* DEBUG_H */
