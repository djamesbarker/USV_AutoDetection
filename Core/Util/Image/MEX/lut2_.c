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

// lut2_dd - double to double look up table
// ----------------------------------------
// 
// Input:
// ------
//  X1, X2 - index arrays
//  nX - length of index arrays
//  L - look up table
//  mL, nL - row and columns of look up table
//  a1, b1 - lower and upper limits for lookup on index 1
//  a2, b2 - lower and upper limits for lookup on index 2
//  Z - computation mask
//
// Output:
// -------
//  Y - pointer to value array

int lut2_dd (
	double *Y,
	double *X1, double *X2, int nX,
	double *L, int mL, int nL, double a1, double b1, double a2, double b2,
	unsigned char *Z
);

int lut2_dd (
	double *Y,
	double *X1, double *X2, int nX,
	double *L, int mL, int nL, double a1, double b1, double a2, double b2,
	unsigned char *Z
)

{

	register double h1, h2;

	register int k; 

	register int ix1, ix2, tmp;
	
	register double pos1, pos2, frac1, frac2;
	
	register double nan, y1, y2;
		
	//--
	// get value of NaN once
	//--

	nan = mxGetNaN();

	//--
	// compute table grid spacing
	//--

	h1 = (b1 - a1) / (mL - 1);
	h2 = (b2 - a2) / (nL - 1);

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

			pos1  = (*(X1 + k) - a1) / h1;
			pos2  = (*(X2 + k) - a2) / h2;
			
			// separate integer and fractional parts of position

			ix1 = (int) pos1;
			frac1 = pos1 - (double) ix1;

			ix2 = (int) pos2;
			frac2 = pos2 - (double) ix2;
						
			//--
			// LOOK UP VALUE
			//--

			//--
			// within table range
			//--

			if ((ix1 >= 0) && (ix1 < (mL - 1))
				&& (ix2 >= 0) && (ix2 < (nL - 1))) {
																
				if (frac1) {

					// pos1 and pos2 are fractional indexes, bilinear interpolation

					if (frac2) {

						tmp = ix1 + (ix2 * mL);

						y1 = (*(L + tmp) * (1 - frac1))
							+ (*(L + tmp + 1) * frac1);

						tmp = ix1 + ((ix2 + 1) * mL);

						y2 = (*(L + tmp) * (1 - frac1))
							+ (*(L + tmp + 1) * frac1);

						*(Y + k) = (y1 * (1 - frac2)) + (y2 * frac2);

					// pos1 is a fractional index, linear interpolation

					} else {

						tmp = ix1 + (ix2 * mL);

						*(Y + k) = (*(L + tmp) * (1 - frac1))
							+ (*(L + tmp + 1) * frac1);

					}

				} else {

					// pos2 is a fractional index, linear interpolation

					if (frac2) {

						tmp = ix1 + (ix2 * mL);

						*(Y + k) = (*(L + tmp) * (1 - frac2))
							+ (*(L + tmp + mL) * frac2);

					// no fractional indexes

					} else {

						*(Y + k) = *(L + ix1 + (ix2 * mL));

					}

				}

			//--
			// last row of table
			//--

			} else if ((ix1 == (mL - 1))
				&& (ix2 >= 0) && (ix2 < (nL - 1))) {
				
				// out of table range

				if (frac1) {

					*(Y + k) = nan;

				} else {

					// pos2 is a fractional index, linear interpolation

					if (frac2) {

						tmp = ix1 + (ix2 * mL);

						*(Y + k) = (*(L + tmp) * (1 - frac2))
							+ (*(L + tmp + mL) * frac2);

					// no fractional indexes

					} else {

						*(Y + k) = *(L + ix1 + (ix2 * mL));

					}

				}

			//--
			// last column of table
			//--

			} else if ((ix2 == (nL - 1))
				&& (ix1 >= 0) && (ix1 < (mL - 1))) {
				
				// out of table range

				if (frac2) {

					*(Y + k) = nan;

				} else {

					// pos1 is a fractional index, linear interpolation

					if (frac1) {

						tmp = ix1 + (ix2 * mL);

						*(Y + k) = (*(L + tmp) * (1 - frac1))
							+ (*(L + tmp + 1) * frac1);

					// no fractional indexes

					} else {

						*(Y + k) = *(L + ix1 + (ix2 * mL));

					}
				}
			
			//--
			// last entry of table
			//--

			} else if ((ix1 == (mL - 1)) && (ix2 == (nL - 1))) {

				// out of table range

				if (frac1 || frac2) {

					*(Y + k) = nan;

				} else {

					*(Y + k) = *(L + ix1 + (ix2 * mL));

				}

			//--
			// outside of table range
			//--

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

				pos1  = (*(X1 + k) - a1) / h1;
				pos2  = (*(X2 + k) - a2) / h2;
				
				// separate integer and fractional parts of position

				ix1 = (int) pos1;
				frac1 = pos1 - (double) ix1;
	
				ix2 = (int) pos2;
				frac2 = pos2 - (double) ix2;
				
				//--
				// LOOK UP VALUE
				//--

				if ((ix1 >= 0) && (ix1 < (mL - 1))
					&& (ix2 >= 0) && (ix2 < (nL - 1))) {
																
					if (frac1) {

						// pos1 and pos2 are fractional indexes, bilinear interpolation

						if (frac2) {
	
							tmp = ix1 + (ix2 * mL);
	
							y1 = (*(L + tmp) * (1 - frac1))
								+ (*(L + tmp + 1) * frac1);

							tmp = ix1 + ((ix2 + 1) * mL);

							y2 = (*(L + tmp) * (1 - frac1))
								+ (*(L + tmp + 1) * frac1);

							*(Y + k) = (y1 * (1 - frac2)) + (y2 * frac2);

						// pos1 is a fractional index, linear interpolation

						} else {

							tmp = ix1 + (ix2 * mL);

							*(Y + k) = (*(L + tmp) * (1 - frac1))
								+ (*(L + tmp + 1) * frac1);

						}

					} else {

						// pos2 is a fractional index, linear interpolation

						if (frac2) {

							tmp = ix1 + (ix2 * mL);

							*(Y + k) = (*(L + tmp) * (1 - frac2))
								+ (*(L + tmp + mL) * frac2);

						// no fractional indexes

						} else {

							*(Y + k) = *(L + ix1 + (ix2 * mL));

						}

					}

				//--
				// last row of table
				//--

				} else if ((ix1 == (mL - 1))
					&& (ix2 >= 0) && (ix2 < (nL - 1))) {
				
					// out of table range
	
					if (frac1) {	

						*(Y + k) = nan;

					} else {
	
						// pos2 is a fractional index, linear interpolation

						if (frac2) {
	
							tmp = ix1 + (ix2 * mL);
	
							*(Y + k) = (*(L + tmp) * (1 - frac2))
								+ (*(L + tmp + mL) * frac2);
	
						// no fractional indexes

						} else {

							*(Y + k) = *(L + ix1 + (ix2 * mL));

						}

					}

				//--
				// last column of table
				//--

				} else if ((ix2 == (nL - 1))
					&& (ix1 >= 0) && (ix1 < (mL - 1))) {
					
					// out of table range
	
					if (frac2) {

						*(Y + k) = nan;

					} else {

						// pos1 is a fractional index, linear interpolation
	
						if (frac1) {
	
							tmp = ix1 + (ix2 * mL);
	
							*(Y + k) = (*(L + tmp) * (1 - frac1))
								+ (*(L + tmp + 1) * frac1);

						// no fractional indexes
	
						} else {
	
							*(Y + k) = *(L + ix1 + (ix2 * mL));
	
						}
					}
			
				//--
				// last entry of table
				//--

				} else if ((ix1 == (mL - 1)) && (ix2 == (nL - 1))) {
	
					// out of table range
	
					if (frac1 || frac2) {
	
						*(Y + k) = nan;
	
					} else {
	
						*(Y + k) = *(L + ix1 + (ix2 * mL));
	
					}
	
				//--
				// outside of table range
				//--

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

// lut2_ud - integer index to double value look up table
// ------------------------------------------------------
// 
// Input:
// ------
//  X1, X2 - index arrays 
//  nX - length of index arrays
//  L - pointer to look up table
//  mL, nL - row and columns of look up table
//  Z - computation mask
//
// Output:
// -------
//  Y - pointer to value array

void lut2_ud (
	double *Y,
	unsigned char *X1, unsigned char *X2, int nX,
	double *L, int mL, int nL,
	unsigned char *Z
);

void lut2_ud (
	double *Y,
	unsigned char *X1, unsigned char *X2, int nX,
	double *L, int mL, int nL,
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

			*(Y + k) = *(L + *(X1 + k) + (*(X2 + k) * mL));
			
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
				
				*(Y + k) = *(L + *(X1 + k) + (*(X2 + k) * mL));
				
			} else {
				
				// default zero value
				
				*(Y + k) = 0;
				
			}
			
		}
	
	}

}

