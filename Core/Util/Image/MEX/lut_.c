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

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

// lut_dd - double to double look up table
// ---------------------------------------
// 
// Input:
// ------
//  X - pointer to input
//  nX - length of input
//  L - pointer to look up table
//  nL - length of look up table
//  a,b - lower and upper limits for look up
//  Z - computation mask
//
// Output:
// -------
//  Y - pointer to value array

int lut_dd (
	double *Y,
	double *X, int nX,
	double *L, int nL, double a, double b,
	unsigned char *Z
);

int lut_dd (
	double *Y,
	double *X, int nX,
	double *L, int nL, double a, double b,
	unsigned char *Z
)

{

	register double nan, h;

	register int k; 

	register int ix;
	
	register double pos, frac;
		
	//--
	// get value of NaN once
	//--

	nan = mxGetNaN();

	//--
	// compute table grid spacing
	//--

	h = (b - a) / (nL - 1);

	//--
	// FULL COMPUTATION
	//--
			
	if (Z == NULL) {
	
		//--
		// INDEX LOOP
		//--

		for (k = 0; k < nX; k++) {

			//--
			// compute table position
			//--
			
			// table position

			pos  = (*(X + k) - a) / h;
			
			// separate integer and fractional parts of position

			ix = (int) pos;

			frac = pos - (double) ix;
						
			//--
			// look up table value
			//--
			
			// within table range (interpolate using table if needed)

			if ((ix >= 0) && (ix < (nL - 1))) {
																
				if (frac) {
					*(Y + k) = (*(L + ix) * (1 - frac)) + (*(L + ix + 1) * frac);
				} else {
					*(Y + k) = *(L + ix);
				}
			
			// last element of table

			} else if (ix == (nL - 1)) {
			
				if (frac) {
					*(Y + k) = nan;
				} else {
					*(Y + k) = *(L + ix);
				}
			
			// outside of table range

			} else {
			
				*(Y + k) = nan;
				
			}				
		
		}
	
	//--
	// MASKED COMPUTATION 
	//--
		
	} else {
	
		for (k = 0; k < nX; k++) {

			//--
			// MASK SELECTION
			//--

			if (*(Z + k)) {
			
				//--
				// compute table position
				//--
				
				// table position

				pos  = (*(X + k) - a) / h;
				
				// integer and fractional parts

				ix = (int) pos;
				frac = pos - (double) ix;
				
				//--
				// look up table value
				//--
				
				// within table range (interpolate using table if needed)
				
				if ((ix >= 0) && (ix < (nL - 1))) {
																	
					if (frac) {
						*(Y + k) = (*(L + ix) * (1 - frac)) + (*(L + ix + 1) * frac);
					} else {
						*(Y + k) = *(L + ix);
					}
							
				// last element of table

				} else if (ix == (nL - 1)) {
				
					if (frac) {
						*(Y + k) = nan;
					} else {
						*(Y + k) = *(L + ix);
					}
				
				// outside of table range

				} else {
				
					*(Y + k) = nan;
				
				}
				
			} else {
			
				//--
				// zero default value
				//--
				
				*(Y + k) = 0;
			
			}				
		
		}
	
	}
				
}

// lut_ud - integer index to double value look up table
// ------------------------------------------------------
// 
// Input:
// ------
//  *X - pointer to index array 
//  nX - length of index array
//  *L - pointer to integer look up table
//  *Z - computation mask
//
// Output:
// -------
//  *Y - pointer to value array

void lut_ud (
	double *Y,
	unsigned char *X, int nX,
	double *L, 
	unsigned char *Z
);

void lut_ud (
	double *Y,
	unsigned char *X, int nX,
	double *L,
	unsigned char *Z
)

{

	register int k;

	//--
	// FULL COMPUTATION 
	//--
	
	if (Z == NULL) {
	
		//--
		// INPUT LOOP
		//--

		for (k = 0; k < nX; k++) {
			
			// look up value in table

			*(Y + k) = *(L + *(X + k));
			
		}
	
	//--
	// MASKED COMPUTATION
	//--
		
	} else {
	
		//--
		// INPUT LOOP
		//--

		for (k = 0; k < nX; k++) {
		
			if (*(Z + k)) {
			
				// look up value in table
				
				*(Y + k) = *(L + *(X + k));
				
			} else {
				
				// default zero value
				
				*(Y + k) = 0;
				
			}
			
		}
	
	}

}

// lut_uu - uint8 to uint8 look up table
// -------------------------------------
// 
// Input:
// ------
//  *X - pointer to index array 
//  nX - length of index array
//  *L - pointer to look up table
//  *Z - computation mask
//
// Output:
// -------
//  *Y - pointer to value array

void lut_uu (
	unsigned char *Y,
	unsigned char *X, int nX,
	unsigned char *L,
	unsigned char *Z
);

void lut_uu (
	unsigned char *Y,
	unsigned char *X, int nX,
	unsigned char *L,
	unsigned char *Z
)

