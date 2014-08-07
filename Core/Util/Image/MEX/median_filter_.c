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
// median_interp_double - interpolated median
// ------------------------------------------
//

double median_interp_double (double *W, int s);

double median_interp_double (double *W, int s) 

{

	double y1, y2;
	int h = s / 2;
		
	y1 = (double) kth_smallest_double (W, s, h - 1);
	y2 = (double) kth_smallest_double (W, s, h);
	
	return ((y1 + y2) / 2.0);
	
}

//
// median_interp_uint8 - interpolated median
// -----------------------------------------
//

double median_interp_uint8 (unsigned char *W, int s);

double median_interp_uint8 (unsigned char *W, int s) 

{

	double y1, y2;
	int h = s / 2;
		
	y1 = (double) kth_smallest_uint8 (W, s, h - 1);
	y2 = (double) kth_smallest_uint8 (W, s, h);
	
	return ((y1 + y2) / 2.0);
	
}

//
// se_size - get size
// ------------------
//

int se_size (unsigned char *B, int p, int q);

int se_size (unsigned char *B, int p, int q)

{

	int k;
	int s = 0;
	int t = (2*p + 1)*(2*q + 1);
	
	for (k = 0; k < t; k++) {
		if (*(B + k)) {
			s++;
		}
	}
	
	return (s);
	
}

//
// se_b2v - get displacement vectors
// ---------------------------------
//

void se_b2v(double *Vx, double *Vy, unsigned char *B, int p, int q, int s);

void se_b2v(double *Vx, double *Vy, unsigned char *B, int p, int q, int s)

{
	
	int i, j;
	int k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {
	
		if (*(B + i + (2*p + 1)*j)) {
			*(Vy + k) = i - p;
			*(Vx + k) = j - q;
			k++;
		}
		
	}
	}
	
}
			 
//
// median_filter_double - median filter
// -----------------------------------
// 
// Input:
// ------
//  *X, m, n - image (double, m*n), and number of rows and columns
//  *B, p, q - structuring element matrix (unsigned char, (2*p + 1)*(2*q + 1)), and support parameters
//  *Z - computation mask image (unsigned char *, m*n)
//
// Output:
// -------
//  *Y - adaptive epsilon image (double *, (m - 2*p)*(n - 2*q))
//

void median_filter_double (
	double *Y, double *X, int m, int n,
	unsigned char *B, int p, int q, unsigned char *Z,
	double (*fun) (double *W, int s));
		
void median_filter_double (
	double *Y, double *X, int m, int n,
	unsigned char *B, int p, int q, unsigned char *Z,
	double (*fun) (double *W, int s))

{
		
	 int i, j, ij, k, l, kk, *J, jj;

	 int s, r;
			
	 double c, *Vx, *Vy, *W; 
			
//--
// INITIALIZATION
//--
		
	//--
	// structuring element
	//--
	
	s = se_size (B, p, q);
	
	Vx = mxCalloc(s, sizeof(double));
	Vy = mxCalloc(s, sizeof(double));
	
	se_b2v (Vx, Vy, B, p, q, s);
	
	//--
	// SE index jumps
	//--
	
	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(Vy + kk) + (*(Vx + kk) * m);
	}
				
	//--
	// allocate window buffer
	//--
		
	W = mxCalloc(s, sizeof(double));
				  	
//--
// full computation
//-- 
  	
  	if (Z == NULL) {
  	
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  		
	  		ij = i + (j * m);
	  		
			// loop SE
							
			for (k = 0; k < s; k++) {
	        	jj = ij + *(J + k);
	        	*(W + k) = *(X + jj);
			}
		
			// compute and save median
			
			*(Y + (i - p) + (j - q)*(m - 2*p)) = (*fun) (W, s);
												
		}
		}
  	  	
	}
	
  	//--
  	// masked operator
  	//--
  	
  	else {
  	
	  	// loop image
	  	
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  		
	  		ij = i + j*m;
	  		
	  		if (*(Z + ij)) {
	  	
		  		// loop SE
		  						
				for (k = 0; k < s; k++) {
		        	jj = ij + *(J + k);
		        	*(W + k) = *(X + jj);
				}	
			
				// compute and save median
				
				*(Y + (i - p) + (j - q)*(m - 2*p)) = (*fun) (W, s);
			
			} else {
			
				// leave pixel unchanged
				
				*(Y + (i - p) + (j - q)*(m - 2*p)) = *(X + ij);
								
			}
			
		}
		}
										
	}

}


