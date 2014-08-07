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

void image_mask_uint8 (
	unsigned char *Y,
	unsigned char *X1, unsigned char *X2, unsigned char *Z, int n
);

void image_mask_uint8 (
	unsigned char *Y,
	unsigned char *X1, unsigned char *X2, unsigned char *Z, int n
)

{

	register int k;
	
	for (k = 0; k < n; k++) {

		if (*(Z + k)) {
			*(Y + k) = *(X1 + k);
		} else {
			*(Y + k) = *(X2 + k);
		}
		
	}
	
}  

void image_mask_double (
	double *Y,
	double *X1, double *X2, unsigned char *Z, int n
);

void image_mask_double (
	double *Y,
	double *X1, double *X2, unsigned char *Z, int n
)

{

	register int k;
	
	for (k = 0; k < n; k++) {

		if (*(Z + k)) {
			*(Y + k) = *(X1 + k);
		} else {
			*(Y + k) = *(X2 + k);
		}
		
	}
	
}  

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
		
	unsigned char *Y8, *X18, *X28;

	double *Y, *X1, *X2;
	
	int n1, n2, d[2];
	
	unsigned char *Z;
	
	int n;
	
	//--
  	// compute depending on type of image
  	//--

  	//--
  	// UINT8 image
  	//--
  		  	
  	if (mxGetClassID(prhs[0]) == mxUINT8_CLASS) {
	
		//--
		// INPUT
		//--
	
		// input images
		
  		X18 = (unsigned char *) mxGetPr(prhs[0]);
  		n1 = mxGetM(prhs[0]) * mxGetN(prhs[0]);
  	
  		X28 = (unsigned char *) mxGetPr(prhs[1]);
  		n2 = mxGetM(prhs[1]) * mxGetN(prhs[1]);
  		
  		// mask image
  		
  		Z = (unsigned char *) mxGetPr(prhs[2]);
  		n = mxGetM(prhs[2]) * mxGetN(prhs[2]);  
  		
  		// check sizes
  		
  		if ((n1 != n2) || (n2 != n)) {
  			mexErrMsgTxt("Input images and mask must have same number of pixels");
  		}		
	 
  		//--
  		// OUTPUT
  		//--
    	
		// composed image
    	  	  		
  		*d = mxGetM(prhs[0]);
  		*(d + 1) = mxGetN(prhs[0]);
  		
  		Y8 = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
  		
  		//--
  		// COMPUTATION
  		//--
  		  		
  		image_mask_uint8 (Y8, X18, X28, Z, n);

	//--
	// DOUBLE image
	//--

	} else {

		//--
		// INPUT
		//--
	
		// input images
		
  		X1 = mxGetPr(prhs[0]);
  		n1 = mxGetM(prhs[0]) * mxGetN(prhs[0]);
  	
  		X2 = mxGetPr(prhs[1]);
  		n2 = mxGetM(prhs[1]) * mxGetN(prhs[1]);
  		
  		// mask image
  		
  		Z = (unsigned char *) mxGetPr(prhs[2]);
  		n = mxGetM(prhs[2]) * mxGetN(prhs[2]);  
  		
  		// check sizes
  		
  		if ((n1 != n2) || (n2 != n)) {
  			mexErrMsgTxt("Input images and mask must have same number of pixels");
  		}		
	 
  		//--
  		// OUTPUT
  		//--
    	
		// composed image
    	  	  		
  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(mxGetM(prhs[0]), mxGetN(prhs[0]), mxREAL));
  		
  		//--
  		// COMPUTATION
  		//--
  		  		
  		image_mask_double (Y, X1, X2, Z, n);

	}

}
