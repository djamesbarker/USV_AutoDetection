//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
	
#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

// rle_to_rle2 - convert 1-d run-length code to 2-d run-length code
// ----------------------------------------------------------------
// 
// Input:
// ------
//  *R1 - 1-d run-length code
//   N - length of input code
//
// Output:
// -------
//  *R2 - 2d run-length code
//   P - length of output code

int rle_to_rle2 (
	double *R2,
	double *R1, int N);
	
int rle_to_rle2 (
	double *R2,
	double *R1, int N)

{
	
	register int m, n, state, count;
	
	register double *rle1, *rle2;
		
	register int i, j;
	
	//--
	// copy header information and initialize
	//--
	
	m = *(R2) = *(R1);
	
	n = *(R2 + 1) = *(R1 + 1);
	
    *(R2 + 2) = *(R1 + 2);

    state = (int) *(R2 + 2);  
	
	//--
	// perform code conversion
	//--
		
	count = 0;
	
	rle1 = (R1 + 1); rle2 = (R2 + 3);
	
	for (i = 0; i < N; i++) {
		
		count += *(rle1 + i);
		
		//--
		// run ends not at end of column
		//--
		
		if (count < m) {
			
			// copy code as is
			
			*rle2++ = *(rle1 + i);
			
		//--
		// run ends exactly at end of column
		//--
			
		} else if (count == m) {
			
			// add end and state update marker and reset counter
			
			*rle2++ = -1.0;
			
			count = 0;
			
		//--
		// run exceeds the column
		//--
			
		} else {
			
			// split run into separate columns, add end marker,
			// and reset counter
			
			*rle2++ = *(rle1 + i) - ((double) (count - m));
			*rle2++ = 0;
			*rle2++ = count - m;
			
			count = 0;
			
		}
		
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// rle_to_rle2_ - convert 1d run-length code to 2d run-length code
// ---------------------------------------------------------------
//
// R2 = rle_to_rle2_(R);
//
// Input:
// ------
//  R - 1-d run-length code
//
// Output:
// -------
//  R2 - 2-d run-length code

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	register int m, n, state, N, P;
	
	register double *rle, *R2, *T, *buf;
    
    int i;
		
	//-----------------------
	// INPUT
	//-----------------------
	
	rle = mxGetPr(prhs[0]);

	//--
	// get size of image and initial state
	//--
	
	m = *(rle); 
	
	n = *(rle + 1);

	state = (int) *(rle + 2);

	//--
	// get run-length code and its length
	//--
	
	rle = rle + 3;

	N = mxGetM(prhs[0]) * mxGetN(prhs[0]) - 3;
  	
	//-----------------------
	// COMPUTATION
	//-----------------------

	//--
	// allocate buffer for output run-length code
	//--
		
	buf = mxCalloc(N + 2*n, sizeof(double));
	
	//--
	// perform run-length code conversion
	//--
	
	P = rle_to_rle2 (buf, rle, N);
	
	//-----------------------
	// OUTPUT 
	//-----------------------
	
	R2 = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1,P, mxREAL));
		
	//--
	// copy code buffer to output and free
	//--
	
	for (i = 0; i < P; i++) {
		*(R2 + i) = *(buf + i);
	}
	
	mxFree(buf);
	
}
