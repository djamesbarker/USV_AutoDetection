//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
	
#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

// single_thresh - single threshold computation
// --------------------------------------------
// 
// Input:
// ------
//  *X - input image
//   N - number of elements in input image
//   T - threshold value
//
// Output:
// -------
//  *Y - thresholded image

void single_thresh (
	double *Y,
	double *X, int N, double T
);
	
void single_thresh (
	double *Y,
	double *X, int N, double T
)

{
		
	register int i;
	
	//--
	// compute threshold image
	//--
		
	// NOTE: the output image is initialized to zeros
	
	for (i = 0; i < N; i++) {
		if (*(X + i) > T) {
			*(Y + i) = 1.0;
		}
	}
	
}

// multi_thresh - multiple threshold computation
// ---------------------------------------------
// 
// Input:
// ------
//  *X - input image
//   N - number of elements in input image
//  *CT - candidate threshold array
//   P - number of candidate thresholds
//
// Output:
// -------
//  *Y - multiple threshold image

void multi_thresh (
	double *Y,
	double *X, int N, double *CT, int P);
	
void multi_thresh (
	double *Y,
	double *X, int N, double *CT, int P)

{
		
	register int i, k = 0;

	register double value;
	
	//--
	// compute multiple threshold image
	//--
		
	for (i = 0; i < N; i++) {
				
		//--
		// compute how many thresholds are satisfied
		//--
		
		// NOTE: code assumes thresholds are ordered (for correctness) and correlated values (for efficiency)
		
		value = *(X + i); 
		
		while ((value > *(CT + k)) && (k < P)) k++;	
		
		while ((value <= *(CT + k)) && (k > 0)) k--;
		
		//--
		// record the number of satisfied thresholds
		//--
			
		*(Y + i) = k;
		
		// NOTE: we need to move head inside threshold array
		
		if (k == P) k--;
		
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// multi_thresh_ - multiple image thresholds computation
// -----------------------------------------------------
//
// Y = multi_thresh_(X,CT);
//
// Input:
// ------
//  X - input image
//  CT - candidate threshold values
//
// Output:
// -------
//  Y - multiply thresholded image

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	register int m, n, N, P;
	
	register double *X, *CT, T, *Y;
	
	//-----------------------
	// INPUT
	//-----------------------

	//--
	// input image
	//--
	
	X = mxGetPr(prhs[0]);

	m = mxGetM(prhs[0]); n = mxGetN(prhs[0]);
	
	N = m * n;
	
	//--
	// candidate thresholds
	//--
	
	CT = mxGetPr(prhs[1]);
	
	P = mxGetM(prhs[1]) * mxGetN(prhs[1]);
	
	// get single threshold
	
	if (P == 1) {
		T = *CT;
	}
	
	//-----------------------
	// OUTPUT 
	//-----------------------

	//--
	// multiply thresholded image
	//--
	
	Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL));
	
	//-----------------------
	// COMPUTATION
	//-----------------------
	
	if (P == 1) {
		single_thresh (Y, X, N, T);
	} else {
		multi_thresh (Y, X, N, CT, P);
	}

}
