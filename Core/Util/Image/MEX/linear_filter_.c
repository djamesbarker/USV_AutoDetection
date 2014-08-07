// TODO: extend direct computation to complex input and filters

// TODO: implement FFT based convolution using FFTW 

//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
	
#include "stdlib.h"

#include "math.h"
	
#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------
	
// linear_filter_uint8 - linear filtering with masking
// ---------------------------------------------------
// 
// Input:
// ------
//  X - input image
//  m - number of image rows
//  n - number of image columns
//  F - linear filter
//  p - filter row support parameter
//  q - filter column support parameter
//  Z - computational mask
//
// Output:
// -------
//  Y - filtered image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void linear_filter_uint8 (
	double *Y,
	unsigned char *X, int m, int n, 
	double *F, int p, int q, 
	unsigned char *Z
);
	
void linear_filter_uint8 (
	double *Y,
	unsigned char *X, int m, int n, 
	double *F, int p, int q, 
	unsigned char *Z
)

{
	
    int i, j, k, l;
			
    double *ptr, t;
		    
	//----------------------------------------------
	// FULL COMPUTATION
	//----------------------------------------------	
	
	if (Z == NULL) {
		
		//--
		// loop over image valid part of image 
		//--
		
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
            
			ptr = F;
			
			t = 0.0;
			
			//--
			// loop over filter support
			//--
			
			// TODO: consider skipping the non-zero test
			
			for (l = (j - q); l < (j + q + 1); l++) {
			for (k = (i - p); k < (i + p + 1); k++) {
	        										
	      		if (*ptr) {
                    t += (*ptr) * ((double) *(X + k + l*m));
                }
	      		ptr++;
				       
			}
			}
			
            //--
			// save filtering result
            //--
										
			*(Y + (i - p) + ((j - q) * (m - 2*p))) = t;
		
		} 
		}
	
	//----------------------------------------------
	// MASKED COMPUTATION
	//----------------------------------------------
	
	} else {
	
        //--
		// loop over valid part of image
        //--
	
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  		  		
	  		if (*(Z + i + (j * m))) {
	  						
				ptr = F;
				
				t = 0.0;
				
                //--
				// loop over filter support
                //--
				
                // TODO: consider skipping the non-zero test
                
				for (l = (j - q); l < (j + q + 1); l++) {
				for (k = (i - p); k < (i + p + 1); k++) {
                                
		      		if (*ptr) {
                        t += (*ptr) * ((double) *(X + k + l*m));
                    }
		      		ptr++;
		      
				}
				}
				
                //--
				// save filtering result
                //--
                
				*(Y + (i - p) + ((j - q) * (m - 2*p))) = t;
				
			} else {
						
                //--
				// leave pixel unchanged
                //--
                
				*(Y + (i - p) + ((j - q) * (m - 2*p))) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}
		 
// linear_filter_double - linear filtering with masking
// ------------------------------------------------
// 
// Input:
// ------
//  X - input image
//  m - number of image rows
//  n - number of image columns
//  F - linear filter
//  p - filter row support parameter
//  q - filter column support parameter
//  Z - computational mask
//
// Output:
// -------
//  Y - filtered image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void linear_filter_double (
	double *Y,
	double *X, int m, int n, 
	double *F, int p, int q, 
	unsigned char *Z
);
	
void linear_filter_double (
	double *Y,
	double *X, int m, int n, 
	double *F, int p, int q, 
	unsigned char *Z
)

