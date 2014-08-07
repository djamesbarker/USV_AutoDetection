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

// mask_range_double - create value range mask
// -------------------------------------------
// 
// Input:
// ------
//   *X - image (double *, m * n)
//   m,n - rows and columns of image (int)
//   *b - interval range (double *, 2)
//   t - interval type (int)
//
// Output:
// -------
//   *Y - mask image (unsigned char *, m * n)

void mask_range_double (
	unsigned char *Y, double *X, int m, int n, double *b, int t);
	
void mask_range_double (
	unsigned char *Y, double *X, int m, int n, double *b, int t)
	
{

	register int i, j, ij;
	
	register double l, u, x;
	
	//--
	// get bounds
	//--

	l = *b;
	u = *(b + 1);
	
	//--
	// create mask
	//--

	switch (t) {
	
		//--
		// open
		//--
		
		case 0:
		
			for (j = 0; j < n; j++) {
			for (i = 0; i < m; i++) {
				ij = i + j*m;
				x = *(X + ij);
				*(Y + ij) = (x > l) && (x < u);
			}
			}
			
			break;
		
		//--
		// closed above
		//--

		case 1:
		
			for (j = 0; j < n; j++) {
			for (i = 0; i < m; i++) {
				ij = i + j*m;
				x = *(X + ij);
				*(Y + ij) = (x > l) && (x <= u);
			}
			}
			
			break;
		
		//--
		// closed below
		//--

		case 2:
		
			for (j = 0; j < n; j++) {
			for (i = 0; i < m; i++) {
				ij = i + j*m;
				x = *(X + ij);
				*(Y + ij) = (x >= l) && (x < u);
			}
			}
			
			break;
		
		//--
		// closed
		//--

		case 3:
		
			for (j = 0; j < n; j++) {
			for (i = 0; i < m; i++) {
				ij = i + j*m;
				x = *(X + ij);
				*(Y + ij) = (x >= l) && (x <= u);
			}
			}
					
	}

}

//
// mask_range_uint8 - create value range mask
// -------------------------------------------
// 
// Input:
// ------
//   *X - image (unsigned char *, m * n)
//   m,n - rows and columns of image (int)
//   *b - interval range (double *, 2)
//   t - interval type (int)
//
// Output:
// -------
//   *Y - mask image (unsigned char *, m * n)
//

void mask_range_uint8 (
	unsigned char *Y, unsigned char *X, int m, int n, double *b, int t);
	
void mask_range_uint8 (
	unsigned char *Y, unsigned char *X, int m, int n, double *b, int t)
	
{

	register int i, j, ij;
	
	register double l, u;
	
	register unsigned char x;
	
	//--
	// get bounds
	//--

	l = *b;
	u = *(b + 1);
	
	//--
	// create mask
	//--

	switch (t) {
	
		//--
		// open
		//--
		
		case 0:
		
			for (j = 0; j < n; j++) {
			for (i = 0; i < m; i++) {
				ij = i + j*m;
				x = *(X + ij);
				*(Y + ij) = (x > l) && (x < u);
			}
			}
			
			break;
		
		//--
		// closed above
		//--

		case 1:
		
			for (j = 0; j < n; j++) {
			for (i = 0; i < m; i++) {
				ij = i + j*m;
				x = *(X + ij);
				*(Y + ij) = (x > l) && (x <= u);
			}
			}
			
			break;
		
		//--
		// closed below
		//--

		case 2:
		
			for (j = 0; j < n; j++) {
			for (i = 0; i < m; i++) {
				ij = i + j*m;
				x = *(X + ij);
				*(Y + ij) = (x >= l) && (x < u);
			}
			}
			
			break;
		
		//--
		// closed
		//--

		case 3:
		
			for (j = 0; j < n; j++) {
			for (i = 0; i < m; i++) {
				ij = i + j*m;
				x = *(X + ij);
				*(Y + ij) = (x >= l) && (x <= u);
			}
			}
					
	}

}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	unsigned char *Y;
	
	unsigned char *X8;
	double *X;
	
	double *b;
		
	int m, n, t, d[2];
						
	//--
	// INPUT
	//--
  		
  	// get image
  		
	if (mxIsUint8(prhs[0])) {

	 	X8 = (unsigned char *) mxGetPr(prhs[0]);

	} else if (mxIsDouble(prhs[0])) {

		X = mxGetPr(prhs[0]);

	}
	  		
	m = mxGetM(prhs[0]);
	n = mxGetN(prhs[0]);
	  		
	// get interval bounds
	  	
	b = mxGetPr(prhs[1]); 
	  	 	
	// get type
	  	
	t = (int) mxGetScalar(prhs[2]);
								
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
  		
  	if (mxIsUint8(prhs[0])) {

		mask_range_uint8(Y, X8, m, n, b, t);

	} else if (mxIsDouble(prhs[0])) {

	  	mask_range_double(Y, X, m, n, b, t);

	}  		  		

}
