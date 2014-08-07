//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
	
#include "stdlib.h"

#include "math.h"
	
#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------
		 
// fast_peak_valley - compute location of peaks and valleys
// --------------------------------------------------------
// 
// M = fast_peak_valley(K, X, N);
//
// Input:
// ------
//  X - pointer to input sequence
//  N - length of sequence
//
// Output:
// -------
//  K - extrema index sequence
//  M - number of extrema

/*
%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 943 $
% $Date: 2005-04-15 18:03:43 -0400 (Fri, 15 Apr 2005) $
%--------------------------------
*/

int fast_peak_valley (
	int *K, 
	double *X, int N
);
	
int fast_peak_valley (
	int *K,
	double *X, int N
)

{
	
	register int k, M = 0;
	
	register double v1, v2, v3;
	
	register int c12, c23;
					    
	//--
	// compute first entry
	//--
	
	v1 = *X; 
	v2 = *(X + 1); 
	v3 = *(X + 2);
	
	// NOTE: compare consecutive value pairs
	
	c12 = (v1 < v2); 
	c23 = (v2 < v3);
	
	// NOTE: this is a logical XOR expression
	
	if (c12 && !c23) {
		*(K + M++) += 2;
	} else if (!c12 && c23) {
		*(K + M++) -= 2;
	}
		
	//--
	// compute remaining entries
	//--
	
	for (k = 2; k < (N - 1); k++) {
		
		v1 = v2;
		v2 = v3;
		v3 = *(X + k + 1);
		
		// NOTE: compare consecutive value pairs
		
		c12 = (v1 < v2);
		c23 = (v2 < v3);
		
		// NOTE: this is a logical XOR expression
		
		if (c12 && !c23) {
			*(K + M++) += (k + 1);
		} else if (!c12 && c23) {
			*(K + M++) -= (k + 1);
		}
		
	}
	
	//--
	// output number of extrema
	//--
	
	return M;
	
}

// peak_valley - compute location of peaks and valleys
// ---------------------------------------------------
// 
// M = peak_valley(K, H, W, X, N);
//
// Input:
// ------
//  X - pointer to input sequence
//  N - length of sequence
//
// Output:
// -------
//  K - extrema index sequence
//  H - extrema height array
//  W - extrema width array
//  M - number of extrema

/*
%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 943 $
% $Date: 2005-04-15 18:03:43 -0400 (Fri, 15 Apr 2005) $
%--------------------------------
*/

int peak_valley (
	int *K, double *H, int *W,
	double *X, int N
);
	
int peak_valley (
	int *K, double *H, int *W,
	double *X, int N
)

{
	
	register int k, M = 0, P = 0;
	
	register double v1, v2, v3;
	
	register int c12, c23;
	
	register double e1;
	
	register int k1 = 0;
		
	//--
	// get starting value
	//--
	
	e1 = *X;
	
	//--
	// compute first entry
	//--
					
	v1 = *X;
	v2 = *(X + 1);
	v3 = *(X + 2);
	
	c12 = (v1 < v2);
	c23 = (v2 < v3);
	
	// NOTE: this is a logical XOR expression
	
	if ((c12 && !c23) || (!c12 && c23)) {
			
		//--
		// get location
		//--
		
		if (c12) {			
			*(K + M++) = 2;
		} else {	
			*(K + M++) = -2;
		}
		
		//--
		// get height or depth
		//--
		
		*(H + P) = fabs(v2 - e1);
		e1 = v2;
		
		//--
		// get width
		//--
		
		if (W) {
			*(W + P) = 1;
			k1 = 1;
		}
		
		// NOTE: this could only be the first extremum
		
		P++;
		
	}
		
	//--
	// compute remaining entries
	//--
	
	for (k = 2; k < (N - 1); k++) {
		
		v1 = v2;
		v2 = v3;
		v3 = *(X + k + 1);
		
		c12 = (v1 < v2);
		c23 = (v2 < v3);
		
		// NOTE: this is a logical XOR expression
		
		if ((c12 && !c23) || (!c12 && c23)) {
			
			//--
			// get location
			//--
			
			if (c12) {
				*(K + M++) = (k + 1);
			} else {
				*(K + M++) = -1 * (k + 1);
			}
			
			//--
			// get height or depth
			//--
			
			*(H + P) = fabs(v2 - e1);
			
			if (M > 1)
				*(H + (P + 1)) = *(H + P);
			
			e1 = v2;
			
			//--
			// get width
			//--
			
			if (W) {
				
				*(W + P) = k - k1;
				
				if (M > 1)
					*(W + (P + 1)) = *(W + P);
				
				k1 = k;
				
			}
			
			if (M > 1) {
				P = P + 2;
			} else {
				P++;
			}

		}
		
	}
	
	//--
	// get end height or depth and width
	//--
	
	*(H + P) = fabs(*(X + (N - 1)) - e1);
	
	if (W) {
		*(W + P) = (N - 1) - k1;
	}
	
	//--
	// output number of extrema
	//--
	
	return M;
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// fast_peak_valley_ - fast peak and valley computation
// ----------------------------------------------------
//
// Y = fast_peak_valley_(X)
//
// Input:
// ------
//  X - input sequence 
//
// Output:
// -------
//  Y - peak and valley indices

/*
%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 943 $
% $Date: 2005-04-15 18:03:43 -0400 (Fri, 15 Apr 2005) $
%--------------------------------
*/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	double *X; int m, n, N;
	
	int *K, M;
	
	double *H = NULL; int *W = NULL;
	
	int k;

	//----------------------------------------------
	// INPUT 
	//----------------------------------------------

	//--
	// get input information
	//--
	
	// NOTE: for the moment this function treats matrices as vectors
	
	X = mxGetPr(prhs[0]);

	m = mxGetM(prhs[0]); n = mxGetN(prhs[0]);
	
	N = m * n;
	
	//----------------------------------------------
	// COMPUTATION
	//----------------------------------------------
		
	//--
	// allocate internal arrays
	//--
	
	K = (int *) mxCalloc(N, sizeof(int));
	
	if (nlhs > 1) {
		H = (double *) mxCalloc(N, sizeof(double));
	}
	
	if (nlhs > 2) {
		W = (int *) mxCalloc(N, sizeof(int));
	}
	
	//--
	// fast computation of extrema indices
	//--
	
	if (nlhs < 2) {
		
		M = fast_peak_valley(K, X, N);
		
	//--
	// computation of extrema indices along with other extrema information
	//--
		
	// NOTE: there is convenient redundancy in the output of this function
		
	} else {
		
		M = peak_valley(K, H, W, X, N);	
		
	}

	//----------------------------------------------
	// OUTPUT
	//----------------------------------------------

	// NOTE: we reuse the double pointer
	
	//--
	// output extrema indices
	//--
	
	X = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1,M,mxREAL));
		
	for (k = 0; k < M; k++) {
		*(X + k) = (double) *(K + k);
	}
	
	mxFree(K);
	
	//--
	// output extrema heights
	//--
	
	if (nlhs > 1) {
		
		X = mxGetPr(plhs[1] = mxCreateDoubleMatrix(2,M,mxREAL));
		
		for (k = 0; k < 2*M; k++) {
			*(X + k) = *(H + k);
		}
		
		mxFree(H);
		
	}
	
	//--
	// output extrema widths
	//--
			
	if (nlhs > 2) {
		
		X = mxGetPr(plhs[2] = mxCreateDoubleMatrix(2,M,mxREAL));
		
		for (k = 0; k < 2*M; k++) {
			*(X + k) = *(W + k);
		}
		
		mxFree(W);
		
	}
	
}
