#include <stdlib.h>

#define NUL 0

void *
__wrap_malloc(size_t bytes)
{
    void *ptr;
    ptr = (void *) mxMalloc(bytes);
    if ( ptr != NUL )
    mexMakeMemoryPersistent(ptr);
    return ptr;
}

void *
__wrap_calloc(size_t n, size_t bytes)
{
    void *ptr;
    ptr = (void *) mxCalloc(n, bytes);
    if ( ptr != NUL )
    mexMakeMemoryPersistent(ptr);
    return ptr;
}

void *
__wrap_realloc(void *pt, size_t bytes)
{
    void *ptr;
    ptr = (void *) mxRealloc(pt, bytes);
    if ( ptr != NUL )
    mexMakeMemoryPersistent(ptr);
    return ptr;    
}

void *
__wrap_free(void *ptr)
{
    return (void *) mxFree(ptr);
}

