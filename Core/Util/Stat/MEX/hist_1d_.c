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

// hist_1d_256 - special 256 bin 1d histogram computation
// ------------------------------------------------------
// 
// Input:
// ------
//  X - input data 
//  N - length of data
//  Z - computation mask
//
// Output:
// -------
//  h - histogram 
//  c - bin centers
//  v - bin breaks

void hist_1d_256 (
	register double *h, register double *c, register double *v,
	register unsigned char *X, int N,
	register unsigned char *Z
);

void hist_1d_256 (
	register double *h, register double *c, register double *v,
	register unsigned char *X, int N,
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
		*(c + k) = (double) tmp++;
	}
	
	//--
	// compute bin breaks
	//--
	
	tmp = -0.5;	

	for (k = 0; k <= 256; k++) {
		*(v + k) = tmp++;
	}
	
	//--
	// FULL HISTOGRAM
	//--
	
	if (Z == NULL) {

		for (k = 0; k < N; k++) {
			*(h + *(X + k)) += 1.0;
		}
		
	//--
	// MASKED HISTOGRAM
	//--

	} else {

		for (k = 0; k < N; k++) {
			if (*(Z + k)) {
				*(h + *(X + k)) += 1.0;
			}
		}
	
	}
	
}

// hist_1d_uint8 - 1d histogram computation
// ----------------------------------------
// 
// Input:
// ------
//  X - input data
//  N - length of input data
//  n - number of bins
//  a,b - value bounds
//
// Output:
// -------
//  h - bin counts
//  c - bin centers 
//  v - bin breaks

void hist_1d_uint8 (
	register double *h, register double *c, register double *v,
	register unsigned char *X, int N, int n, double a, double b,
	register unsigned char *Z
);
	
void hist_1d_uint8 (
	register double *h, register double *c, register double *v,
	register unsigned char *X, int N, int n, double a, double b,
	register unsigned char *Z
)

{	
	
	register double d, f, tmp;
	
	register int i, k;	
	
	//--
	// compute bin size and scaling factor
	//--

	d = (b - a) / (n - 1);

	f = n / ((b - a) + d);
	
	//--
	// bin centers
	//--
	
	tmp = a;	

	for (k = 0; k < n; k++) {
		*(c + k) = tmp;
		tmp += d;
	}
	
	//--
	// bin breaks
	//--
	
	tmp = a - (0.5 * d);
	
	for (k = 0; k <= n; k++) {
		*(v + k) = tmp;
		tmp += d;
	}

	//--
	// update lower bound
	//--

	a -= 0.5 * d;
	
	//--
	// FULL HISTOGRAM
	//--
		
	if (Z == NULL) {

		for (k = 0; k < N; k++) {

			i = (int) ((*(X + k) - a) * f);

			if ((i < n) && (i > -1)) {
				*(h + i) += 1.0;
			} else if (i == n) {
				*(h + i - 1) += 1.0;
			}

		}
	
	//--
	// MASKED HISTOGRAM
	//--

	} else {

		for (k = 0; k < N; k++) {

			if (*(Z + k)) {

				i = (int) ((*(X + k) - a) * f);

				if ((i < n) && (i > -1)) {
					*(h + i) += 1.0;
				} else if (i == n) {
					*(h + i - 1) += 1.0;
				}

			} 

		}
	
	}
				
}

// hist_1d_double - 1d histogram computation
// -----------------------------------------
// 
// Input:
// ------
//  X - pointer data array
//  N - length of array
//  n - number of bins
//  a,b - value bounds
//  Z - computation mask
//
// Output:
// -------
//  h - bin counts
//  c - bin centers
//  v - bin breaks

void hist_1d_double (
	register double *h, register double *c, register double *v,
	register double *X, int N, int n, double a, double b,
	register unsigned char *Z
);
	
void hist_1d_double (
	register double *h, register double *c, register double *v,
	register double *X, int N, int n, double a, double b,
	register unsigned char *Z
)

