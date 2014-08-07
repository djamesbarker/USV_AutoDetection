//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
	
// C

#include "stdlib.h"
#include "math.h"

// Matlab
	
#include "mex.h"
#include "matrix.h"

// Local

#include "sorting_functions.c"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

//			 
// morph_gradient_par_double - morphological parametric gradient
// ---------------------------------------------------------
// 
// Input:
// ------
//  *X - image (double *, m * n)
//   m, n - rows and columns (int)
//  *B - structuring element (uint8 *, (2p + 1)*(2q + 1))
//   p, q - support parameters (int)
//   s - number of pixels in structuring element (int)
//   r - depth rank (int)
//  *Z - pointer to mask image array (uint8 *, (m * n))
//
// Output:
// -------
//  *Y - pointer to parametric gradient image (double *, (m - 2*p)*(n - 2*q))
//


void morph_gradient_par_double (
	double *Y, double *X, int m, int n,
	unsigned char *B, int p, int q, int s, int r, unsigned char *Z);
	
void morph_gradient_par_double (
	double *Y, double *X, int m, int n,
	unsigned char *B, int p, int q, int s, int r, unsigned char *Z)

{
	
	 int i, j, k, l;
		
	 unsigned char *ptr;
	
	 double *B1, *ptr1;
	  
	//--
	// INITIALIZATION
	//--
		  	  	
		// allocate window buffer
		
		B1 = mxCalloc(s, sizeof(double));
	
	//--
	// FULL COMPUTATION
	//--
	
	if (Z == NULL) {
	
	  	// loop over image
	  
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  		  		
	  		// loop over structuring element support
			
			ptr = B;
			ptr1 = B1;
			
			for (l = (j - q); l < (j + q + 1); l++) {
			for (k = (i - p); k < (i + p + 1); k++) {
	        
	      		if (*ptr) {
	      			*ptr1 = *(X + k + l*m);
	      			ptr1++;
	      		}
	      		ptr++;
	      
			}
			}
			
			// compute parametric gradient
						
			*(Y + (i - p) + (j - q)*(m - 2*p)) =
				kth_smallest_double (B1, s, (s - r)) - kth_smallest_double (B1, s, r);
		
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
				
				ptr = B;
				ptr1 = B1;
				
				for (l = (j - q); l < (j + q + 1); l++) {
				for (k = (i - p); k < (i + p + 1); k++) {
		        
		      		if (*ptr) {
		      			*ptr1 = *(X + k + l*m);
		      			ptr1++;
		      		}
		      		ptr++;
		      
				}
				}
								
				// compute parametric gradient
							
				*(Y + (i - p) + (j - q)*(m - 2*p)) =
					kth_smallest_double (B1, s, (s - r)) - kth_smallest_double (B1, s, r);
									
			} else {
			
				// no computation
				
				*(Y + (i - p) + (j - q)*(m - 2*p)) = 0;
			
			}
		
		}
		}
		
	} 

}

//			 
// morph_gradient_par_uint8 - morphological parametric gradient
// ---------------------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (uint8 *, (m * n))
//  m, n - number of image rows and columns (int)
//  *B - pointer to structuring element array (uint8 *, (2*p + 1)*(2*q + 1))
//  p, q - structuring element support parameters (int)
//  s - number of pixels in structuring element (int)
//  r - depth rank (int)
//  *Z - pointer to mask image array (uint8 *, (m * n))
//
// Output:
// -------
//  *Y - pointer to parametric gradient image (double *, (m - 2*p)*(n - 2*q))
//


void morph_gradient_par_uint8 (
	double *Y, unsigned char *X, int m, int n,
	unsigned char *B, int p, int q, int s, int r, unsigned char *Z);
	
void morph_gradient_par_uint8 (
	double *Y, unsigned char *X, int m, int n,
	unsigned char *B, int p, int q, int s, int r, unsigned char *Z)