// lut2_uu - uint8 to uint8 look up table
// --------------------------------------
// 
// Input:
// ------
//  X1, X2 - index arrays 
//  nX - length of index arrays
//  L - pointer to look up table
//  mL, nL - row and columns of look up table
//  Z - computation mask
//
// Output:
// -------
//  Y - pointer to value array

void lut2_uu (
	unsigned char *Y,
	unsigned char *X1, unsigned char *X2, int nX,
	unsigned char *L, int mL, int nL,
	unsigned char *Z
);

void lut2_uu (
	unsigned char *Y,
	unsigned char *X1, unsigned char *X2, int nX,
	unsigned char *L, int mL, int nL,
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

			*(Y + k) = *(L + *(X1 + k) + (*(X2 + k) * mL));
			
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
				
				*(Y + k) = *(L + *(X1 + k) + (*(X2 + k) * mL));
				
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

// lut2_uint8 - apply look up table to image
// -----------------------------------------
// 
// Y = lut2_(X1,X2,L,Z)
//   = lut2_(X2,X2,L,a1,b1,a2,b2,Z)
//
// Input:
// ------
//  X1,X2 - index images
//  L - look up table
//  a1,b1 - lower and upper look up limits for index 1
//  a2,b2 - lower and upper look up limits for index 2
//  Z - computation mask
//
// Output:
// -------
//  Y - value image
//

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	unsigned char *Y8; double *Y;
			
	unsigned char *X18, *X28; double *X1, *X2; int mX, nX;
	
	unsigned char *L8; double *L; int mL, nL;
	
	double *tmp, a1, b1, a2, b2;
	
	unsigned char *Z;
	
	//--
	// UINT8 images
	//--

	if (mxIsUint8(prhs[0])) {

		//--
		// INPUT
		//--
	
		//--
		// index images
		//--

		X18 = (unsigned char *) mxGetPr(prhs[0]);

		mX = mxGetM(prhs[0]);
		nX = mxGetN(prhs[0]);

		X28 = (unsigned char *) mxGetPr(prhs[1]);

		// check size of index images

		if (mxGetM(prhs[1]) != mX || mxGetN(prhs[1]) != nX) {
			mexErrMsgTxt("Input index images must be of the same size.");
		}
		
		//--
		// look up table
		//--
		
		if (mxIsUint8(prhs[2])) {
			L8 = (unsigned char *) mxGetPr(prhs[2]);
		} else {
			L = mxGetPr(prhs[2]);
		}

		// check size of look up table

		if ((mxGetM(prhs[2]) != 256) || (mxGetN(prhs[2]) != 256)) {
			mexErrMsgTxt("Table must be of size 256x256 for UINT8 input images.");
		}

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
  			
  			lut2_uu (Y8, X18, X28, (mX * nX), L8, mL, nL, Z);
  			
  		} else {
  		  	
  		  	//--		
  		  	// OUTPUT
  		  	//--
  		  	
  			Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(mX, nX, mxREAL));
  			
  			//--
  			// COMPUTATION
  			//--
  			
  			lut2_ud (Y, X18, X28, (mX * nX), L, mL, nL, Z);
  			
  		}

	//--
	// DOUBLE image
	//--

	} else {

		//--
		// INPUT
		//--
		
		//--	
		// index images 
		//--
				  
		X1 = mxGetPr(prhs[0]);

		mX = mxGetM(prhs[0]);
		nX = mxGetN(prhs[0]);

		X2 = mxGetPr(prhs[1]);

		// check size of index images

		if (mxGetM(prhs[1]) != mX || mxGetN(prhs[1]) != nX) {
			mexErrMsgTxt("Input index images must be of the same size.");
		}

		//--
		// look up table
		//--
		
		// table
		
		L = mxGetPr(prhs[2]);

		mL = mxGetM(prhs[2]);
		nL = mxGetN(prhs[2]);
		
		// get lower and upper look up limits
		
		tmp = mxGetPr(prhs[3]);
		a1 = *tmp;
		b1 = *(tmp + 1);

		tmp = mxGetPr(prhs[4]);
		a2 = *tmp;
		b2 = *(tmp + 1);

		//--  					  			
		// mask
		//--
							
		if (nrhs > 7) {
		
			//--
			// empty mask
			//--
			
			if (mxIsEmpty(prhs[7])) {
			
		  		Z = NULL;
		  	
		  	//--
		  	// mask array
		  	//--
		  	
		  	} else {

			  	if (mxIsUint8(prhs[7])) {
			  		Z = (unsigned char *) mxGetPr(prhs[7]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class UINT8.");
			  	}
			  	
			  	// check size of mask
			  	
			  	if ((mX != mxGetM(prhs[7])) || (nX != mxGetN(prhs[7]))) {
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
	
		lut2_dd (Y, X1, X2, (mX * nX), L, mL, nL, a1, b1, a2, b2, Z);

	}

}



