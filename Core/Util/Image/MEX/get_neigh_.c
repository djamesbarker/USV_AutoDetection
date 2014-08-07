//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------

//--
// C
//--

#include "stdlib.h"
#include "math.h"

//--
// Matlab
//--
		
#include "mex.h"
#include "matrix.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------
			 
// get_neigh_double - get image neighborhood data
// ----------------------------------------------
// 
// Input:
// ------
//  *X - input image
//   m, n - number of rows and columns
//  *B - structuring element matrix
//   p, q - support parameters
//   s - size of structuring element
//  *pix_i, *pix_j - pixel row and column indexes
//   N - number of pixels
//
// Output:
// -------
//  *Y - neighbor data matrix

void get_neigh_double (
	double *Y,
	double *X, int m, int n,
	unsigned char *B, int p, int q, int s,
	double *pix_i, double *pix_j,
	int N
);
	
void get_neigh_double (
	double *Y, 
	double *X, int m, int n,
	unsigned char *B, int p, int q, int s,
	double *pix_i, double *pix_j, int N
)
	
{
	
	register int i, j, k, l; 
	
	register int ij_center, ij_nei;
	
	int *J;
				
	int *dx, *dy; 

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
	
	for (k = 0; k < s; k++) {
		*(J + k) += *(dy + k) + (*(dx + k) * m);
	}
				  	
	//--
	// PIXEL LOOP
	//--
  				  	
  	for (k = 0; k < N; k++) {
  		
		// center index

  		ij_center = *(pix_i + k) + (*(pix_j + k) * m);
			
		//--
		// NEIGHBORHOOD LOOP
		//--
			
		for (l = 0; l < s; l++) {
		
			// neighbor index
			
        	ij_nei = ij_center + *(J + l);
        	
        	// image data
        	        	
        	*(Y + k + l*N) = *(X + ij_nei);
		}
		
	}

}

// get_neigh_uint8 - get image neighborhood data
// ---------------------------------------------
// 
// Input:
// ------
//  *X - input image
//   m, n - number of rows and columns
//  *B - structuring element matrix
//   p, q - support parameters
//   s - size of structuring element
//  *pix_i, *pix_j - pixel row and column indexes
//   N - number of pixels
//
// Output:
// -------
//  *Y - neighbor data matrix

void get_neigh_uint8 (
	double *Y,
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q, int s,
	double *pix_i, double *pix_j,
	int N
);
	
void get_neigh_uint8 (
	double *Y, 
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q, int s,
	double *pix_i, double *pix_j, int N
)
	
{
	
	register int i, j, k, l; 
	
	register int ij_center, ij_nei;
	
	int *J;
				
	int *dx, *dy; 

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
	
	for (k = 0; k < s; k++) {
		*(J + k) += *(dy + k) + (*(dx + k) * m);
	}
				  	
	//--
	// PIXEL LOOP
	//--
  				  	
  	for (k = 0; k < N; k++) {
  		
		// center index

  		ij_center = *(pix_i + k) + (*(pix_j + k) * m);
			
		//--
		// NEIGHBORHOOD LOOP
		//--
			
		for (l = 0; l < s; l++) {
		
			// neighbor index
			
        	ij_nei = ij_center + *(J + l);
        	
        	// image data
        	        	
        	*(Y + k + l*N) = (double) *(X + ij_nei);
		}
		
	}

}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

//
// get_neigh_ - get neighbor data for image pixels
// -----------------------------------------------
//
// Y = get_neigh_double(X,SE,i,j)
//
// Input:
// ------
//  X - input image 
//  SE - structuring element
//  i,j - image row and column indexes
//
// Output:
// -------
//  Y - neighborhood data array

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
		
	double *Y;
	
	double *X; unsigned char *X8; int m, n;
	
	unsigned char *B;  int p, q, s;
			
	double *pix_i, *pix_j;  int N;
	
	int k;

	//--
	// UINT8 image
	//--
	
	if (mxIsUint8(prhs[0])) {

		//--
		// INPUT
		//--

		// input image

  		X8 = (unsigned char *) mxGetPr(prhs[0]);
		
		m = mxGetM(prhs[0]);
  		n = mxGetN(prhs[0]);

		// structuring element
			
		if (mxIsUint8(prhs[1])) {
  			B = (unsigned char *) mxGetPr(prhs[1]);
  		} else {
  			mexErrMsgTxt("Structuring element must be of class UINT8.");
  		}
					
		p = (mxGetM(prhs[1]) - 1)/2;
		q = (mxGetN(prhs[1]) - 1)/2;

		//--
		// size of structuring element
		//--

		s = 0;
	
		for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
			if (*(B + k)) {
				s++;
			}
		}
						  			
		// index vectors
						  		
  		pix_i = mxGetPr(prhs[2]);
  		pix_j = mxGetPr(prhs[3]);
	
  		N = mxGetM(prhs[2])*mxGetN(prhs[2]);

		//--
		// neighborhood data
		//--
	  			
		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(N, s, mxREAL));

  		//--
  		// COMPUTATION
  		//--
  	  	  	  	
  		get_neigh_uint8 (Y, X8, m, n, B, p, q, s, pix_i, pix_j, N);

	} else {

		//--
		// INPUT
		//--

		// input image

  		X = mxGetPr(prhs[0]);
		
		m = mxGetM(prhs[0]);
  		n = mxGetN(prhs[0]);

		// structuring element
			
		if (mxIsUint8(prhs[1])) {
  			B = (unsigned char *) mxGetPr(prhs[1]);
  		} else {
  			mexErrMsgTxt("Structuring element must be of class UINT8.");
  		}
					
		p = (mxGetM(prhs[1]) - 1)/2;
		q = (mxGetN(prhs[1]) - 1)/2;

		//--
		// size of structuring element
		//--

		s = 0;
	
		for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
			if (*(B + k)) {
				s++;
			}
		}
						  			
		// index vectors
						  		
  		pix_i = mxGetPr(prhs[2]);
  		pix_j = mxGetPr(prhs[3]);
	
  		N = mxGetM(prhs[2])*mxGetN(prhs[2]);

		//--
		// neighborhood data
		//--
	  			
		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(N, s, mxREAL));

  		//--
  		// COMPUTATION
  		//--
  	  	  	  	
  		get_neigh_double (Y, X, m, n, B, p, q, s, pix_i, pix_j, N);

	}

}

