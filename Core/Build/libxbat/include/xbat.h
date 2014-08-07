#include <mex.h>
#include <math.h>

/*
 * computation utility functions
 */

void fast_min_max (double *Lk, double *Uk, double *X, const int N);

/*
 * data utility functions
 */

mxArray * mxUninitializedMatrix(int rows, int columns, int mx_class, int mx_type);