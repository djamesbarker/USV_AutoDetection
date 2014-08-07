// TODO: extend to include complex input and filters

//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
		
#include "math.h"

#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

// linear_filter_sparse - sparse linear filtering with masking
// -----------------------------------------------------------
// 
// Input:
// ------
//  X - input image
//  m - number of rows in image 
//  n - number of columns in image
//  F - linear filter
//  p - filter row support parameter
//  q - filter columns support parameter
//  Z - computation mask
//
// Output:
// -------
//  Y - filtered image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 509 $
// $Date: 2005-02-08 20:41:41 -0500 (Tue, 08 Feb 2005) $
//--------------------------------

void linear_filter_sparse (
	double *Y,
	double *X, int m, int n, 
	double *F, int p, int q, 
	unsigned char *Z
);
	
void linear_filter_sparse (
	double *Y,
	double *X, int m, int n, 
	double *F, int p, int q, 
	unsigned char *Z
)

{
	
	int i, j, ij, k;
	
	int *NZ, N;
	
	int S = (2*p + 1) * (2*q + 1);
	
	static double TOL = 0.0001;
	
	double *G; 
	
	int *Vx, *Vy, *J;
				
    register double t;
		    
	//-----------------------------------------------
	// EXTRACT FILTER STRUCTURE
	//-----------------------------------------------
	
	//--
	// get non-zero locations and size of filter
	//--
		
	NZ = (int *) mxCalloc(S, sizeof(int));
	
	N = 0;
	
	for (k = 0; k < S; k++) {		
		if (fabs(*(F + k)) > TOL) {
			*(NZ + k) = 1;
			N++;
		}
	}
		
	//--
	// allocate filter structure output arrays
	//--
		
	// filter values
	
	G = (double *) mxCalloc(N, sizeof(double));
	
	// index jumps
	
	J = (int *) mxCalloc(N, sizeof(int));
	
	// displacement vectors
	
	Vx = (int *) mxCalloc(N, sizeof(int));
	Vy = (int *) mxCalloc(N, sizeof(int));

	//--
	// get values and compute displacement vectors
	//--
		
	// NOTE: this code loops over the support for simplicity
	
	k = 0;

	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {
		
		if (*(NZ + i + (2*p + 1)*j)) {
			
			*(G + k) = *(F + i + (2*p + 1)*j);
			*(Vy + k) = i - p;
			*(Vx + k) = j - q;
			k++;	
			
		}

	}
	}

	//--
	// compute filtering index jumps
	//--

	// NOTE: index jumps are a function of displacement vectors and image size
	
	for (k = 0; k < N; k++) {
		*(J + k) = *(Vy + k) + (*(Vx + k) * m);
	}
	
	//-----------------------------------------------
	// FULL COMPUTATION
	//-----------------------------------------------
	
	if (Z == NULL) {

		//--
		// loop over valid image area 
		//--
		
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  			
			//--
			// compute center location index 
			//--
			
			ij = i + (j * m);
			
			//--
			// loop over sparse filter
			//--
			
			t = 0.0;
			
			for (k = 0; k < N; k++) {
				t += *(G + k) * *(X + ij + *(J + k));
			}
						
            //--
			// save filtering result
            //--
										
			*(Y + (i - p) + ((j - q) * (m - 2*p))) = t;
		
		} 
		}
	
	//-----------------------------------------------
	// MASKED COMPUTATION
	//-----------------------------------------------
	
	} else {
        
        //--
        // loop over valid image area
        //--
	
	  	for (j = q; j < (n - q); j++) {
	  	for (i = p; i < (m - p); i++) {
	  		  	
			//--
			// compute center location index 
			//--
			
			ij = i + (j * m);
			
			//--
			// consider computational mask
			//--
			
	  		if (*(Z + ij)) {
	  	
                //--
				// loop over sparse filter
				//--

				t = 0.0;

				for (k = 0; k < N; k++) {
					t =+ *(G + k) * *(X + ij + *(J + k));
				}

				//--
				// save filtering result
				//--

				*(Y + (i - p) + ((j - q) * (m - 2*p))) = t;

			} else {
						
                //--
				// leave pixel unchanged
                //--
					
				*(Y + (i - p) + ((j - q) * (m - 2*p))) = *(X + ij);
				
			}
		
		} 
		}
	
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// linear_filter_sparse_ - sparse linear filtering with masking
// ------------------------------------------------------------
//
// Y = linear_filter_sparse_(X,F,Z)
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
// $Revision: 509 $
// $Date: 2005-02-08 20:41:41 -0500 (Tue, 08 Feb 2005) $
//--------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	double *X, *Y;
		
	double *F;
	
	int m, n, p, q;
			
	unsigned char *Z;
	
	//-----------------------------------------------
	// INPUT
	//-----------------------------------------------

	//--
	// input image
	//--
	
	X = mxGetPr(prhs[0]);

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

	//-----------------------------------------------
	// OUTPUT 
	//-----------------------------------------------

	//--
	// linearly filtered image
	//--
	
	Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));

	//-----------------------------------------------
	// COMPUTATION
	//-----------------------------------------------

	linear_filter_sparse (Y, X, m, n, F, p, q, Z);

}
