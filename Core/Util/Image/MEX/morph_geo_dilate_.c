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
// morph_dilate_geo_double - morphological geodesic dilation
// ----------------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (double *, (m * n))
//  *M - pointer to bound array  (double *, (m * n))
//  m, n - number of image rows and columns (int)
//  *Z - pointer to processing mask image array (uint8 *, (m * n))
//
// Output:
// -------
//  *Y - pointer to dilated image (double *, (m - 2)*(n - 2))
//  *A - pointer to activity image (uint8 *, (m - 2)*(n - 2))
//


void morph_dilate_geo_double (
	double *Y, unsigned char *A,
	double *X, double *M, int m, int n, unsigned char *Z);
	
void morph_dilate_geo_double (
	double *Y, unsigned char *A,
	double *X, double *M, int m, int n, unsigned char *Z)

{
		
	 int i, j, ij, k, l;
	
	 double B, U, t; 

	//--
	// FULL COMPUTATION
	//--
	
	if (Z == NULL) {

		// loop over image
		
	  	for (j = 1; j < (n - 1); j++) {
	  	for (i = 1; i < (m - 1); i++) {
	  		
	  		ij = i + (j * m);
	  									
			U = *(X + ij);
			B = *(M + ij);
				
			// geodesic computation
			
			if (B > U) {

				// loop over structuring element support
				
				for (l = (j - 1); l < (j + 2); l++) {
				for (k = (i - 1); k < (i + 2); k++) {
		        
	      			t = *(X + k + (l * m));
	      			
	      			if (t > U) {
						U = t;
					}
					
					if (B <= U) {
						U = B;
						break;
					}
		      
				}
				} 
				
				// set activity
				
				if (A) {
				
					if (*(X + ij) == U) {							
						*(A + (i - 1) + ((j - 1) * (m - 2))) = 0;
					} else {
						*(A + (i - 1) + ((j - 1) * (m - 2))) = 1;
					}
					
				}
			
				// keep result
											
				*(Y + (i - 1) + ((j - 1) * (m - 2))) = U;
							
			} else {
			
				// set activity
				
				if (A) {							
					*(A + (i - 1) + ((j - 1) * (m - 2))) = 0;
				}
				
				// keep result
											
				*(Y + (i - 1) + ((j - 1) * (m - 2))) = B;			
				
			}
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
	
		// loop over image
	
	  	for (j = 1; j < (n - 1); j++) {
	  	for (i = 1; i < (m - 1); i++) {
	  		 
	  		ij = i + (j * m);
	  		
	  		if (*(Z + ij)) {
	  										
				U = *(X + ij);
				B = *(M + ij);
				
				// geodesic computation
				
				if (B > U) {

					// loop over structuring element support
					
					for (l = (j - 1); l < (j + 2); l++) {
					for (k = (i - 1); k < (i + 2); k++) {
			        
		      			t = *(X + k + (l * m));
		      			
		      			if (t > U) {
							U = t;
						}
						
						if (B <= U) {
							U = B;
							break;
						}
			      
					}
					} 
					
					// set activity
				
					if (A) {
					
						if (*(X + ij) == U) {							
							*(A + (i - 1) + ((j - 1) * (m - 2))) = 0;
						} else {
							*(A + (i - 1) + ((j - 1) * (m - 2))) = 1;
						}
						
					}
				
					// keep result
												
					*(Y + (i - 1) + ((j - 1) * (m - 2))) = U;
								
				} else {
				
					// set activity
					
					if (A) {							
						*(A + (i - 1) + ((j - 1) * (m - 2))) = 0;
					}
					
					// keep result
												
					*(Y + (i - 1) + ((j - 1) * (m - 2))) = B;			
					
				}
				
			} else {
			
				// set activity
					
				if (A) {							
					*(A + (i - 1) + ((j - 1) * (m - 2))) = 0;
				}
						
				// leave unchanged
					
				*(Y + (i - 1) + ((j - 1) * (m - 2))) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}

//			 
// morph_dilate_geo_uint8 - morphological geodesic dilation
// ---------------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (unsigned char *, (m * n))
//  *M - pointer to bound array  (unsigned char *, (m * n))
//  m, n - number of image rows and columns (int)
//  *Z - pointer to processing mask image array (uint8 *, (m * n))
//
// Output:
// -------
//  *Y - pointer to dilated image (uint8 *, (m - 2)*(n - 2))
//  *A - pointer to activity image (uint8 *, (m - 2)*(n - 2))
//

void morph_dilate_geo_uint8 (
	unsigned char *Y, unsigned char *A,
	unsigned char *X, unsigned char *M, int m, int n, unsigned char *Z);
	
void morph_dilate_geo_uint8 (
	unsigned char *Y, unsigned char *A,
	unsigned char *X, unsigned char *M, int m, int n, unsigned char *Z)

{
		
	 int i, j, ij, k, l;
	
	 unsigned char B, U, t;  

	//--
	// FULL COMPUTATION
	//--
	
	if (!Z) {

		// loop over image
		
	  	for (j = 1; j < (n - 1); j++) {
	  	for (i = 1; i < (m - 1); i++) {
	  		
	  		ij = i + (j * m);
	  									
			U = *(X + ij);
			B = *(M + ij);
				
			// geodesic computation
			
			if (B > U) {

				// loop over structuring element support
				
				for (l = (j - 1); l < (j + 2); l++) {
				for (k = (i - 1); k < (i + 2); k++) {
		        
	      			t = *(X + k + (l * m));
	      			
	      			if (t > U) {
						U = t;
					}
					
					if (B <= U) {
						U = B;
						break;
					}
		      
				}
				} 
				
				// set activity
				
				if (A) {
				
					if (*(X + ij) == U) {							
						*(A + (i - 1) + ((j - 1) * (m - 2))) = 0;
					} else {
						*(A + (i - 1) + ((j - 1) * (m - 2))) = 1;
					}
					
				}
			
				// keep result
											
				*(Y + (i - 1) + ((j - 1) * (m - 2))) = U;
							
			} else {
			
				// set activity
				
				if (A) {							
					*(A + (i - 1) + ((j - 1) * (m - 2))) = 0;
				}
				
				// keep result
											
				*(Y + (i - 1) + ((j - 1) * (m - 2))) = B;			
				
			}
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
	
		// loop over image
	
	  	for (j = 1; j < (n - 1); j++) {
	  	for (i = 1; i < (m - 1); i++) {
	  		 
	  		ij = i + (j * m);
	  		
	  		if (*(Z + ij)) {
	  										
				U = *(X + ij);
				B = *(M + ij);
				
				// geodesic computation
				
				if (B > U) {

					// loop over structuring element support
					
					for (l = (j - 1); l < (j + 2); l++) {
					for (k = (i - 1); k < (i + 2); k++) {
			        
		      			t = *(X + k + (l * m));
		      			
		      			if (t > U) {
							U = t;
						}
						
						if (B <= U) {
							U = B;
							break;
						}
			      
					}
					}
					
					// set activity
				
					if (A) {
					
						if (*(X + ij) == U) {							
							*(A + (i - 1) + ((j - 1) * (m - 2))) = 0;
						} else {
							*(A + (i - 1) + ((j - 1) * (m - 2))) = 1;
						}
						
					} 
				
					// keep result
												
					*(Y + (i - 1) + ((j - 1) * (m - 2))) = U;
								
				} else {
				
					// set activity
					
					if (A) {							
						*(A + (i - 1) + ((j - 1) * (m - 2))) = 0;
					}
					
					// keep result
												
					*(Y + (i - 1) + ((j - 1) * (m - 2))) = B;			
					
				}
				
			} else {
			
				// set activity
					
				if (A) {							
					*(A + (i - 1) + ((j - 1) * (m - 2))) = 0;
				}
						
				// leave unchanged
					
				*(Y + (i - 1) + ((j - 1) * (m - 2))) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

//
// morph_dilate_geo_double - morphological geodesic dilation
// ----------------------------------------------------
//
// [Y,A] = morph_dilate_geo_double(X,M,Z)
//
// Input:
// ------
//  X - input image (double)
//  M - bound image (double)
//  Z - processing mask image (def: []) (uint8)
//
// Output:
// -------
//  Y - geodesically dilated image (double)
//  A - activity image
//

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	 double *Y;
	 unsigned char *Y8;
	
	 unsigned char *A;  int d[2];
	
	 double *X, *M;

	 unsigned char *X8, *M8;
	 
	 int m, mm, n, nn;
			
	 unsigned char *Z;
	
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
		
		// get image (marker image) (assumed padded)
					  
	  	X8 = (unsigned char *) mxGetPr(prhs[0]);
	  	
	  	m = mxGetM(prhs[0]);
	  	n = mxGetN(prhs[0]);
	  	
	  	// get bound image (mask image) (assumed padded)
					  
	  	if (mxIsUint8(prhs[0])) {
	  		M8 = (unsigned char *) mxGetPr(prhs[1]);
	  	} else {
	  		mexErrMsgTxt("Bound image must be of class uint8.");
	  	}
	  	
	  	mm = mxGetM(prhs[1]);
	  	nn = mxGetN(prhs[1]);
	  	
	  	// check image sizes
	  	
	  	if ((m != mm) || (n != nn)) {
			mexErrMsgTxt("Input images must be of the same size.");
		}
					
		// get processing mask (assumed padded)
						
		if (nrhs > 2) {
		
			if (mxIsEmpty(prhs[2])) {
			
		  		Z = NULL;
		  		
		  	} else {
		  	
			  	if (mxIsUint8(prhs[2])) {
			  		Z = (unsigned char *) mxGetPr(prhs[2]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class uint8.");
			  	}
			  	
			  	if ((m != mxGetM(prhs[2])) || (n != mxGetN(prhs[2]))) {
					mexErrMsgTxt("Images and mask must be of the same size.");
				}
				
			}
			
		  	
		} else {
		
			Z = NULL;
		
		}
				
		//--
  		// OUTPUT 
  		//--
  		
  		// size of output
  		
  		*d = (m - 2);
  		*(d + 1) = (n - 2);
  		
  		// allocate geodesically dilated image  
  		
  		Y8 = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
  		
  		// allocate activity image
  		
  		if (nlhs > 1) {
  			A = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
  		} else {
  			A = NULL;
  		}
  	
  		//--
  		// COMPUTATION
  		//--
  	
  		morph_dilate_geo_uint8 (Y8, A, X8, M8, m, n, Z);
  	
  	//--
  	// DOUBLE image
  	//--
  	
  	} else {
  	
  		//--
		// INPUT
		//--
		
		// get image (marker image) (assumed padded)
					  
	  	X = mxGetPr(prhs[0]);
	  	
	  	m = mxGetM(prhs[0]);
	  	n = mxGetN(prhs[0]);
	  	
	  	// get bound image (mask image) (assumed padded)
					  
	  	M = mxGetPr(prhs[1]);
	  	
	  	mm = mxGetM(prhs[1]);
	  	nn = mxGetN(prhs[1]);
	  	
	  	// check image sizes
	  	
	  	if ((m != mm) || (n != nn)) {
			mexErrMsgTxt("Input images must be of the same size.");
		}
					
		// get processing mask (assumed padded)
						
		if (nrhs > 2) {
		
			if (mxIsEmpty(prhs[2])) {
			
		  		Z = NULL;
		  		
		  	} else {
		  	
			  	if (mxIsUint8(prhs[2])) {
			  		Z = (unsigned char *) mxGetPr(prhs[2]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class uint8.");
			  	}
			  	
			  	if ((m != mxGetM(prhs[2])) || (n != mxGetN(prhs[2]))) {
					mexErrMsgTxt("Images and mask must be of the same size.");
				}
				
			}
			
		  	
		} else {
		
			Z = NULL;
		
		}
				
		//--
	  	// OUTPUT 
	  	//--
  		
  		// size of output
  		
  		*d = (m - 2);
  		*(d + 1) = (n - 2);
  		
  		// allocate geodesically dilated image  
  		
  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(m - 2, n - 2, mxREAL));
  		
  		// allocate activity image
  		
  		A = (unsigned char *) mxGetPr(plhs[1] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
  	
  		//--
  		// COMPUTATION
  		//--
  	
  		morph_dilate_geo_double (Y, A, X, M, m, n, Z);
  	
  	}

}