//
// median_filter_uint8 - median computation
// ------------------------------------
// 
// Input:
// ------
//  *X, m, n - image (unsigned char, m*n), and number of rows and columns
//  *B, p, q, s - structuring element matrix (unsigned char, (2*p + 1)*(2*q + 1)), support parameters, and size
//  *Z - computation mask image (unsigned char *, m*n)
//  *fun - pointer to sorting function
//
// Output:
// -------
//  *Y - adaptive epsilon image (double *, (m - 2*p)*(n - 2*q))
//

void median_filter_uint8 (
	double *Y,
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q,unsigned char *Z,
	unsigned char (*fun) (unsigned char *W, int s));
	
void median_filter_uint8 (
	double *Y,
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q, unsigned char *Z,
	unsigned char (*fun) (unsigned char *W, int s))

{
		
	//--
	// index
	//--
	
	 int i, j, ij, k, l, kk; 
	
	 int *J, jj;
	
	//--
	// structuring element
	//--
	
	 int r, s;
			
	 double c, *Vx, *Vy; 
	
	//--
	// buffer
	//--
	
	 unsigned char *W;
			
//--
// INITIALIZATION
//--
	
	//--
	// structuring element
	//--
	
	s = se_size (B, p, q);
	
	Vx = mxCalloc(s, sizeof(double));
	Vy = mxCalloc(s, sizeof(double));
	
	se_b2v (Vx, Vy, B, p, q, s);
	
	//--
	// SE index jumps
	//--
	
	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(Vy + kk) + (*(Vx + kk) * m);
	}
				
	//--
	// allocate window buffer
	//--
		
	W = mxCalloc(s, sizeof(unsigned char));

//--
// full computation
//-- 
  	
  	if (Z == NULL) {
  			
	  	// loop image
	  	
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  			  		
	  		ij = i + (j * m);
	  		
	  		// loop se
	  									
			for (k = 0; k < s; k++) {
	        	jj = ij + *(J + k);
	        	*(W + k) = *(X + jj);
			}
		
			// compute and save median
			
			*(Y + (i - p) + (j - q)*(m - 2*p)) = (double) fun (W, s);
			
		}
		}
					
	}
  	  	
//--
// mask operator
//--

	else {
  	
	  	// loop image
	  	
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  		
	  		ij = i + (j * m);
	  		
	  		if (*(Z + ij)) {
	  		
		  		// loop se
		  					
				for (k = 0; k < s; k++) {
		        	jj = ij + *(J + k);
		        	*(W + k) = *(X + jj);
				}	

				// compute and save median
				
				*(Y + (i - p) + (j - q)*(m - 2*p)) = (double) fun (W, s);
			
			} else {
				
				// leave pixel unchanged
				
				*(Y + (i - p) + (j - q)*(m - 2*p)) = *(X + ij);
					
			}
			
		}
		}
	
	}
		
}


//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

//
// median_filter_ - median filter
// ------------------------------
//
// Y = median_filter_(X,SE,Z)
//
// Input:
// ------
//  X - input image
//  SE - structuring element (uint8)
//  Z - computation mask image (def: []) (uint8)
//
// Output:
// -------
//  Y - median filtered image
//

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
		
	double *X, *Y;
	
	unsigned char *X8;
	
	 unsigned char *B;
	
	 int m, n, p, q, s;
			
	 unsigned char *Z;

	 void *fun;
	
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
  		
  		// median filtered image

  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
  	
	  	//--
	  	// COMPUTATION
	  	//--

  		// choose sorting function
  		
  		s = se_size (B,p,q);
  		
  		switch (s) {
  		
  			case 3:
  				fun = opt_med3_uint8;
  				break;
  			case 5:
  				fun = opt_med5_uint8;
  				break;
  			case 7:
  				fun = opt_med7_uint8;
  				break;
  			case 9:
  				fun = opt_med9_uint8;
  				break;
  			default:
  				if (s % 2) {
  					fun = quick_select_uint8;
  				} else {
  					fun = median_interp_uint8;
  				}
  				
  		}

		// compute median filter
  	
  		median_filter_uint8 (Y, X8, m, n, B, p, q, Z, fun);
  	
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
  		
  		// median filtered image

  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
  	
	  	//--
	  	// COMPUTATION
	  	//--

		// choose sorting function
  		
  		s = se_size (B,p,q);
  		
  		switch (s) {
  		
  			case 3:
  				fun = opt_med3_double;
  				break;

  			case 5:
  				fun = opt_med5_double;
  				break;
  			
			case 7:
  				fun = opt_med7_double;
  				break;
  			
			case 9:
  				fun = opt_med9_double;
  				break;
  			
			default:
  				if (s % 2) {
  					fun = quick_select_double;
  				} else {
  					fun = median_interp_double;
  				}
  				
  		}

		// compute median filter
  	
  		median_filter_double (Y, X, m, n, B, p, q, Z, fun);
  	
  	}

}

