//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------

//--
// C
//--

#include "stdlib.h"
#include "math.h"

//--
// Matlab
//--
 
#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

// hist_2d_256 - special 256 bin 2d histogram computation
// ------------------------------------------------------
// 
// Input:
// ------
//  X1,X2 - input data 
//  N - length of data
//  Z - computation mask
//
// Output:
// -------
//  H - bin counts 
//  c1,c2 - bin centers
//  v1,v2 - bin breaks

void hist_2d_256 (
	register double *H, register double *c1, register double *c2,
	register double *v1, register double *v2,
	register unsigned char *X1, register unsigned char *X2, int N,
	register unsigned char *Z
);

void hist_2d_256 (
	register double *H, register double *c1, register double *c2,
	register double *v1, register double *v2,
	register unsigned char *X1, register unsigned char *X2, int N,
	register unsigned char *Z
)

{
	
	register double tmp;
	
	register int k;

	//--
	// compute bin centers
	//--
	
	tmp = 0.0;	

	for (k = 0; k < 256; k++) {
		*(c1 + k) = tmp;
		*(c2 + k) = tmp++;
	}
	
	//--
	// compute bin breaks
	//--
	
	tmp = -0.5;	

	for (k = 0; k <= 256; k++) {
		*(v1 + k) = tmp;
		*(v2 + k) = tmp++;
	}
	
	//--
	// FULL HISTOGRAM
	//--
	
	if (Z == NULL) {

		for (k = 0; k < N; k++) {
			*(H + *(X2 + k) + *(X1 + k)*256) += 1.0;
		}
		
	//--
	// MASKED HISTOGRAM
	//--

	} else {

		for (k = 0; k < N; k++) {
			if (*(Z + k)) {
				*(H + *(X2 + k) + *(X1 + k)*256) += 1.0;
			}
		}
	
	}
	
}

// hist_2d_uint8 - 2d histogram computation
// ----------------------------------------
// 
// Input:
// ------
//  X1,X2 - input data 
//  N - length of arrays
//  n1,n2 - number of bins
//  a1,b1,a2,b2 - value bounds
//  Z - computation mask
//
// Output:
// -------
//  H - bin counts 
//  c1,c2 - bin centers 
//  v1,v2 - bin breaks

void hist_2d_uint8 (
	register double *H,
	register double *c1, register double *c2, register double *v1, register double *v2,
	register unsigned char *X1, register unsigned char *X2, int N,
	int n1, int n2, double a1, double b1, double a2, double b2,
	unsigned char *Z
);
	
void hist_2d_uint8 (
	register double *H,
	register double *c1, register double *c2, register double *v1, register double *v2,
	register unsigned char *X1, register unsigned char *X2, int N,
	int n1, int n2, double a1, double b1, double a2, double b2,
	unsigned char *Z
)

{	
	
	register double d1, d2, f1, f2, tmp;
	
	register int i, j, k;	
	
	//--
	// compute bin size and scaling factor
	//--
	
	d1 = (b1 - a1) / (n1 - 1);
	d2 = (b2 - a1) / (n2 - 1);
	
	f1 = n1 / ((b1 - a1) + d1);
	f2 = n2 / ((b2 - a2) + d2);
	
	//--
	// bin centers
	//--

	tmp = a1;
	
	for (k = 0; k < n1; k++) {
		*(c1 + k) = tmp;
		tmp += d1;
	}

	tmp = a2;
	
	for (k = 0; k < n2; k++) {
		*(c2 + k) = tmp;
		tmp += d2;
	}
	
	//--
	// bin breaks
	//--
	
	tmp = a1 - (0.5 * d1);
	
	for (k = 0; k <= n1; k++) {
		*(v1 + k) = tmp;
		tmp += d1;
	}
	
	tmp = a2 - (0.5 * d2);
	
	for (k = 0; k <= n2; k++) {
		*(v2 + k) = tmp;
		tmp += d2;
	}
	
	//--
	// reset lower limits
	//--
	
	a1 -= 0.5 * d1;
	a2 -= 0.5 * d2;
	
	//--
	// FULL HISTOGRAM
	//--
	
	if (Z == NULL) {

		for (k = 0; k < N; k++) {
		
			i = (int) ((*(X2 + k) - a2) * f2);
			j = (int) ((*(X1 + k) - a1) * f1);
			
			if ((i <= n2) && (i > -1) && (j <= n1) && (j > -1)) {
				if (i == n2) i--;
				if (j == n1) j--;
				*(H + i + j*n2) += 1.0;
			}
			
		}
	
	//--
	// MASKED HISTOGRAM
	//--

	} else { 

		for (k = 0; k < N; k++) {

			if (*(Z + k)) {

				i = (int) ((*(X2 + k) - a2) * f2);
				j = (int) ((*(X1 + k) - a1) * f1);

				if ((i <= n2) && (i > -1) && (j <= n1) && (j > -1)) {
					if (i == n2) i--;
					if (j == n1) j--;
					*(H + i + j*n2) += 1.0;
				}

			} 

		}
	
	}
				
}