{
	
    int i, j, k, l;
			
    double *ptr, t;
		    
	//----------------------------------------------
	// FULL COMPUTATION
	//----------------------------------------------
	
	if (Z == NULL) {

		//--
		// loop over valid image area 
		//--
		
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  			  													
			ptr = F;
			
			t = 0.0;
			
            //--
			// loop over filter support
			//--
                        
			for (l = (j - q); l < (j + q + 1); l++) {
			for (k = (i - p); k < (i + p + 1); k++) {
	        
	      		if (*ptr) {
                    t += (*ptr) * (*(X + k + l*m));
	      		}
	      		ptr++;
	      
			}
			}
			
            //--
			// save filtering result
            //--
										
			*(Y + (i - p) + ((j - q) * (m - 2*p))) = t;
		
		} 
		}
	
	//----------------------------------------------
	// MASKED COMPUTATION
	//----------------------------------------------
	
	} else {
        
        //--
        // loop over valid image area
        //--
	
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  		  		
	  		if (*(Z + i + (j * m))) {
	  						
				ptr = F;
				
				t = 0.0;
				
                //--
				// loop over filter support
                //--
                				
				for (l = (j - q); l < (j + q + 1); l++) {
				for (k = (i - p); k < (i + p + 1); k++) {
		                                            
		      		if (*ptr) {
                        t += (*ptr) * (*(X + k + l*m));
                    }                    
		      		ptr++;
		      
				}
				}
				
                //--
				// save filtering result
                //--
                
				*(Y + (i - p) + ((j - q) * (m - 2*p))) = t;
				
			} else {
						
                //--
				// leave pixel unchanged
                //--
					
				*(Y + (i - p) + ((j - q) * (m - 2*p))) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// linear_filter_ - linear filtering with masking
// ----------------------------------------------
//
// Y = linear_filter_(X,F,Z)
//
// Input:
// ------
//  X - input image 
//  F - linear filter 
//  Z - computation mask image (def: [])
//
// Output:
// -------
//  Y - linearly filtered image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	double *X, *Y;
	
	unsigned char *X8;
	
	double *F;
	
	int m, n, p, q;
			
	unsigned char *Z;
	
  	//----------------------------------------------
  	// UINT8 INPUT IMAGE
  	//----------------------------------------------
  		  	
  	if (mxGetClassID(prhs[0]) == mxUINT8_CLASS) {
  	
  		//----------------------------------------------
  		// INPUT
  		//----------------------------------------------
  		
		//--
  		// input image
		//--
					  
	  	X8 = (unsigned char *) mxGetPr(prhs[0]);
	  	
	  	m = mxGetM(prhs[0]); 
		n = mxGetN(prhs[0]);
	
		//--
		// linear filter 
		//--
		
	  	F = mxGetPr(prhs[1]);	  
				
		p = (mxGetM(prhs[1]) - 1)/2; 
		q = (mxGetN(prhs[1]) - 1)/2;	
		
		//--
		// computational mask
		//--
						
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
					mexErrMsgTxt("Image and mask must be of the same size.");
				}
				
			}
			
		  	
		} else {
		
			Z = NULL;
		
		}
		
		//----------------------------------------------
	  	// OUTPUT 
	  	//----------------------------------------------
  		
		//--
  		// linearly filtered image
		//--
		
  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
  	
	  	//----------------------------------------------
	  	// COMPUTATION
	  	//----------------------------------------------
  	
  		linear_filter_uint8 (Y, X8, m, n, F, p, q, Z);
  	
  	//----------------------------------------------
  	// DOUBLE INPUT IMAGE
  	//----------------------------------------------
  	
  	} else {
  	
  		//----------------------------------------------
		// INPUT
		//----------------------------------------------
		
		//--
		// input image
		//--
		
	  	X = mxGetPr(prhs[0]);
	 
	  	m = mxGetM(prhs[0]); n = mxGetN(prhs[0]);
	
		//--
		// linear filter 
		//--
		
	  	F = mxGetPr(prhs[1]);	  
				
		p = (mxGetM(prhs[1]) - 1)/2; 
		q = (mxGetN(prhs[1]) - 1)/2;			
			
		//--
		// computational mask
		//--
		
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
					mexErrMsgTxt("Image and mask must be of the same size.");
				}
				
			}
			
		  	
		} else {
		
			Z = NULL;
		
		}
		
		//----------------------------------------------
	  	// OUTPUT 
	  	//----------------------------------------------
  		
		//--
  		// linearly filtered image
		//--
		
  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
  	
	  	//----------------------------------------------
	  	// COMPUTATION
	  	//----------------------------------------------
  	
		linear_filter_double (Y, X, m, n, F, p, q, Z);
  	
  	}

}
