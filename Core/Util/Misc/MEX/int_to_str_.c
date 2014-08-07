//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
	
#include "mex.h"

#include "matrix.h"

#include "stdio.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

void int_to_str (char *str, double in);

void int_to_str (char *str, double in) {
	
	// NOTE: handle infinite values and not a number
	
	sprintf(str, "%d", (int) in);
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// int_to_str_ - convert integers to strings
// --------------------------------------------
//
// C = int_to_str_(T);
//
// Input:
// ------
//  T - integers
//
// Output:
// -------
//  C - strings


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	double *T; 
	
	int m, n, N, ix;
					
	mxArray *C;
		
	char str[32];
	
	//-----------------------
	// INPUT
	//-----------------------

	//--
	// get input numbers
	//--
	
	T = mxGetPr(prhs[0]);

	m = mxGetM(prhs[0]); n = mxGetN(prhs[0]);
		
	N = (m * n);
	
	//-----------------------
	// OUTPUT AND COMPUTATION
	//-----------------------
	
	//--
	// scalar input
	//--
	
	if (N == 1) {
		
		int_to_str(str,*(T));
		
		plhs[0] = mxCreateString(str);
		
	//--
	// matrix input 
	//--
		
	} else {
		
		//--
		// create output cell array
		//--

		plhs[0] = C = mxCreateCellMatrix(m, n);

		// NOTE: we use a single index since the arrays are the same shape

		for (ix = 0; ix < N; ix++) {

			//--
			// convert time to clock string
			//--

			int_to_str(str, *(T + ix));

			//--
			// store string in cell array
			//--

			// NOTE: this is probably the most "intensive" line in this code

			mxSetCell(C, ix, mxCreateString(str));

		}
		
	}
	
}
