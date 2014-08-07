//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------

#include "stdlib.h"
#include "math.h"
 
#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

void image_up_double (
	double *YY, double *XX, int m, int n, int r, int c);
	
void image_up_double (
	double *YY, double *XX, int m, int n, int r, int c)
	
{

	 int i, j, M;
	
	M = c*(r*m - r + 1);

	for (j = 0; j < n; j++) {
	for (i = 0; i < m; i++) {
		*(YY + r*i + j*M) = *(XX + i + j*m);
	}
	}

}

void image_up_uint8 (
	unsigned char *Y, unsigned char *X, int m, int n, int r, int c);
	
void image_up_uint8 (
	unsigned char *Y, unsigned char *X, int m, int n, int r, int c)
	
{

	 int i, j;
	
	for (j = 0; j < n; j++) {
	for (i = 0; i < m; i++) {
		*(Y + r*i + c*j*(r*m - r + 1)) = *(X + i + j*m);
	}
	}

}


//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	 double *YY;
	 unsigned char *Y;
	
	 double *XX;
	 unsigned char *X;
	
	 int m, n;
	 int r, c;
	
	double *ptr;
	int d[2];
					
	//--
	// INPUT
	//--
		
		//--
	  	// get image
	  	//--
	  	
	  	if (mxIsDouble(prhs[0])) {
	  	
	  		XX = mxGetPr(prhs[0]);
	  		m = mxGetM(prhs[0]);
	  		n = mxGetN(prhs[0]);
	  		
	  	} else if (mxIsUint8(prhs[0])) {
	  	
	  		X = (unsigned char *) mxGetPr(prhs[0]);
	  		m = mxGetM(prhs[0]);
	  		n = mxGetN(prhs[0]);
	  		
	  	}
  		
	  	//--
	  	// get upsampling rates
	  	//--
		
	  	ptr = mxGetPr(prhs[1]);
	  	
	  	r = (int) *ptr;
	  	c = (int) *(ptr + 1);
								
	//--
  	// OUTPUT 
  	//--
  		
  		//--
  		// upsampled image
  		//--
  		
  		if (mxIsDouble(prhs[0])) {
	  	
	  		YY = mxGetPr(plhs[0] = mxCreateDoubleMatrix((r*m - r + 1), (c*n - c + 1), mxREAL));
	  		
	  	} else if (mxIsUint8(prhs[0])) {
	  	  		
	  		*d = (r*m - r + 1);
	  		*(d + 1) = (c*n - c + 1);
	  		
	  		Y = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
	  		
	  	}
  		  	
  	//--
  	// COMPUTATION
  	//--
  	
  		if (mxIsDouble(prhs[0])) {
	  	
	  		image_up_double(YY, XX, m, n, r, c);
	  		
	  	} else if (mxIsUint8(prhs[0])) {
	  	
	  		image_up_uint8(Y, X, m, n, r, c);
	  		
	  	}

}
