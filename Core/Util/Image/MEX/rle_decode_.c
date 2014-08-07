//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
	
#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

// rle_decode - run-length decoding
// --------------------------------
// 
// Input:
// ------
//  rle - run-length encoding
//  N - length of encoding
//
// Output:
// -------
//  X - output image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void rle_decode (
	double *X,
	int state, double *rle, int N);
	
void rle_decode (
	double *X,
	int state, double *rle, int N)

{
	
	register int i, j;
	
	register double *ptr = X;
		
	// NOTE: the output array is initialized to zero
	
	for (i = 0; i < N; i++) {
		
		if (state) {
			
			for (j = 0; j < *(rle + i); j++) {
				*ptr++ = 1.0;
			}
			
			state = 0;
			
		} else {
			
			ptr = ptr + ((int) *(rle + i));
			
			state = 1;
			
		}
				
	}
	
}

// rle_decode_label - run-length decoding and labelling
// ----------------------------------------------------
// 
// Input:
// ------
//  rle - run-length encoding
//  N - length of encoding
//  L - label look-up table
//  P - length of table
//
// Output:
// -------
//  X - labelled output image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void rle_decode_label (
	double *X,
	int state, double *rle, int N, double *L, int P);
	
void rle_decode_label (
	double *X,
	int state, double *rle, int N, double *L, int P)

{
	
	register int i, j, run;
	
	register double *ptr = X;
	
	register double label;
		
	// NOTE: the output array is initialized to zero
	
	//--
	// each run has a separate label, this is the most general labelling
	//--
	
	// NOTE: the table is assumed to be the same length as run-length code
	
	if (P == 0) {
		
		for (i = 0; i < N; i++) {

			label = *(L + i);

			for (j = 0; j < *(rle + i); j++) {
				*ptr++ = label;
			}

		}
		
	//--
	// labels are based on run-length and state
	//--
		
	// NOTE: one runs as long and longer than the table get the same label
		
	} else {
	
		for (i = 0; i < N; i++) {
			
			if (state) {

				run = (int) *(rle + i);
				
				// NOTE: there is an index offset in this assignment
				
				if (run > (P - 1)) {
					label = *(L + P - 1); 
				} else {
					label = *(L + run - 1);
				}
								
				for (j = 0; j < run; j++) {
					*ptr++ = label;
				}
				
				state = 0;

			} else {

				// NOTE: zeros are not labelled and are decoded as zeros
				
				ptr = ptr + ((int) *(rle + i));
				
				state = 1;

			}

		}
		
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// rle_decode_ - run-length decoding
// ---------------------------------
//
// X = rle_decode(m,n,state,rle);
//
// Input:
// ------
//  m  - number of rows in decoded image
//  n  - number of columns in decoded image
//  state - initial state of decoder
//  rle - run -length encoding 
//
// Output:
// -------
//  X - decoded image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	register int m, n, state, N, P, direct;
	
	register double *rle, *X, *T;
		
	//-----------------------
	// INPUT
	//-----------------------

	//--
	// run-length code
	//--
	
	rle = mxGetPr(prhs[0]);

	// size of image

	m = *(rle);

	n = *(rle + 1);

	// initial state of decoder

	state = (int) *(rle + 2);

	// run-length encoding

	rle = rle + 3;

	N = mxGetM(prhs[0]) * mxGetN(prhs[0]) - 3;
	
	//-----------------------
	// OUTPUT 
	//-----------------------

	// decoded image
	
	X = mxGetPr(plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL));
  	
	//--
	// COMPUTATION
	//--

	if (nrhs < 2) {
		
		//--
		// run-length decode
		//--
		
		rle_decode (X, state, rle, N);
		
	} else {
		
		//--
		// get label table and table type
		//--
		
		T = mxGetPr(prhs[1]);
		
		P = mxGetM(prhs[1]) * mxGetN(prhs[1]);
		
		direct = (int) mxGetScalar(prhs[2]);
		
		// check length of table if each run has a direct label
		
		if (direct && (N != P)) {
			mexErrMsgTxt("Table length must match run-length code length.");
		}
		
		//--
		// run-length decoding and labelling
		//--
		
		if (direct) {
			rle_decode_label(X, state, rle, N, T, 0);
		} else {
			rle_decode_label(X, state, rle, N, T, P);
		}
		
	}
		
}
