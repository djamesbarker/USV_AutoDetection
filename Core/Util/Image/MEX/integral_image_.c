//---------------------------------------------------
// INCLUDE
//---------------------------------------------------

#include "mex.h"

#include "matrix.h"

//---------------------------------------------------
// FUNCTIONS
//---------------------------------------------------

// integral_image - compute integral image
// ---------------------------------------
//
// Input:
// ------
//  X - input image
//
// Output:
// -------
//  Y - integral image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void integral_image(
	register double *Y, 
	register double *X, int m, int n
);

void integral_image(
	register double *Y, 
	register double *X, int m, int n
)

{

	register int j_m, i, j;
	
	register double S;
	
	//------------------------------------
	// first columm
	//------------------------------------
	
	//--
	// first pixel
	//--
	
	*Y = *X;
	
	//--
	// rest of column
	//--
	
	for (i = 1; i < m; i++) {
		*(Y + i) = *(Y + i - 1) + *(X + i);
	}
	
	//------------------------------------
	// other columns
	//------------------------------------
	
	for (j = 1; j < n; j++) {
	
		//--
		// first pixel of column
		//--
		
		j_m = j * m; 
		
		S = *(X + j_m);
		
		*(Y + j_m) = *(Y + j_m - m) + S;
		
		//--
		// rest of column
		//--
				
		for (i = 1; i < m; i++) {
		
			j_m++; // j_m = i + j_m;
			
			S += *(X + j_m);
			
			*(Y + j_m) = *(Y + j_m - m) + S;
			
		}
		
	}

}

// integral_image_uint8 - compute integral image
// ---------------------------------------
//
// Input:
// ------
//  X - input image
//
// Output:
// -------
//  Y - integral image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void integral_image_uint8(
	double *Y, 
	unsigned char *X, int m, int n
);

void integral_image_uint8(
	double *Y, 
	unsigned char *X, int m, int n
)

{

	register int j_m, i, j;
	
	register double S;
	
	//------------------------------------
	// first columm
	//------------------------------------
	
	//--
	// first pixel
	//--
	
	*Y = *X;
	
	//--
	// rest of column
	//--
	
	for (i = 1; i < m; i++) {
		*(Y + i) = *(Y + i - 1) + *(X + i);
	}
	
	//------------------------------------
	// other columns
	//------------------------------------
	
	for (j = 1; j < n; j++) {
	
		//--
		// first pixel of column
		//--
		
		j_m = j * m; 
		
		S = *(X + j_m);
		
		*(Y + j_m) = *(Y + j_m - m) + S;
		
		//--
		// rest of column
		//--
				
		for (i = 1; i < m; i++) {
		
			j_m++; // j_m = i + j_m;
			
			S += *(X + j_m);
			
			*(Y + j_m) = *(Y + j_m - m) + S;
			
		}
		
	}

}

//---------------------------------------------------
// MEX FUNCTION
//---------------------------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
		
	 double *X, *Y;
	
	 unsigned char *X8;
		
	 int m, n;

  	//------------------------------------
  	// UINT8 image
  	//------------------------------------
  		  	
  	if (mxGetClassID(prhs[0]) == mxUINT8_CLASS) {
  	
  		//------------------------------------
  		// INPUT
  		//------------------------------------
  		
		//--
  		// input image
  		//--
		
  		X8 = (unsigned char *) mxGetPr(prhs[0]);
  		
  		m = mxGetM(prhs[0]);
  		n = mxGetN(prhs[0]);
  		
  		//------------------------------------			
		// OUTPUT
		//------------------------------------

		//--
		// integral image
		//--
		
		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(m,n,mxREAL));
		
		//------------------------------------
  		// COMPUTE
  		//------------------------------------
  		
  		integral_image_uint8(Y, X8, m, n);
  		
  	//------------------------------------
  	// DOUBLE image
  	//------------------------------------
  	
  	} else {
  	
  		//------------------------------------
  		// INPUT
  		//------------------------------------
  		
		//--
  		// input image
  		//--
		
  		X = mxGetPr(prhs[0]);
  		
  		m = mxGetM(prhs[0]);
  		n = mxGetN(prhs[0]);
  		
  		//------------------------------------			
		// OUTPUT
		//------------------------------------
		
		//--
		// integral image
		//--
		
  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(m,n,mxREAL));
  		
  		//------------------------------------
  		// COMPUTE
  		//------------------------------------
  		
  		integral_image(Y, X, m, n);
  		
  	}	  

}    

