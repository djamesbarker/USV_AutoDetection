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
			 
// moment_filter_double - compute local image centered moments
// -----------------------------------------------------------
// 
// Input:
// ------
//  *X - image
//   m, n - rows and columns
//  *B - structuring element
//   p, q - support parameters
//  *Z - computation mask image
//
// Output:
// -------
//  *M - mean image (first moment)
//  *S - variance image (second centered moment)
//  *G1 - skewness image (based on third and second centered moments)
//  *G2 - kurtosis image (based on fourth and 

void moment_filter_double (
	double *M, double *S, double *G1, double *G2, 
	double *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z);

void moment_filter_double (
	double *M, double *S, double *G1, double *G2, 
	double *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z)	
	
{
	
	register int n_q, m_p;

	register int i, j, ij, ij2;
	
	register int k, kk, s, *J, jj; 
			
	double *dx, *dy, *SE; 
	
	register double m1, m2, m3, m4, t;
			
	//--
	// INITIALIZATION
	//--	
		
	//--
  	// strucuring element size
	//--
	 
	s = 0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}
	
	//--
	// structuring element displacement vectors
	//--

	dx = mxCalloc(s, sizeof(double));
	dy = mxCalloc(s, sizeof(double));
	
	k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {	
		if (*(B + i + (2*p + 1)*j)) {
			*(dy + k) = i - p;
			*(dx + k) = j - q;
			k++;
		}		
	}
	}
	
	//--
	// structuring element index jumps
	//--

	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(dy + kk) + (*(dx + kk) * m);
	}
				
	//--
	// structuring element buffer
	//--
		
	SE = mxCalloc(s, sizeof(double));
				  	
	//--
	// FULL COMPUTATION	
	//-- 
  	
  	if (Z == NULL) {
  			
		n_q = n - q;
		m_p = m - p;

		for (j = q; j < n_q; j++) {
		for (i = p; i < m_p; i++) {
		  		
		  	//--
		  	// input center index
		  	//--
		  		
		  	ij = i + j*m;
					
			//--		
			// load buffer and compute mean (first loop over SE)
			//--
						
			m1 = 0.0;

			for (kk = 0; kk < s; kk++) {
				
				// neighbor index

		       	jj = ij + *(J + kk);
		        	
		       	// load buffer and compute cumulative sum
		        	
		       	*(SE + kk) = *(X + jj);

				if (*(X + jj)) {
					m1 += *(X + jj);
				}
		        	
			}
				
			// mean

			m1 = m1 / s;
			
			//--
			// compute other moments (second loop over SE)
			//--
				
			m2 = 0.0;
			m3 = 0.0;
			m4 = 0.0;

			for (kk = 0; kk < s; kk++) {

		        t = *(SE + kk) - m1;

				if (t) {
					m2 += t * t;
					m3 += m2 * t;
					m4 += m3 * t;
				}

			}

			m2 = m2 / s;
			m3 = m3 / s;
			m4 = m4 / s;
				
			//--
			// output location index
			//--
				
			ij2 = (i - p) + (j - q)*(m - 2*p);
			
			//--
			// compute and save moments and shape parameters
			//--
				
			*(M + ij2) = m1;
			*(S + ij2) = m2;

			if (m2) {
				*(G1 + ij2) = m3 / sqrt(m2 * m2 * m2);
				*(G2 + ij2) = m4 / (m2 * m2);
			} else {
				*(G1 + ij2) = 0.0;
				*(G2 + ij2) = 0.0;
			}
			
		}
		}
		
  	//--
  	// MASKED COMPUTATION
  	//--
  	
  	} else {

		n_q = n - q;
		m_p = m - p;

		for (j = q; j < n_q; j++) {
		for (i = p; i < m_p; i++) {
		  		
			//--
		  	// input center index
		  	//--
		  		
		  	ij = i + j*m;
		  		
		  	//--
		  	// compute only marked pixels
		  	//--
		  		
		  	if (*(Z + ij)) {
					
				//--		
				// load buffer and compute mean (first loop over SE)
				//--
						
				m1 = 0.0;

				for (kk = 0; kk < s; kk++) {
					
					// neighbor index
	
		       		jj = ij + *(J + kk);
		        	
					// load buffer and compute cumulative sum
		        	
				   	*(SE + kk) = *(X + jj);

					if (*(X + jj)) {
						m1 += *(X + jj);
					}
				    	
				}
				
				// mean

				m1 = m1 / s;
					
				//--
				// compute other moments (second loop over SE)
				//--
				
				m2 = 0.0;
				m3 = 0.0;
				m4 = 0.0;
		
				for (kk = 0; kk < s; kk++) {

			        t = *(SE + kk) - m1;

					if (t) {
						m2 += t * t;
						m3 += m2 * t;
						m4 += m3 * t;
					}

				}

				m2 = m2 / s;
				m3 = m3 / s;
				m4 = m4 / s;
					
				//--
				// output location index
				//--
					
				ij2 = (i - p) + (j - q)*(m - 2*p);
				
				//--
				// compute and save moments and shape parameters
				//--
					
				*(M + ij2) = m1;
				*(S + ij2) = m2;

				if (m2) {
					*(G1 + ij2) = m3 / sqrt(m2 * m2 * m2);
					*(G2 + ij2) = m4 / (m2 * m2);
				} else {
					*(G1 + ij2) = 0.0; 
					*(G2 + ij2) = 0.0;
				}
		
					
			} else {
					
				//--
				// output location index
				//--
					
				ij2 = (i - p) + (j - q)*(m - 2*p);
				
				//--
				// save uncomputed values
				//--
					
				*(M + ij2) = 0.0;
				*(S + ij2) = 0.0;
				*(G1 + ij2) = 0.0;
				*(G2 + ij2) = 0.0;
						
			}
				
		}
		}
	
	}

}

