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

// min_vec - min of vector
// -----------------------
//
// Input:
// ------
//  *x - vector
//   n - length of vector
//
// Output:
// -------
//  m - min

double min_vec (double *x, int n);

double min_vec (double *x, int n) {

	register int k;

	double *ptr;
	
	register double m, t;
	
	m = *x;
	ptr = x;
	
	for (k = 0; k < n; k++) {
		if ((t = *ptr++) < m) {
			m = t;
		} 
	}
	
	return (m);

}

// max_vec - max of vector
// -----------------------
//
// Input:
// ------
//  *x - vector
//   n - length of vector
//
// Output:
// -------
//  M - max

int max_vec (double *x, int n);

int max_vec (double *x, int n) {

	register int k;
	
	double *ptr;
	
	register double M, t;
	
	M = *x;
	ptr = x;
	
	for (k = 0; k < n; k++) {
		if ((t = *ptr++) > M) {
			M = t;
		} 
	}
	
	return (M);

}

// mask_separable - mask for given row and column indexes
// ------------------------------------------------------
//
// Input:
// ------
//   m, n - rows and columns
//  *r, rl - row indexes and length
//  *c, cl - column indexes and length
//
// Output:
// -------
//  *Y - mask image

void mask_separable (
	unsigned char *Y, int m, int n,
	double *r, int rl, double *c, int cl
);
	
void mask_separable (
	unsigned char *Y, int m, int n,
	double *r, int rl, double *c, int cl
)
	
{

	register int i, j;
	
	for (j = 0; j < cl; j++) {
	for (i = 0; i < rl; i++) {
		*(Y + ((int) *(r + i)) + ((int) *(c + j)) * m) = 1;
	}
	}
			
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	unsigned char *Y;
	int d[2];
	
	double *ptr;
	int m, n;
	
	double *r, *c;
	int rl, cl;
						
	//--
	// INPUT
	//--
  		
	// get size 
		
	ptr = mxGetPr(prhs[0]);
	m = (int) *ptr;
	n = (int) *(ptr + 1);
	  		  	
	// get rows and columns
	  	
	r = mxGetPr(prhs[1]);
	rl = mxGetM(prhs[1]) * mxGetN(prhs[1]);
	  	
	c = mxGetPr(prhs[2]);
	cl = mxGetM(prhs[2]) * mxGetN(prhs[2]);
									
	// check index bounds
		
	if ((min_vec(r,rl) < 0) || (max_vec(r,rl) >= m)) {
		mexErrMsgTxt("Row indexes out of bounds.");
	}
		
	if ((min_vec(c,cl) < 0) || (max_vec(c,cl) >= n)) {
		mexErrMsgTxt("Column indexes out of bounds.");
	}						
		
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
  		  	
	mask_separable(Y, m, n, r, rl, c, cl);
	  		
}