// hist_2d_double - 2d histogram computation
// -----------------------------------------
// 
// Input:
// ------
//  X1,X2 - input data 
//  N - length of arrays
//  n1,n2 - number of bins
//  a1,b1,a2,b2 - value bounds
//  Z - computation mask
//
// Output:
// -------
//  H - bin counts 
//  c1,c2 - bin centers 
//  v1,v2 - bin breaks

void hist_2d_double (
	register double *H,
	register double *c1, register double *c2, register double *v1, register double *v2,
	register double *X1, register double *X2, int N,
	int n1, int n2, double a1, double b1, double a2, double b2,
	unsigned char *Z
);
	
void hist_2d_double (
	register double *H,
	register double *c1, register double *c2, register double *v1, register double *v2,
	register double *X1, register double *X2, int N,
	int n1, int n2, double a1, double b1, double a2, double b2,
	unsigned char *Z
)

{	
	
	register double d1, d2, f1, f2, tmp;
	
	register int i, j, k;	
	
	//--
	// compute bin size and scaling factor
	//--
	
	d1 = (b1 - a1) / (n1 - 1);
	d2 = (b2 - a1) / (n2 - 1);
	
	f1 = n1 / ((b1 - a1) + d1);
	f2 = n2 / ((b2 - a2) + d2);
	
	//--
	// bin centers
	//--

	tmp = a1;
	
	for (k = 0; k < n1; k++) {
		*(c1 + k) = tmp;
		tmp += d1;
	}

	tmp = a2;
	
	for (k = 0; k < n2; k++) {
		*(c2 + k) = tmp;
		tmp += d2;
	}
	
	//--
	// bin breaks
	//--
	
	tmp = a1 - (0.5 * d1);
	
	for (k = 0; k <= n1; k++) {
		*(v1 + k) = tmp;
		tmp += d1;
	}
	
	tmp = a2 - (0.5 * d2);
	
	for (k = 0; k <= n2; k++) {
		*(v2 + k) = tmp;
		tmp += d2;
	}
	
	//--
	// reset lower limits
	//--
	
	a1 -= 0.5 * d1;
	a2 -= 0.5 * d2;
	
	//--
	// FULL HISTOGRAM
	//--
	
	if (Z == NULL) {

		for (k = 0; k < N; k++) {

			i = (int) ((*(X2 + k) - a2) * f2);
			j = (int) ((*(X1 + k) - a1) * f1);
			
			if ((i <= n2) && (i > -1) && (j <= n1) && (j > -1)) {
				if (i == n2) i--;
				if (j == n1) j--;
				*(H + i + j*n2) += 1.0;
			}
			
		}
	
	//--
	// MASKED HISTOGRAM
	//--

	} else { 

		for (k = 0; k < N; k++) {

			if (*(Z + k)) {

				i = (int) ((*(X2 + k) - a2) * f2);
				j = (int) ((*(X1 + k) - a1) * f1);

				if ((i <= n2) && (i > -1) && (j <= n1) && (j > -1)) {
					if (i == n2) i--;
					if (j == n1) j--;
					*(H + i + j*n2) += 1.0;
				}

			} 

		}
	
	}
				
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// hist_2d_ - 2d histogram computation
// -----------------------------------
//
// [H,c1,c2,v1,v2] = hist_2d_(X1,X2,n1,n2,b1,b2,Z)
//
// Input:
// ------
//  X1,X2 - input data
//  n1,n2 - number of bins
//  b1,b2 - value bounds
//  Z - computation mask
//
// Output:
// -------
//  H - bin counts
//  c1,c2 - bin centers
//  v1,v2 - bin breaks

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
		
	unsigned char *X81, *X82; double *X1, *X2; int mX, nX;
	
	int  n1, n2;
	
	double *tmp, a1, b1, a2, b2;
	
	unsigned char *Z;
	
	double *H, *c1, *c2, *v1, *v2;
			  
  	//--
	// UINT8 images
	//--

	if (mxIsUint8(prhs[0])) {
	
		//--
	  	// INPUT
	  	//--
	  	
		// input data arrays

	  	X1 = (double *) mxGetPr(prhs[0]);
	  		
	  	mX = mxGetM(prhs[0]);
	  	nX = mxGetN(prhs[0]);

	  	X2 = (double *) mxGetPr(prhs[1]);
	  		
		if ((mX != mxGetM(prhs[1])) || (nX != mxGetN(prhs[1]))) {
	  		mexErrMsgTxt("Input images must be of same size.");
	  	}
  	
	  	// number of bins
	  	
	  	n1 = (int) mxGetScalar(prhs[2]);
	  	n2 = (int) mxGetScalar(prhs[3]);
	  	
	  	// value bounds
	  	
	  	tmp = mxGetPr(prhs[4]);
		a1 = *tmp;
		b1 = *(tmp + 1);

	  	tmp = mxGetPr(prhs[5]);
		a2 = *tmp;
		b2 = *(tmp + 1);
	  	
	  	// computation mask
	  							
		if (nrhs > 6) {
		
			// default full computation

			if (mxIsEmpty(prhs[6])) {
			
		  		Z = NULL;
		  		
		  	} else {
		  	
				// get mask and check size

			  	if (mxIsUint8(prhs[6])) {
			  		Z = (unsigned char *) mxGetPr(prhs[6]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class uint8.");
			  	}
			  	
			  	if ((mX != mxGetM(prhs[6])) || (nX != mxGetN(prhs[6]))) {
					mexErrMsgTxt("Image and mask must be of the same size.");
				}
				
			}
		  	
		// default full computation

		} else {
			Z = NULL;
		}
	  	  	
		//--
  		// OUTPUT
  		//--
				
		// bin counts
				
		H = mxGetPr(plhs[0] = mxCreateDoubleMatrix(n2, n1, mxREAL));
		
		// bin centers
		
		c1 = mxGetPr(plhs[1] = mxCreateDoubleMatrix(1, n1, mxREAL));
		c2 = mxGetPr(plhs[2] = mxCreateDoubleMatrix(1, n2, mxREAL));
		
		// bin breaks
		
		v1 = mxGetPr(plhs[3] = mxCreateDoubleMatrix(1, n1 + 1, mxREAL));
		v2 = mxGetPr(plhs[4] = mxCreateDoubleMatrix(1, n2 + 1, mxREAL));
		
		//--
		// COMPUTATION
		//--
	
		if ((n1 == 256) && (n2 == 256)) {

			hist_2d_256 (
				H, c1, c2, v1, v2,
				X81, X82, mX*nX,
				Z
			);

		} else {

			hist_2d_uint8 (
				H, c1, c2, v1, v2,
				X81, X82, mX*nX, 
				n1, n2, a1, b1, a2, b2,
				Z
			);

		}

	//--
	// DOUBLE images
	//--

	} else {

		//--
	  	// INPUT
	  	//--
	  	
		// input data arrays

	  	X1 = mxGetPr(prhs[0]);
	  		
	  	mX = mxGetM(prhs[0]);
	  	nX = mxGetN(prhs[0]);

	  	X2 = mxGetPr(prhs[1]);
	  		
		if ((mX != mxGetM(prhs[1])) || (nX != mxGetN(prhs[1]))) {
	  		mexErrMsgTxt("Input images must be of same size.");
	  	}
  	
	  	// number of bins
	  	
	  	n1 = (int) mxGetScalar(prhs[2]);
	  	n2 = (int) mxGetScalar(prhs[3]);
	  	
	  	// value bounds
	  	
	  	tmp = mxGetPr(prhs[4]);
		a1 = *tmp;
		b1 = *(tmp + 1);

	  	tmp = mxGetPr(prhs[5]);
		a2 = *tmp;
		b2 = *(tmp + 1);
	  	
	  	// computation mask
	  							
		if (nrhs > 6) {
		
			// default full computation

			if (mxIsEmpty(prhs[6])) {
			
		  		Z = NULL;
		  		
		  	} else {
		  	
				// get mask and check size

			  	if (mxIsUint8(prhs[6])) {
			  		Z = (unsigned char *) mxGetPr(prhs[6]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class uint8.");
			  	}
			  	
			  	if ((mX != mxGetM(prhs[6])) || (nX != mxGetN(prhs[6]))) {
					mexErrMsgTxt("Image and mask must be of the same size.");
				}
				
			}
		  	
		// default full computation

		} else {
			Z = NULL;
		}
	  	  	
		//--
  		// OUTPUT
  		//--
				
		// bin counts
				
		H = mxGetPr(plhs[0] = mxCreateDoubleMatrix(n2, n1, mxREAL));
		
		// bin centers
		
		c1 = mxGetPr(plhs[1] = mxCreateDoubleMatrix(1, n1, mxREAL));
		c2 = mxGetPr(plhs[2] = mxCreateDoubleMatrix(1, n2, mxREAL));
		
		// bin breaks
		
		v1 = mxGetPr(plhs[3] = mxCreateDoubleMatrix(1, n1 + 1, mxREAL));
		v2 = mxGetPr(plhs[4] = mxCreateDoubleMatrix(1, n2 + 1, mxREAL));
		
		//--
		// COMPUTATION
		//--

		hist_2d_double (
			H, c1, c2, v1, v2,
			X1, X2, mX*nX,
			n1, n2, a1, b1, a2, b2,
			Z
		);

	}
		
}    

