//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------

#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

void fast_min_max (double *b, double *x, int N);

void fast_min_max (double *b, double *x, int N) {

	int k; double x1, x2, xx; double L, U;
	
	// NOTE: initialize limits to first entry
	
	L = U = *x;
	
	for (k = 0; k < N - 1; k = k + 2) {
		        
		x1 = *(x + k); x2 = *(x + k + 1);
		
		// NOTE: sort next pair to consider and update min and max
		
		if (x1 > x2) { 
			xx = x1; x1 = x2; x2 = xx; 
		}

		if (x1 < L) { 
			L = x1; 
		}
		
		if (x2 > U) { 
			U = x2; 
		}
		
	}
	
	// NOTE: consider the odd length case
	
	if (N % 2) {
	
		xx = *(x + N - 1);
						
		if (xx < L) {
			L = xx;
		} else if (xx > U) {
			U = xx;
		}
		
	}
	
	*b = L; *(b + 1) = U;
	
}   

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
		
	double *X; int N; double *b;

	// INPUT
	
	X = mxGetPr(prhs[0]); N = mxGetM(prhs[0]) * mxGetN(prhs[0]);
	
	// OUTPUT
	
	b = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1, 2, mxREAL));
	
	// COMPUTE
	
	fast_min_max(b, X, N);

}