// moment_filter_uint8 - compute local image centered moments
// ----------------------------------------------------------
// 
// Input:
// ------
//  *X - image
//   m, n - rows and columns
//  *B - structuring element
//   p, q - support parameters
//  *Z - computation mask image
//
// Output:
// -------
//  *M - mean image (first moment)
//  *S - variance image (second centered moment)
//  *G1 - skewness image (based on third and second centered moments)
//  *G2 - kurtosis image (based on fourth and 

void moment_filter_uint8 (
	double *M, double *S, double *G1, double *G2, 
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z);

void moment_filter_uint8 (
	double *M, double *S, double *G1, double *G2, 
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z)	
	
{
	
	register int n_q, m_p;

	register int i, j, ij, ij2;
	
	register int k, kk, s, *J, jj; 
			
	double *dx, *dy, *SE; 
	
	register double m1, m2, m3, m4, t;
			
	//--
	// INITIALIZATION
	//--	
		
	//--
  	// strucuring element size
	//--
	 
	s = 0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}
	
	//--
	// structuring element displacement vectors
	//--

	dx = mxCalloc(s, sizeof(double));
	dy = mxCalloc(s, sizeof(double));
	
	k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {	
		if (*(B + i + (2*p + 1)*j)) {
			*(dy + k) = i - p;
			*(dx + k) = j - q;
			k++;
		}		
	}
	}
	
	//--
	// structuring element index jumps
	//--

	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(dy + kk) + (*(dx + kk) * m);
	}
				
	//--
	// structuring element buffer
	//--
		
	SE = mxCalloc(s, sizeof(double));
				  	
	//--
	// FULL COMPUTATION	
	//-- 
  	
  	if (Z == NULL) {
  			
		n_q = n - q;
		m_p = m - p;

		for (j = q; j < n_q; j++) {
		for (i = p; i < m_p; i++) {
		  		
		  	//--
		  	// input center index
		  	//--
		  		
		  	ij = i + j*m;
					
			//--		
			// load buffer and compute mean (first loop over SE)
			//--
						
			m1 = 0.0;

			for (kk = 0; kk < s; kk++) {
				
				// neighbor index

		       	jj = ij + *(J + kk);
		        	
		       	// load buffer and compute cumulative sum
		        	
		       	*(SE + kk) = (double) *(X + jj);

				if (*(X + jj)) {
					m1 += *(X + jj);
				}
		        	
			}
				
			// mean

			m1 = m1 / s;
			
			//--
			// compute other moments (second loop over SE)
			//--
				
			m2 = 0.0;
			m3 = 0.0;
			m4 = 0.0;

			for (kk = 0; kk < s; kk++) {

		        t = *(SE + kk) - m1;

				if (t) {
					m2 += t * t;
					m3 += m2 * t;
					m4 += m3 * t;
				}

			}

			m2 = m2 / s;
			m3 = m3 / s;
			m4 = m4 / s;
				
			//--
			// output location index
			//--
				
			ij2 = (i - p) + (j - q)*(m - 2*p);
			
			//--
			// compute and save moments and shape parameters
			//--
				
			*(M + ij2) = m1;
			*(S + ij2) = m2;

			if (m2) {
				*(G1 + ij2) = m3 / sqrt(m2 * m2 * m2);
				*(G2 + ij2) = m4 / (m2 * m2);
			} else {
				*(G1 + ij2) = 0.0; 
				*(G2 + ij2) = 0.0;
			}
			
		}
		}
		
  	//--
  	// MASKED COMPUTATION
  	//--
  	
  	} else {

		n_q = n - q;
		m_p = m - p;

		for (j = q; j < n_q; j++) {
		for (i = p; i < m_p; i++) {
		  		
			//--
		  	// input center index
		  	//--
		  		
		  	ij = i + j*m;
		  		
		  	//--
		  	// compute only marked pixels
		  	//--
		  		
		  	if (*(Z + ij)) {
					
				//--		
				// load buffer and compute mean (first loop over SE)
				//--
						
				m1 = 0.0;

				for (kk = 0; kk < s; kk++) {
					
					// neighbor index
	
		       		jj = ij + *(J + kk);
		        	
					// load buffer and compute cumulative sum
		        	
				   	*(SE + kk) = *(X + jj);

					if (*(X + jj)) {
						m1 += *(X + jj);
					}
				    	
				}
				
				// mean

				m1 = m1 / s;
					
				//--
				// compute other moments (second loop over SE)
				//--
				
				m2 = 0.0;
				m3 = 0.0;
				m4 = 0.0;
		
				for (kk = 0; kk < s; kk++) {

			        t = *(SE + kk) - m1;

					if (t) {
						m2 += t * t;
						m3 += m2 * t;
						m4 += m3 * t;
					}

				}

				m2 = m2 / s;
				m3 = m3 / s;
				m4 = m4 / s;
					
				//--
				// output location index
				//--
					
				ij2 = (i - p) + (j - q)*(m - 2*p);
				
				//--
				// compute and save moments and shape parameters
				//--
					
				*(M + ij2) = m1;
				*(S + ij2) = m2;

				if (m2) {
					*(G1 + ij2) = m3 / sqrt(m2 * m2 * m2);
					*(G2 + ij2) = m4 / (m2 * m2);
				} else {
					*(G1 + ij2) = 0.0;
					*(G2 + ij2) = 0.0;
				}
		
					
			} else {
					
				//--
				// output location index
				//--
					
				ij2 = (i - p) + (j - q)*(m - 2*p);
				
				//--
				// save uncomputed values
				//--
					
				*(M + ij2) = 0.0;
				*(S + ij2) = 0.0;
				*(G1 + ij2) = 0.0;
				*(G2 + ij2) = 0.0;
						
			}
				
		}
		}
	
	}

}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

