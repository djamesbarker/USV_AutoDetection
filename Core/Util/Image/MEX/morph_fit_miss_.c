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

//			 
// morph_fit_miss_uint8 - morphological fit and miss transform
// --------------------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (unsigned char *, (m * n))
//  m, n - number of image rows and columns (int)
//  *B1 - pointer to FIT structuring element array (unsigned char *, (2*p + 1)*(2*q + 1))
//  *B2 - pointer to MISS structuring element array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - structuring element support parameters (int)
//  *Z - pointer to mask image array (uint8 *, (m * n))
//
// Output:
// -------
//  *Y - pointer to fit and miss image (uint8 *, (m - 2*p)*(n - 2*q))
//

void morph_fit_miss_uint8 (
	unsigned char *Y, unsigned char *X, int m, int n,
	unsigned char *B1, unsigned char *B2, int p, int q, unsigned char *Z);

void morph_fit_miss_uint8 (
	unsigned char *Y, unsigned char *X, int m, int n,
	unsigned char *B1, unsigned char *B2, int p, int q, unsigned char *Z)

{

	 register int i, j, k, l;
		
	 unsigned char *ptr1, *ptr2;
	
	 double tmp, y;
  
  	//--
  	// FULL COMPUTATION
  	//--
  	
  	if (!Z) {
  	
  		// loop over image
	  
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  		
			// loop over structuring element support
			
			ptr1 = B1;
			ptr2 = B2;
			
			y = 1.0;
			
			for (l = (j - q); (l < (j + q + 1)) && y; l++) {
			for (k = (i - p); (k < (i + p + 1)) && y; k++) {
	        	
	        	tmp = *(X + k + l*m);
	        	
	      		if ((*ptr1 != tmp) || (*ptr2 == tmp)) {
	      			y = 0.0;
	      		}
	      		
	      		ptr1++;
	      		ptr2++;
	      
			}
			}
			
			// keep fit and miss result
			
			*(Y + (i - p) + (j - q)*(m - 2*p)) = y;
						
		}
		} 
  	
  	//--
  	// MASKED COMPUTATION
  	//--
  	
  	} else {
  	
	  	// loop over image
	  
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  	
	  		// apply mask
	  		
	  		if (*(Z + i + j*m)) {
	  		
				// loop over structuring element support
				
				ptr1 = B1;
				ptr2 = B2;
				
				y = 1.0;
				
				for (l = (j - q); (l < (j + q + 1)) && y; l++) {
				for (k = (i - p); (k < (i + p + 1)) && y; k++) {
		        	
		        	tmp = *(X + k + l*m);
		        	
		      		if ((*ptr1 != tmp) || (*ptr2 == tmp)) {
		      			y = 0.0;
		      		}
		      		
		      		ptr1++;
		      		ptr2++;
		      
				}
				}
				
				// keep fit and miss result
				
				*(Y + (i - p) + (j - q)*(m - 2*p)) = y;
				
			} else {
			
				// non positive as non result
				
				*(Y + (i - p) + (j - q)*(m - 2*p)) = 0.0;
			
			}
		
		}
		} 
		
	}

}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

//
// morph_fit_miss_uint8 - morphological fit and miss transform
// --------------------------------------------------------
//
// Y = morph_fit_miss_uint8(X,SE1,SE2,Z)
//
// Input:
// ------
//  X - input image (uint8)
//  SE1 - structuring element to fit (uint8)
//  SE2 - structuring element to miss (uint8)
//  Z - computation mask image (def: []) (uint8)
//
// Output:
// -------
//  Y - fit and miss image (uint8)
//

//
// Y = morph_fit_miss_(X,B1,B2,Z)
// 
// Input:
// ------
//  X - input image
//  B1 - structuring element to fit
//  B2 - structuring element to miss
//  Z - mask
//

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	 unsigned char *Y;  int d[2];
	
	 unsigned char *X;  int m, n;
		
	 unsigned char *B1, *B2;  int p, q;
	
	 unsigned char *Z;
	
	//--
	// INPUT
	//--
		
		// get image (assumed padded)
					  
	  	if (mxIsUint8(prhs[0])) {
	  		X = (unsigned char *) mxGetPr(prhs[0]);
	  	} else {
	  		mexErrMsgTxt("Input image must be of class uint8.");
	  	}
	  	
	  	m = mxGetM(prhs[0]);
	  	n = mxGetN(prhs[0]);
	
		// get structuring elements (in matrix form)
		
		if (mxIsUint8(prhs[1])) {
	  		B1 = (unsigned char *) mxGetPr(prhs[1]);	  
	  	} else {
	  		mexErrMsgTxt("Structuring element must be of class uint8.");
	  	}
	  	
	  	if (mxIsUint8(prhs[2])) {
	  		B2 = (unsigned char *) mxGetPr(prhs[2]);	  
	  	} else {
	  		mexErrMsgTxt("Structuring element must be of class uint8.");
	  	}
				
		p = (mxGetM(prhs[1]) - 1)/2;
		q = (mxGetN(prhs[1]) - 1)/2;
		
		
		// get parameters
			
					
		// get mask (assumed padded)
						
		if (nrhs > 3) {
		
			if (mxIsEmpty(prhs[3])) {
			
		  		Z = NULL;
		  		
		  	} else {
		  	
			  	if (mxIsUint8(prhs[3])) {
			  		Z = (unsigned char *) mxGetPr(prhs[3]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class uint8.");
			  	}
			  	
			  	if ((m != mxGetM(prhs[3])) || (n != mxGetN(prhs[3]))) {
					mexErrMsgTxt("Image and mask must be of the same size.");
				}
				
			}
			
		  	
		} else {
		
			Z = NULL;
		
		}
				
	//--
  	// OUTPUT 
  	//--
  		
  		// allocate fit and miss image
  		
  		*d = (m - 2*p);
  		*(d + 1) = (n - 2*q);
  		
  		Y = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
  	
  	//--
  	// COMPUTATION
  	//--
  	
  		morph_fit_miss_uint8 (Y, X, m, n, B1, B2, p, q, Z);

}