{
	
	 int i, j, k, l;
		
	 unsigned char *B1, *ptr, *ptr1;
	  
	//--
	// INITIALIZATION
	//--
		  	  	
		// allocate window buffer
		
		B1 = mxCalloc(s, sizeof(unsigned char));
	
	//--
	// FULL COMPUTATION
	//--
	
	if (Z == NULL) {
	
	  	// loop over image
	  
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  		  		
	  		// loop over structuring element support
			
			ptr = B;
			ptr1 = B1;
			
			for (l = (j - q); l < (j + q + 1); l++) {
			for (k = (i - p); k < (i + p + 1); k++) {
	        
	      		if (*ptr) {
	      			*ptr1 = *(X + k + l*m);
	      			ptr1++;
	      		}
	      		ptr++;
	      
			}
			}
			
			// compute parametric gradient
					
			*(Y + (i - p) + (j - q)*(m - 2*p)) =
				(double) kth_smallest_uint8 (B1, s, (s - r)) - (double) kth_smallest_uint8 (B1, s, r);
		
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
				
				ptr = B;
				ptr1 = B1;
				
				for (l = (j - q); l < (j + q + 1); l++) {
				for (k = (i - p); k < (i + p + 1); k++) {
		        
		      		if (*ptr) {
		      			*ptr1 = *(X + k + l*m);
		      			ptr1++;
		      		}
		      		ptr++;
		      
				}
				}
								
				// compute parametric gradient
							
				*(Y + (i - p) + (j - q)*(m - 2*p)) =
					(double) kth_smallest_uint8 (B1, s, (s - r)) - (double) kth_smallest_uint8 (B1, s, r);
									
			} else {
			
				// no computation
				
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
// morph_gradient_par_uint8 - morphological parametric gradient
// ---------------------------------------------------------
//
// Y = morph_gradient_par_uint8(X,SE,Z)
//
// Input:
// ------
//  X - input image (uint8)
//  SE - structuring element (uint8)
//  r - depth rank parameter (int)
//  Z - computation mask image (def: []) (uint8)
//
// Output:
// -------
//  Y - parametric gradient image (uint8)
//

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	 double *Y, *X;  int d[2];
	
	 unsigned char *X8;  int m, n;
		
	 unsigned char *B;  int p, q;
			
	 unsigned char *Z;
	
	 int s, k, r;
	
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
		
		// get image (assumed padded)
					  
	  	X8 = (unsigned char *) mxGetPr(prhs[0]);
	  	
	  	m = mxGetM(prhs[0]);
	  	n = mxGetN(prhs[0]);
	
		// get structuring element (in matrix form)
		
		if (mxIsUint8(prhs[1])) {
	  		B = (unsigned char *) mxGetPr(prhs[1]);	  
	  	} else {
	  		mexErrMsgTxt("Structuring element must be of class uint8.");
	  	}
				
		p = (mxGetM(prhs[1]) - 1)/2;
		q = (mxGetN(prhs[1]) - 1)/2;
		
			// get size of structuring element
	  		
	  		s = 0;

			for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
				if (*(B + k)) {
					s++;
				}
			}
					
		// get parameters
		
		r = (int) mxGetScalar(prhs[2]) - 1;
		
		if ((r < 0) || (r > (s - 1) / 2)) {
	  	
	  		mexErrMsgTxt("Depth parameter is out of range.");
	  		
	  	}
	  	
	  	printf("\n (%d, %d, %d)\n\n", s, r, (s - (r + 1)));
	  		  								
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
  		
  		// allocate parametric gradient image
  		  		
  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
  	
  		//--
  		// COMPUTATION
  		//--
  	
  		morph_gradient_par_uint8 (Y, X8, m, n, B, p, q, s, r, Z);
  	
  	//--
  	// DOUBLE image
  	//--
  	
  	} else {
  	
  		//--
		// INPUT
		//--
		
		// get image (assumed padded)
					  
	  	X = mxGetPr(prhs[0]);
	  	
	  	m = mxGetM(prhs[0]);
	  	n = mxGetN(prhs[0]);
	
		// get structuring element (in matrix form)
		
		if (mxIsUint8(prhs[1])) {
	  		B = (unsigned char *) mxGetPr(prhs[1]);	  
	  	} else {
	  		mexErrMsgTxt("Structuring element must be of class uint8.");
	  	}
				
		p = (mxGetM(prhs[1]) - 1)/2;
		q = (mxGetN(prhs[1]) - 1)/2;
		
			// get size of structuring element
	  		
	  		s = 0;

			for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
				if (*(B + k)) {
					s++;
				}
			}
					
		// get parameters
		
		r = (int) mxGetScalar(prhs[2]) - 1;
		
		if ((r < 0) || (r > (s - 1) / 2)) {
	  	
	  		mexErrMsgTxt("Depth parameter is out of range.");
	  		
	  	}
	  	
	  	printf("\n (%d, %d, %d)\n\n", s, r, (s - (r + 1)));
	  		  								
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
  		
  		// allocate parametric gradient image
  		  		
  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
  	
  		//--
  		// COMPUTATION
  		//--
  	
  		morph_gradient_par_double (Y, X, m, n, B, p, q, s, r, Z);
  	
  	}
  		  		
}

