#include <xbat.h>

/*
 * mxUninitializedMatrix - create an uninitialized mxArray of a given size
 */

mxArray * mxUninitializedMatrix(int rows, int columns, int mx_class, int mx_type) {

    mxArray * A;
    
    A = mxCreateNumericMatrix(0, 0, mx_class, mx_type);
    
    mxSetM(A, rows); mxSetN(A, columns);
    
    return A;
    
}
