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
// morph_min_max_double - simultaneous erosion and dilation
// --------------------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (double *, (m * n))
//  m, n - number of image rows and columns (int)
//  *B - pointer to structuring element array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - structuring element support parameters (int)
//  *Z - pointer to mask image array (uint8 *, (m * n))
//
// Output:
// -------
//  *Y1 - pointer to eroded image (double *, (m - 2*p)*(n - 2*q))
//  *Y2 - pointer to dilated image (double *, (m - 2*p)*(n - 2*q))
//

void morph_min_max_double (
	double *Y1, double *Y2, double *X, int m, int n, unsigned char *B, int p, int q, unsigned char *Z);
	
void morph_min_max_double (
	double *Y1, double *Y2, double *X, int m, int n, unsigned char *B, int p, int q, unsigned char *Z)

{
		
	 int i, j, jj, k, kk, l, ij;
	
	 int s, *Vx, *Vy, *J, sh, sp;
	
	 double xx, x1, x2, L, U, t;  
	
	//--
  	// size of SE
  	//--
				  		
	s = 0.0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}
	
	sh = s/2;
	sp = s - 2*sh;

	//--
	// SE displacement vectors
	//--
	
	Vx = (int *) mxCalloc(s, sizeof(int));
	Vy = (int *) mxCalloc(s, sizeof(int));
	
	k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {
	
		if (*(B + i + (2*p + 1)*j)) {
			*(Vy + k) = i - p;
			*(Vx + k) = j - q;
			k++;
		}
		
	}
	}
	
	//--
	// SE index jumps
	//--
	
	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(Vy + kk) + (*(Vx + kk) * m);
	}

	//--
	// FULL COMPUTATION
	//--
	
	if (Z == NULL) {
	
		// loop over image
		
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
			
			// loop over structuring element support in pairs
			
			ij = i + (j * m);
			
			L = *(X + ij);
			U = *(X + ij);
			
			for (kk = 0; kk < s - 1; kk = kk + 2) {
		        
				jj = ij + *(J + kk);
				x1 = *(X + jj);
				
				jj = ij + *(J + kk + 1);
				x2 = *(X + jj);
				
				if (x1 > x2) {
					xx = x1;
					x1 = x2;
					x2 = xx;
				}
				
				if (x1 < L) {
					L = x1;
				}
				
				if (x2 > U) {
					U = x2;
				} 
		      
			}
			
			if (sp) {
			
				jj = ij + *(J + s - 1);
				xx = *(X + jj);
								
				if (xx < L) {
					L = xx;
				} else if (xx > U) {
					U = xx;
				}
				
			}
						
			// eroded and dilated images
					
			ij = (i - p) + ((j - q) * (m - 2*p));
								
			*(Y1 + ij) = L;
			*(Y2 + ij) = U;
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
			
		// loop over image
	
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  		  		
	  		if (*(Z + i + (j * m))) {
				
				// loop over structuring element support
			
				ij = i + (j * m);
				
				L = *(X + ij);
				U = *(X + ij);
				
				for (kk = 0; kk < s - 1; kk == kk + 2) {
			        
					jj = ij + *(J + kk);
					x1 = *(X + jj);
					
					jj = ij + *(J + kk + 1);
					x2 = *(X + jj);
					
					if (x1 > x2) {
						xx = x1;
						x1 = x2;
						x2 = xx;
					}
					
					if (x1 < L) {
						L = x1;
					}
					
					if (x2 > U) {
						U = x2;
					} 
							      
				} 
				
				if (sp) {
			
					xx = *(X + s - 1);
					
					if (xx < L) {
						L = xx;
					} else if (xx > U) {
						U = xx;
					}
					
				}
					
				// eroded and dilated images
					
				ij = (i - p) + ((j - q) * (m - 2*p));
									
				*(Y1 + ij) = L;
				*(Y2 + ij) = U;
				
			} else {
						
				// leave unchanged
				
				ij = (i - p) + ((j - q) * (m - 2*p));
									
				*(Y1 + ij) = *(Y2 + ij) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}

//			 
// morph_min_max_uint8 - simultaneous erosion and dilation
// -------------------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (unsigned char *, (m * n))
//  m, n - number of image rows and columns (int)
//  *B - pointer to structuring element array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - structuring element support parameters (int)
//  *Z - pointer to mask image array (uint8 *, (m * n))
//
// Output:
// -------
//  *Y1 - pointer to eroded image (uint8 *, (m - 2*p)*(n - 2*q))
//  *Y2 - pointer to dilated image (uint8 *, (m - 2*p)*(n - 2*q))
//

void morph_min_max_uint8 (
	unsigned char *Y1, unsigned char *Y2, unsigned char *X, int m, int n, unsigned char *B, int p, int q, unsigned char *Z);
	
void morph_min_max_uint8 (
	unsigned char *Y1, unsigned char *Y2, unsigned char *X, int m, int n, unsigned char *B, int p, int q, unsigned char *Z)

{
		
	 int i, j, jj, k, kk, l, ij;
	
	 int s, *Vx, *Vy, *J, sh, sp;
	
	 unsigned char xx, x1, x2, L, U, t;  
	
	//--
  	// size of SE
  	//--
				  		
	s = 0.0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}
	
	sh = s/2;
	sp = s - 2*sh;

	//--
	// SE displacement vectors
	//--
	
	Vx = (int *) mxCalloc(s, sizeof(int));
	Vy = (int *) mxCalloc(s, sizeof(int));
	
	k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {
	
		if (*(B + i + (2*p + 1)*j)) {
			*(Vy + k) = i - p;
			*(Vx + k) = j - q;
			k++;
		}
		
	}
	}
	
	//--
	// SE index jumps
	//--
	
	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(Vy + kk) + (*(Vx + kk) * m);
	}

	//--
	// FULL COMPUTATION
	//--
	
	if (Z == NULL) {
	
		// loop over image
		
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
			
			// loop over structuring element support in pairs
			
			ij = i + (j * m);
			
			L = *(X + ij);
			U = *(X + ij);
			
			for (kk = 0; kk < s - 1; kk = kk + 2) {
		        
				jj = ij + *(J + kk);
				x1 = *(X + jj);
				
				jj = ij + *(J + kk + 1);
				x2 = *(X + jj);
				
				if (x1 > x2) {
					xx = x1;
					x1 = x2;
					x2 = xx;
				}
				
				if (x1 < L) {
					L = x1;
				}
				
				if (x2 > U) {
					U = x2;
				} 
		      
			}
			
			if (sp) {
			
				xx = *(X + s - 1);
				
				if (xx < L) {
					L = xx;
				} else if (xx > U) {
					U = xx;
				}
				
			}
						
			// eroded and dilated images
					
			ij = (i - p) + ((j - q) * (m - 2*p));
								
			*(Y1 + ij) = L;
			*(Y2 + ij) = U;
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
			
		// loop over image
	
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  		  		
	  		if (*(Z + i + (j * m))) {
				
				// loop over structuring element support
			
				ij = i + (j * m);
				
				L = *(X + ij);
				U = *(X + ij);
				
				for (kk = 0; kk < s - 1; kk == kk + 2) {
			        
					jj = ij + *(J + kk);
					x1 = *(X + jj);
					
					jj = ij + *(J + kk + 1);
					x2 = *(X + jj);
					
					if (x1 > x2) {
						xx = x1;
						x1 = x2;
						x2 = xx;
					}
					
					if (x1 < L) {
						L = x1;
					}
					
					if (x2 > U) {
						U = x2;
					} 
							      
				} 
				
				if (sp) {
			
					xx = *(X + s - 1);
					
					if (xx < L) {
						L = xx;
					} else if (xx > U) {
						U = xx;
					}
					
				}
					
				// eroded and dilated images
					
				ij = (i - p) + ((j - q) * (m - 2*p));
									
				*(Y1 + ij) = L;
				*(Y2 + ij) = U;
				
			} else {
						
				// leave unchanged
									
				ij = (i - p) + ((j - q) * (m - 2*p));
									
				*(Y1 + ij) = *(Y2 + ij) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------


//
// morph_min_max_double - simultaneous erosion and dilation
// ------------------------------------------
//
// [Y1,Y2] = morph_min_max_double(X,SE,Z)
//
// Input:
// ------
//  X - input image (double)
//  SE - structuring element (uint8)
//  Z - computation mask image (def: []) (uint8)
//
// Output:
// -------
//  Y1 - eroded image (double)
//  Y2 - dilated image (double)
//

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	 double *Y1, *Y2;
	 
	 unsigned char *Y18, *Y28;  int d[2];
	
	 double *X;  int m, n;

	 unsigned char *X8;
	 
	 unsigned char *B;  int p, q;
		
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
		
		
		// get parameters
			
					
		// get mask (assumed padded)
						
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
				
		//--
  		// OUTPUT 
  		//--
  		
  		*d = (m - 2*p);
  		*(d + 1) = (n - 2*q);
  		
  		// allocate eroded image
  		  		
  		Y18 = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
  		
  		// allocate dilated image
  		  		
  		Y28 = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
  	
  		//--
  		// COMPUTATION
  		//--
  	
  		morph_min_max_uint8 (Y18, Y28, X8, m, n, B, p, q, Z);
  	
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
		
		
		// get parameters
	
		
		// get mask (assumed padded)
						
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
				
		//--
  		// OUTPUT 
  		//--
  		
  		// allocate eroded image
  		
  		Y1 = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
  		
  		// allocate eroded image
  		
  		Y2 = mxGetPr(plhs[1] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
  	
  		//--
  		// COMPUTATION
  		//--
  	
  		morph_min_max_double (Y1, Y2, X, m, n, B, p, q, Z);
  	
  	}

}
