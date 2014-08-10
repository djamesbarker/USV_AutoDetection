//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------

#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

void fast_quartiles (double *q, double *x, int N);

void fast_quartiles (double *q, double *x, int N)

{

	register int k;
	
	register double q1 = 0, q2 = 0, q3 = 0;
	
	for (k = 0; (k < N) && (q1 == 0); k++) {
		if (*(x + k) >= 0.25) {
			q1 = k + 1;
		}
	}
	
	for (; (k < N) && (q2 == 0); k++) {
		if (*(x + k) >= 0.5) {
			q2 = k + 1;
		}
	}
	
	for (; (k < N) && (q3 == 0); k++) {
		if (*(x + k) >= 0.75) {
			q3 = k + 1;
		}
	}

	*q = q1;
	*(q + 1) = q2;
	*(q + 2) = q3;
	
}   

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
		
	register double *X; int N;
	
	register double *q;

		//--
		// INPUT
		//--
		
		// input cumulative sum vector

	  	X = mxGetPr(prhs[0]);
	  	N = mxGetM(prhs[0]) * mxGetN(prhs[0]);
				
  		//--
  		// OUTPUT
  		//--
    	
    	// extreme values
  		
  		q = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1, 3, mxREAL));
  		
  		//--
  		// COMPUTATION
  		//--
  		
  		fast_quartiles(q,X,N);

}