{	
	
	register double d, f, tmp;
		
	register int i, k;	
	
	//--
	// compute bin size and scaling factor
	//--

	d = (b - a) / (n - 1);

	f = n / ((b - a) + d);
	
	//--
	// bin centers
	//--
	
	tmp = a;
	
	for (k = 0; k < n; k++) {
		*(c + k) = tmp;
		tmp += d;
	}
	
	//--
	// bin breaks
	//--
	
	tmp = a - (0.5 * d);
	
	for (k = 0; k <= n; k++) {
		*(v + k) = tmp;
		tmp += d;
	}
	
	//--
	// update lower bound
	//--
	
	a -= 0.5 * d;
	
	//--
	// FULL HISTOGRAM
	//--
		
	if (Z == NULL) {

		for (k = 0; k < N; k++) {

			i = (int) ((*(X + k) - a) * f);

			if ((i < n) && (i > -1)) {
				*(h + i) += 1.0;
			} else if (i == n) {
				*(h + i - 1) += 1.0;
			}
		}
		
	//--
	// MASKED HISTOGRAM
	//--

	} else {
	
		for (k = 0; k < N; k++) {

			if (*(Z + k)) {

				i = (int) ((*(X + k) - a) * f);

				if ((i < n) && (i > -1)) {
					*(h + i) += 1.0;
				} else if (i == n) {
					*(h + i - 1) += 1.0;
				}

			} 

		}
	
	}
				
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// hist_1d_ - 1d histogram computation
// -----------------------------------
//
// [H,c,v] = hist_2d_(X,n,b,Z)
//
// Input:
// ------
//  X - input data
//  n - number of bins
//  b - value bounds
//  Z - computation mask
//
// Output:
// -------
//  H - bin counts
//  c - bin centers
//  v - bin breaks

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
		
	unsigned char *X8; double *X; int mX, nX;
	
	int n; double *tmp, a, b;

	unsigned char *Z;
	
	double *h, *c, *v;
			  
  	//--
	// UINT8 image
	//--
		  
  	if (mxIsUint8(prhs[0])) {

		//--
		// INPUT
		//--

		// input data

  		X8 = (unsigned char *) mxGetPr(prhs[0]);

		mX = mxGetM(prhs[0]);
		nX = mxGetN(prhs[0]);
  		
		// number of bins
	  	
		n = (int) mxGetScalar(prhs[1]);

		// get value bounds
	  	
		tmp = mxGetPr(prhs[2]);
		a = *tmp;
		b = *(tmp + 1);
	  	
		// get mask
		  							
		if (nrhs > 3) {
			
			// default full computation
	
			if (mxIsEmpty(prhs[3])) {
				
		  		Z = NULL;
			
			// get mask and check size
		
			} else {
			  	
			  	if (mxIsUint8(prhs[3])) {
			  		Z = (unsigned char *) mxGetPr(prhs[3]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class uint8.");
			  	}
				  	
			  	if ((mX != mxGetM(prhs[3])) || (nX != mxGetN(prhs[3]))) {
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
		
		h = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1, n, mxREAL));
			
		// bin centers
	
		c = mxGetPr(plhs[1] = mxCreateDoubleMatrix(1, n, mxREAL));
			
		// bin breaks
		
		v = mxGetPr(plhs[2] = mxCreateDoubleMatrix(1, (n + 1), mxREAL));
		
		//--
		// COMPUTATION
		//--

		if (n == 256) {
	
			hist_1d_256 (
				h, c, v,
				X8, (mX * nX),
				Z
			);
	
		} else {
	
			hist_1d_uint8 (
				h, c, v,
				X8, (mX * nX),
				n, a, b,
				Z
			);
	
		}

	//--
	// DOUBLE image
	//--

	} else {

		//--
		// INPUT
		//--

		// input data

  		X = mxGetPr(prhs[0]);
  		
		mX = mxGetM(prhs[0]);
		nX = mxGetN(prhs[0]);
  		
		// number of bins
	  	
		n = (int) mxGetScalar(prhs[1]);

		// value bounds
	  	
		tmp = mxGetPr(prhs[2]);
		a = *tmp;
		b = *(tmp + 1);
	  	
		// get mask
		  							
		if (nrhs > 3) {
			
			// default full computation
	
			if (mxIsEmpty(prhs[3])) {
				
		  		Z = NULL;
			
			// get mask and check size
		
			} else {
			  	
			  	if (mxIsUint8(prhs[3])) {
			  		Z = (unsigned char *) mxGetPr(prhs[3]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class uint8.");
			  	}
				  	
			  	if ((mX != mxGetM(prhs[3])) || (nX != mxGetN(prhs[3]))) {
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
		
		h = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1, n, mxREAL));
			
		// bin centers
	
		c = mxGetPr(plhs[1] = mxCreateDoubleMatrix(1, n, mxREAL));
			
		// bin breaks
		
		v = mxGetPr(plhs[2] = mxCreateDoubleMatrix(1, (n + 1), mxREAL));
		
		//--
		// COMPUTATION
		//--
		
		hist_1d_double (
			h, c, v,
			X, (mX * nX),
			n, a, b,
			Z
		);

	}
		
}    

