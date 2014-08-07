//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
	
#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

// rle_encode - run-length encoding
// --------------------------------
// 
// Input:
// ------
//  X - input binary image
//  m - number of rows
//  n - number of columns
//
// Output:
// -------
//  R - run-length code 
//  N - length of encoding

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

int rle_encode (
	int *R, 
	double *X, int m, int n
);
	
int rle_encode (
	int *R,
	double *X, int m, int n
)

{
	
	register double state;
	
	register int i, run = 0;
	
	int N = 3;
	
	//--
	// store header into run-length code
	//--
	
	*(R) = m;
	*(R + 1) = n;
	*(R + 2) = state = *(X);
	
	//--
	// compute run-length code
	//--
	
	for (i = 0; i < (m * n); i++) {
			
		// update run
		
		if (*(X + i) == state) {
			
			run++;
			
		// store previous run and start new run
			
		} else {
			
			*(R + N++) = run;
			run = 1;
			state = *(X + i);
			
		}
		
	}
	
	// remember to add last run
	
	*(R + N++) = run;
	
	// return number of runs
	
	return N;
	
}

// rle_encode_thresh - threshold and run-length encoder
// ----------------------------------------------------
// 
// Input:
// ------
//  X - input image
//  m - number of rows
//  n - number of columns 
//  t - threshold used in binarization
//
// Output:
// -------
//  R - run-length encoding
//  N - length of encoding

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

int rle_encode_thresh (
	int *R,
	double *X, int m, int n, double t
);
	
int rle_encode_thresh (
	int *R,
	double *X, int m, int n, double t
)

{
	
	register double state;
	
	register int i, run = 0;
	
	int N = 3;
				
	//--
	// store header into run-length code
	//--
			
	*(R) = m;
	*(R + 1) = n;
	*(R + 2) = state = (*(X) > t);
	
	//--
	// compute run-length code
	//--
		
	for (i = 0; i < (m * n); i++) {
				
		// update run
		
		if ((*(X + i) > t) == state) {
			
			run++;
			
		// store previous run and start new run
			
		} else {
			
			*(R + N++) = run;
			run = 1;
			state = (*(X + i) > t);
			
		}
		
	}
	
	// remember to add last run
	
	*(R + N++) = run;
	
	// return number of runs
	
	return N;
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// rle_encode_ - run-length encoding
// ---------------------------------
//
// R = rle_encode_(X);
//
// Input:
// ------
//  X - decoded image
//
// Output:
// -------
//  R - run-length encoding

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	register double *X; register int m, n;
	
	register int *buf, i, N;
		
	register double t;
	
	register double *R;
	
	//-----------------------
	// INPUT
	//-----------------------

	//--
	// get input image data and size
	//--
	
	X = mxGetPr(prhs[0]);

	m = mxGetM(prhs[0]); n = mxGetN(prhs[0]);
		
	//-----------------------
	// COMPUTATION
	//-----------------------
	
	//--
	// allocate buffer for run-length code
	//--
	
	// NOTE: it would be nice to overwrite the image with the code
	
	buf = mxCalloc(m * n, sizeof(int));

	//--
	// binarize and run-length encode
	//--
	
	if (nrhs > 1) {

		t = mxGetScalar(prhs[1]);
		
		N = rle_encode_thresh (buf, X, m, n, t);
		
	//--
	// run-length encode of binary image
	//--
		
	} else {
		
		N = rle_encode (buf, X, m, n);
		
	}
			
	//-----------------------
	// OUTPUT 
	//-----------------------

	//--
	// output run-length code
	//--
	
	R = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1, N, mxREAL));
  	
	//--
	// copy run-length buffer to output and free
	//--
	
	for (i = 0; i < N; i++) {
		*(R + i) = *(buf + i);
	}
	
	mxFree(buf);

}
