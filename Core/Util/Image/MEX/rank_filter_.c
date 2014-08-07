///----------------------------------------------
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
// rank filter function
//
// Input:
// ------
//  *X - pointer to image data
//  m,n - number of rows and columns of image
//  *B - pointer to structuring element matrix array
//  p,q - support parameters for structuring element
//  s - number of pixels in structuring element
//  r - lowest rank
//  *Z - pointer to mask image
//
// Output:
// -------
//  *Y - pointer to rank filtered image
//

void rank_filter_double (
	double *Y, double *X, int m, int n,
	unsigned char *B, int p, int q, int s, int r, unsigned char *Z);

void rank_filter_double (
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
			
			// compute ranked pixel value
				
			*(Y + (i - p) + (j - q)*(m - 2*p)) = kth_smallest_double (B1, s, r);
		
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
								
				// compute ranked pixel value
				
				*(Y + (i - p) + (j - q)*(m - 2*p)) = kth_smallest_double (B1, s, r);
									
			} else {
			
				*(Y + (i - p) + (j - q)*(m - 2*p)) = *(X + i + j*m);
			
			}
		
		}
		}
		
	} 

}


//			 
// morphological rank filter function
//
// Input:
// ------
//  *X - pointer to image data
//  m,n - number of rows and columns of image
//  *B - pointer to structuring element matrix array
//  p,q - support parameters for structuring element
//  s - number of pixels in structuring element
//  r - lowest rank
//  *Z - pointer to mask image
//
// Output:
// -------
//  *Y - pointer to rank filtered image
//

void rank_filter_uint8 (
	unsigned char *Y, unsigned char *X, int m, int n,
	unsigned char *B, int p, int q, int s, int r, unsigned char *Z);

void rank_filter_uint8 (
	unsigned char *Y, unsigned char *X, int m, int n,
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
			
			// compute ranked pixel value
				
			*(Y + (i - p) + (j - q)*(m - 2*p)) = kth_smallest_uint8 (B1, s, r);
		
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
								
				// compute ranked pixel value
				
				*(Y + (i - p) + (j - q)*(m - 2*p)) = kth_smallest_uint8 (B1, s, r);
									
			} else {
			
				*(Y + (i - p) + (j - q)*(m - 2*p)) = *(X + i + j*m);
			
			}
		
		}
		}
		
	} 

}


//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

//
// Y = rank_filter_double(X,B,r,Z)
// 
// Input:
// ------
//  X - input image
//  B - sructuring element matrix
//  r - rank (rth smallest)
//  Z - mask
//

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	 double *X, *Y;
	
	 unsigned char *X8, *Y8;
	
	 int d[2];
	
	 unsigned char *B;
	
	 int m, n, p, q;
			
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
  		
  		// input image
					  
	  	X8 = (unsigned char *) mxGetPr(prhs[0]);
	  	
	  	m = mxGetM(prhs[0]);
	  	n = mxGetN(prhs[0]);
	
		// structuring element matrix
		
		if (mxIsUint8(prhs[1])) {
	  		B = (unsigned char *) mxGetPr(prhs[1]);	  
	  	} else {
	  		mexErrMsgTxt("Structuring element must be of class uint8.");
	  	}
				
		p = (mxGetM(prhs[1]) - 1)/2;
		q = (mxGetN(prhs[1]) - 1)/2;
		
		// get parameters

		// get size of structuring element
	  		
	  	s = 0;

		for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
			if (*(B + k)) {
				s++;
			}
		}
		
		// get parameters
		
		r = (int) mxGetScalar(prhs[2]) - 1;
		
		if ((r < 0) || (r > s - 1)) {
	  		mexErrMsgTxt("Rank parameter is out of range.");
	  	}
			
		// get mask
						
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
  		
  		// eroded image
  		
  		*d = (m - 2*p);
  		*(d + 1) = (n - 2*q);
  		
  		Y8 = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
  	
	  	//--
	  	// COMPUTATION
	  	//--
  	
  		rank_filter_uint8 (Y8, X8, m, n, B, p, q, s, r, Z);
  	
  	//--
  	// DOUBLE image
  	//--
  	
  	} else {
  	
  		//--
  		// INPUT
  		//--
  		
  		// input image
					  
	  	X = mxGetPr(prhs[0]);
	  	
	  	m = mxGetM(prhs[0]);
	  	n = mxGetN(prhs[0]);
	
		// structuring element matrix
		
		if (mxIsUint8(prhs[1])) {
	  		B = (unsigned char *) mxGetPr(prhs[1]);	  
	  	} else {
	  		mexErrMsgTxt("Structuring element must be of class uint8.");
	  	}
				
		p = (mxGetM(prhs[1]) - 1)/2;
		q = (mxGetN(prhs[1]) - 1)/2;
		
		// get parameters

		// get size of structuring element
	  		
	  	s = 0;

		for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
			if (*(B + k)) {
				s++;
			}
		}
		
		// get parameters
		
		r = (int) mxGetScalar(prhs[2]) - 1;
		
		if ((r < 0) || (r > s - 1)) {
	  		mexErrMsgTxt("Rank parameter is out of range.");
	  	}
			
		// get mask
						
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
  		
  		// rank filtered image

  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
  	
	  	//--
	  	// COMPUTATION
	  	//--
  	
  		rank_filter_double (Y, X, m, n, B, p, q, s, r, Z);
  	
  	}
  		
}