//
// den_variance_double - adaptive epsilon density filter
// ---------------------------------------------
//
// E = den_variance_double(X,SE,K,Z)
//
// Input:
// ------
//  X - input image (double)
//  SE - structuring element (uint8)
//  K - edge density (double)
//  Z - computation mask image (def: []) (uint8)
//
// Output:
// -------
//  E - lower bound epsilon parameter (double)
//

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
		
	double *M, *S, *G1, *G2;
	
	double *X; unsigned char *X8;
	int m, n;
	
	unsigned char *B;
	int p, q;
		
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
  	
  		// moment images
  		  			
		M = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
		S = mxGetPr(plhs[1] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));

		// shape factor images

		G1 = mxGetPr(plhs[2] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
		G2 = mxGetPr(plhs[3] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));

  		//--
  		// COMPUTATION
  		//--
  	  	  	  	
  		moment_filter_uint8 (M, S, G1, G2, X8, m, n, B, p, q, Z);

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
  	
  		// moment images
  		  			
		M = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
		S = mxGetPr(plhs[1] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));

		// shape factor images

		G1 = mxGetPr(plhs[2] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
		G2 = mxGetPr(plhs[3] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));

  		//--
  		// COMPUTATION
  		//--
  	  	  	  	
  		moment_filter_double (M, S, G1, G2, X, m, n, B, p, q, Z);

	}

}

