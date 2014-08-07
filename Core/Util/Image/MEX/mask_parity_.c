//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------

// C

#include "stdlib.h"
#include "math.h"

// Matlab
 
#include "mex.h"
#include "matrix.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

// mask_parity - create a parity based mask
// ----------------------------------------
// 
// mask_parity(Y,m,n,t)
//
// Input:
// ------
//  m, n - number of rows and columns
//  t - type of mask
//
// Output:
// -------
//  Y - mask image

// IMPORTANT:
// ----------
//  Even and odd here are considered for 1 based indexing.
//  Everything is shifted so all parities are reversed.

void mask_parity (unsigned char *Y, int m, int n, int t);
	
void mask_parity (unsigned char *Y, int m, int n, int t)
	
{

	int i, j;
	
	switch (t) {
	
		//--
		// even row, even col
		//--

		case 0:
		
			for (j = 1; j < n; j = j + 2) {
			for (i = 1; i < m; i = i + 2) {
				*(Y + i + j*m) = 1;
			}
			}
			
			break;
		
		//--
		// odd row, even col
		//--
		
		case 1:
		
			for (j = 1; j < n; j = j + 2) {
			for (i = 0; i < m; i = i + 2) {
				*(Y + i + j*m) = 1;
			}
			}
			
			break;
		
		//--
		// even row, odd col
		//--
		
		case 2:
		
			for (j = 0; j < n; j = j + 2) {
			for (i = 1; i < m; i = i + 2) {
				*(Y + i + j*m) = 1;
			}
			}
			
			break;
		
		//--
		// odd row, odd col
		//--

		case 3:
		
			for (j = 0; j < n; j = j + 2) {
			for (i = 0; i < m; i = i + 2) {
				*(Y + i + j*m) = 1;
			}
			}
			
			break;
		
		//--
		// all row, odd col
		//--

		case 4:
		
			for (j = 0; j < n; j = j + 2) {
			for (i = 0; i < m; i++) {
				*(Y + i + j*m) = 1;
			}
			}
			
			break;
		
		//--
		// all row, even col
		//--

		case 5:
		
			for (j = 1; j < n; j = j + 2) {
			for (i = 0; i < m; i++) {
				*(Y + i + j*m) = 1;
			}
			}
			
			break;
		
		//--
		// odd row, all col
		//--

		case 6: 
		
			for (j = 0; j < n; j++) {
			for (i = 0; i < m; i = i + 2) {
				*(Y + i + j*m) = 1;
			}
			}
			
			break;
		
		//--
		// even row, all col
		//--

		case 7:
		
			for (j = 0; j < n; j++) {
			for (i = 1; i < m; i = i + 2) {
				*(Y + i + j*m) = 1;
			}
			}
			
			break;
			
		// checker pattern 1
		
		// checker pattern 2
		
	}

}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	unsigned char *Y;

	int d[2];
	
	int m, n, t;

	double *ptr;
						
	//--
	// INPUT
	//--
  		
	// get size 
		
	ptr = mxGetPr(prhs[0]);
	  	
	m = (int) *ptr;
	n = (int) *(ptr + 1);
	  		  	
	// get type
	  	
	t = (int) mxGetScalar(prhs[1]);
								
	//--
  	// OUTPUT 
  	//--
  		
	// mask

	*d = m;
	*(d + 1) = n;
  		
  	Y = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
	  		  		  	
  	//--
  	// COMPUTATION
  	//--
  		  	
	mask_parity(Y, m, n, t);
	  		

}