{

	register int k;
	
	//--
	// FULL COMPUTATION 
	//--
	
	if (Z == NULL) {
	
		//--
		// INPUT LOOP
		//--

		for (k = 0; k < nX; k++) {
		
			// look up value in table

			*(Y + k) = *(L + *(X + k));
			
		}
	
	//--
	// MASKED COMPUTATION
	//--
		
	} else {
	
		//--
		// INPUT LOOP
		//--

		for (k = 0; k < nX; k++) {
		
			//--
			// MASK SELECTION
			//--

			if (*(Z + k)) {
			
				// look up value in table
				
				*(Y + k) = *(L + *(X + k));
				
			} else {
				
				// default zero value
				
				*(Y + k) = 0;
				
			}
			
		}
	
	}
		
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// lut_uint8 - apply look up table to image
// ----------------------------------------
// 
// Y = lut_(X,L,Z)
//   = lut_(X,L,a,b,Z)
//
// Input:
// ------
//  X - input image
//  L - look up table
//  a,b - lower and upper limits for look up
//  Z - computation mask
//
// Output:
// -------
//  Y - looked up image
//

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	unsigned char *Y8; double *Y;
			
	unsigned char *X8; double *X; int mX, nX;
	
	unsigned char *L8; double *L; int nL; double *tmp, a, b;
	
	unsigned char *Z;
	
	//--
	// UINT8 image
	//--

	if (mxIsUint8(prhs[0])) {

		//--
		// INPUT
		//--
	
		//--
		// input image 
		//--

		X8 = (unsigned char *) mxGetPr(prhs[0]);

		mX = mxGetM(prhs[0]);
		nX = mxGetN(prhs[0]);
		
		//--
		// look up table
		//--
		
		if (mxIsUint8(prhs[1])) {
			L8 = (unsigned char *) mxGetPr(prhs[1]);
		} else if (mxIsDouble(prhs[1])) {
			L = mxGetPr(prhs[1]);
		}
		  	
		// check size of table
		  	
		if ((nL = mxGetM(prhs[1]) *  mxGetN(prhs[1])) != 256) {
			mexErrMsgTxt("Look up table must be of length 256.");
		}
		
		//--
		// mask
		//--
		
		if (nrhs > 2) {
		
			//--
			// empty mask
			//--
			
			if (mxIsEmpty(prhs[2])) {
			
		  		Z = NULL;
		  	
		  	//--
		  	// mask array
		  	//--
		  	
		  	} else {
		  		
			  	if (mxIsUint8(prhs[2])) {
			  		Z = (unsigned char *) mxGetPr(prhs[2]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class UINT8.");
			  	}

				// check size of mask

			  	if ((mX != mxGetM(prhs[2])) || (nX != mxGetN(prhs[2]))) {
					mexErrMsgTxt("Input image and mask must be of the same size.");
				}
				
			}
			
		  	
		} else {
		
			//--
			// default empty mask
			//--
		
			Z = NULL;
		
		}
									  		
  		//--
  		// compute depending on type of look up table
  		//--
  	
  		if (mxIsUint8(prhs[1])) {
  
  			//--
  			// OUTPUT
  			//--
  			
  			Y8 = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericMatrix(mX, nX, mxUINT8_CLASS, mxREAL));
  			
  			//--
  			// COMPUTATION
  			//--
  			
  			lut_uu (Y8, X8, (mX * nX), L8, Z);
  			
  		} else if (mxIsDouble(prhs[1])) {
  		  	
  		  	//--		
  		  	// OUTPUT
  		  	//--
  		  	
  			Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(mX, nX, mxREAL));
  			
  			//--
  			// COMPUTATION
  			//--
  			
  			lut_ud (Y, X8, (mX * nX), L, Z);
  			
  		}

	//--
	// DOUBLE image
	//--

	} else {

		//--
		// INPUT
		//--
		
		//--	
		// input image 
		//--
				  
		X = mxGetPr(prhs[0]);

		mX = mxGetM(prhs[0]);
		nX = mxGetN(prhs[0]);

		//--
		// look up table
		//--
		
		// table
		
		L = mxGetPr(prhs[1]);

		nL = mxGetM(prhs[1]) * mxGetN(prhs[1]);
		
		// lower and upper limits for table
		
		tmp = mxGetPr(prhs[2]);
		a = *tmp; 
		b = *(tmp + 1);

		//--  					  			
		// mask
		//--
							
		if (nrhs > 3) {
		
			//--
			// empty mask
			//--
			
			if (mxIsEmpty(prhs[3])) {
			
		  		Z = NULL;
		  	
		  	//--
		  	// mask array
		  	//--
		  	
		  	} else {

			  	if (mxIsUint8(prhs[3])) {
			  		Z = (unsigned char *) mxGetPr(prhs[3]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class UINT8.");
			  	}
			  	
			  	// check size of mask
			  	
			  	if ((mX != mxGetM(prhs[3])) || (nX != mxGetN(prhs[3]))) {
					mexErrMsgTxt("Input image and mask must be of the same size.");
				}
				
			}
			
		  	
		} else {
		
			//--
			// default empty mask
			//--
		
			Z = NULL;
		
		}
  		
		//--
		// OUTPUT
		//--
	
		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(mX,nX,mxREAL));
	
		//--
		// COMPUTATION
		//--
	
		lut_dd (Y, X, (mX * nX), L, nL, a, b, Z);

	}

}



