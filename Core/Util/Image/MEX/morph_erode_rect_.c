//----------------------------------------------
// INCLUDE
//----------------------------------------------

// C

#include "stdlib.h"
#include "math.h"

// Matlab

#include "mex.h"
#include "matrix.h"

//----------------------------------------------
// DEFINE
//----------------------------------------------

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------
		 
// morph_erode_double - morphological erosion
// ------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (double *, (m * n))
//  m, n - number of image rows and columns (int)
//  *B - pointer to structuring element array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - structuring element support parameters (int)
//  *Z - pointer to mask image array (unsigned char *, (m * n))
//
// Output:
// -------
//  *Y - pointer to eroded image (double *, (m - 2*p)*(n - 2*q))
//

void morph_erode_double (
	double *Y,
	double *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z);
	
void morph_erode_double (
	double *Y,
	double *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z)

{
		
	 int m_p, n_q;
	 
	 int i, j, jj, k, kk, l, ij;
	
	 int s, *Vx, *Vy, *J;
	
	 double xx, L, t;  
	
	//--
  	// size of SE
  	//--
				  		
	s = 0.0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}

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
		
		n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {

			// loop over structuring element support
			
			ij = i + (j * m);
			L = *(X + ij);
			
			for (kk = 0; kk < s; kk++) {
		        
				jj = ij + *(J + kk);
				
				xx = *(X + jj);
				
				if (xx < L) {
					L = xx;
				} 

			}
			
			// keep local min
					
			ij = (i - p) + ((j - q) * (m - 2*p));
								
			*(Y + ij) = L;
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
		
		// loop over image
	
	  	n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
	  		 
	  		ij = i + (j * m);
	  		 		
	  		if (*(Z + ij)) {
					
				// loop over structuring element support
			
				L = *(X + ij);
				
				for (kk = 0; kk < s; kk++) {
			        
					jj = ij + *(J + kk);
					
					xx = *(X + jj);
					
					if (xx < L) {
						L = xx;
					} 

				}
				
				// keep local min
						
				ij = (i - p) + ((j - q) * (m - 2*p));
									
				*(Y + ij) = L;
				
			} else {
						
				// leave unchanged
				
				ij = (i - p) + ((j - q) * (m - 2*p));
					
				*(Y + ij) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}

// morph_erode_uint8 - morphological erosion
// ----------------------------------------
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
//  *Y - pointer to eroded image (uint8 *, (m - 2*p)*(n - 2*q))
//


void morph_erode_uint8 (
	unsigned char *Y,
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z);
	
void morph_erode_uint8 (
	unsigned char *Y,
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z)

{
		
	 int m_p, n_q;
	
	 int i, j, jj, k, kk, l, ij;
	
	 int s, *Vx, *Vy, *J;
	
	 unsigned char xx, L, t;  
	
	//--
  	// size of SE
  	//--
				  		
	s = 0.0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}

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
		
	  	n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
	  					
			// loop over structuring element support
			
			ij = i + (j * m);
			L = *(X + ij);
			
			for (kk = 0; kk < s; kk++) {
		        
				jj = ij + *(J + kk);
				
				xx = *(X + jj);
				
				if (xx < L) {
					L = xx;
				} 
						      
			}
			
			// keep local min
					
			ij = (i - p) + ((j - q) * (m - 2*p));
								
			*(Y + ij) = L;
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
			
		// loop over image
	
	  	n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
	  		  		
	  		ij = i + (j * m);
	  		
	  		if (*(Z + ij)) {

				// loop over structuring element support
			
				ij = i + (j * m);
				L = *(X + ij);
				
				for (kk = 0; kk < s; kk++) {
			        
					jj = ij + *(J + kk);
					
					xx = *(X + jj);
					
					if (xx < L) {
						L = xx;
					} 
							      
				} 
					
				// keep local min
				
				ij = (i - p) + ((j - q) * (m - 2*p));
							
				*(Y + ij) = L;
				
			} else {
						
				// leave unchanged
				
				ij = (i - p) + ((j - q) * (m - 2*p));
					
				*(Y + ij) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}


//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

//
// morph_erode_uint8 - morphological erosion
// ----------------------------------------
//
// Y = morph_erode_uint8(X,SE,Z)
//
// Input:
// ------
//  X - input image (uint8)
//  SE - structuring element (uint8)
//  Z - computation mask image (def: []) (uint8)
//
// Output:
// -------
//  Y - eroded image (uint8)
//

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	double *X, *Y;
	
	unsigned char *X8, *Y8;
	
	int d[2];
	
	unsigned char *B;
	
	int m, n, p, q;
			
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
			
		// get mask
						
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
  		
  		// eroded image
  		
  		*d = (m - 2*p);
  		*(d + 1) = (n - 2*q);
  		
  		Y8 = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
  	
	  	//--
	  	// COMPUTATION
	  	//--
  	
  		morph_erode_uint8 (Y8, X8, m, n, B, p, q, Z);
  	
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
			
		// get mask
						
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
  		
  		// eroded image

  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
  	
	  	//--
	  	// COMPUTATION
	  	//--
  	
  		morph_erode_double (Y, X, m, n, B, p, q, Z);
  	
  	}

}

