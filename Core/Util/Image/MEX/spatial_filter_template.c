//----------------------------------------------
// INCLUDE
//----------------------------------------------

#include "mex.h"

#include "matrix.h"

//----------------------------------------------
// DEFINE
//----------------------------------------------

#define INPUT_TYPE

#define MX_INPUT_CLASS

#define OUTPUT_TYPE

#define MX_OUTPUT_CLASS

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------
		 
// NE_size - neighborhood size
// ---------------------------
//
// Input:
// ------
//  *NE - pointer to neighborhood array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - neighborhood support parameters (int)
//
// Output:
// -------
//  s - size of neighborhood (int)

int NE_size(
	unsigned char *NE, int p, int q
);

int NE_size(
	unsigned char *NE, int p, int q
)

{
	
	int s = 0, k;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(NE + k)) s++;
	}
	
	return s;
	
}

// NE_vec - neighborhood displacement vectors 
// ------------------------------------------
//
// Input:
// ------
//  *NE - pointer to neighborhood array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - neighborhood support parameters (int)
//
// Output:
// -------
//  n - size of neighborhood (int)

int NE_vec(
	unsigned char *Vx, unsigned char *Vy,
	unsigned char *NE, int p, int q
);

int NE_vec(
	unsigned char *Vx, unsigned char *Vy,
	unsigned char *NE, int p, int q
)

{
	
	int s, i, j, k;
	
	s = NE_size(NE, p, q);
	
	if (s == 0) {
		Vx = NULL; Vy = NULL; return s;
	}
	
	Vx = (int *) mxCalloc(s, sizeof(int)); 
	Vy = (int *) mxCalloc(s, sizeof(int));
	
	k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {
	
		if (*(NE + i + (2*p + 1)*j)) {
			*(Vy + k) = i - p; *(Vx + k) = j - q; k++;
		}
		
	}
	}
	
	return s;
	
}

// NE_jump - neighborhood index jumps
// ----------------------------------
//
// Input:
// ------
//  *Vx, *Vy - displacement vectors (int *, s)
//  s - size of neighborhood (int)
//  m - number of image rows (int)
//
// Output:
// -------
//  *J - index jumps for processing image with neighborhood

void NE_jump(
	int *J,
	unsigned char *Vx, unsigned char *Vy, int s,
	int m
);

void NE_jump(
	int *J,
	unsigned char *Vx, unsigned char *Vy, int s,
	int m
)

{
	
	int k;
	
	J = mxCalloc(s, sizeof(int));
	
	for (k = 0; k < s; k++) {
		*(J + k) = *(Vy + k) + (*(Vx + k) * m);
	}
	
}

// spatial_filter - spatial filter base
// ------------------------------------
// 
// Input:
// ------
//  *X0 - pointer to image array  (INPUT_TYPE *, (m * n))
//  m, n - number of image rows and columns (int)
//  *NE - pointer to neighborhood array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - neighborhood support parameters (int)
//  *Z - pointer to mask array (unsigned char *, (m * n))
//
// Output:
// -------
//  *X1 - pointer to filtered image (OUTPUT_TYPE *, (m - 2*p)*(n - 2*q))

void spatial_filter (
	OUTPUT_TYPE *X1,
	INPUT_TYPE *X0, int m, int n,
	unsigned char *NE, int p, int q
);
	
void spatial_filter (
	OUTPUT_TYPE *X1,
	INPUT_TYPE *X0, int m, int n,
	unsigned char *NE, int p, int q
)

{
	 
	//------------------------
	// DECLARE
	//------------------------
	
	int s, *Vx, *Vy, *J;
	
	int i, j, k; int ij0, ij1;
	
	OUTPUT_TYPE res;  

	//------------------------
	// SETUP
	//------------------------
	
	s = NE_vec(Vx, Vy, NE, p, q); NE_jump(J, Vx, Vy, s);
	
	//------------------------
	// COMPUTE
	//------------------------
		
	for (j = q; j < (n - q); j++) {
	for (i = p; i < (m - p); i++) {

		//--
		// compute input and output indices
		//--

		ij0 = i + (j * m); ij1 = (i - p) + ((j - q) * (m - 2*p));

		//--
		// perform neighborhood computation
		//--
		
		res = (OUTPUT_TYPE) *(X0 + ij0);

		for (k = 0; k < s; k++) {
			value = *(X0 + ij0 + *(J + k)); if (value > res) res = value;
		}

		//--
		// store result in output
		//--

		*(X1 + ij1) = (OUTPUT_TYPE) res;

	}
	}
	
	//------------------------
	// CLEAN UP
	//------------------------
	
	mxFree(Vx); mxFree(Vy); mxFree(J);
	
}

// spatial_filter_mask - spatial filter with mask base
// ---------------------------------------------------
// 
// Input:
// ------
//  *X0 - pointer to image array  (INPUT_TYPE *, (m * n))
//  m, n - number of image rows and columns (int)
//  *NE - pointer to neighborhood array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - neighborhood support parameters (int)
//  *Z - pointer to mask array (unsigned char *, (m * n))
//
// Output:
// -------
//  *X1 - pointer to filtered image (OUTPUT_TYPE *, (m - 2*p)*(n - 2*q))

void spatial_filter_mask (
	OUTPUT_TYPE *X1,
	INPUT_TYPE *X0, int m, int n,
	unsigned char *NE, int p, int q,
	unsigned char *Z
);
	
void spatial_filter_mask (
	OUTPUT_TYPE *X1,
	INPUT_TYPE *X0, int m, int n,
	unsigned char *NE, int p, int q,
	unsigned char *Z
)

{
	 
	//------------------------
	// DECLARE
	//------------------------
	 
	int s, *Vx, *Vy, *J;
	
	int i, j, k; int ij0, ij1;
	
	OUTPUT_TYPE res;  

	//------------------------
	// SETUP
	//------------------------
	
	s = NE_vec(Vx, Vy, NE, p, q); NE_jump(J, Vx, Vy, s);
	
	//------------------------
	// COMPUTE
	//------------------------
		
	for (j = q; j < (n - q); j++) {
	for (i = p; i < (m - p); i++) {

		//--
		// compute input and output indices
		//--

		ij0 = i + (j * m); ij1 = (i - p) + ((j - q) * (m - 2*p));

		//--
		// perform neighborhood computation if needed
		//--

		res = *(X0 + ij0);

		if (*(Z + ij0)) {
			for (k = 0; k < s; k++) {
				value = *(X0 + ij0 + *(J + k)); if (value > res) res = value;
			}
		}

		//--
		// store result in output
		//--
		
		*(X1 + ij1) = res;

	}
	}
	
	//------------------------
	// CLEAN UP
	//------------------------
	
	mxFree(Vx); mxFree(Vy); mxFree(J);
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// Input:
// ------
//  X0 - input image
//  SE - neighborhood
//  Z - mask image (def: [])
//
// Output:
// -------
//  X1 - output image
//

void mexFunction(
	int nlhs, mxArray *plhs[], 
	int nrhs, const mxArray *prhs[]
)

{
	
	//------------------
	// DECLARE
	//------------------
	
	OUTPUT_TYPE *X1; INPUT_TYPE *X0; unsigned char *Z; int m, n; int mn[2];
	
	unsigned char *NE; int p, q;

	//------------------
	// GET INPUT
	//------------------

	// IMAGE
	
	// TODO: check input type using matlab array class
	
	X0 = (INPUT_TYPE *) mxGetPr(prhs[0]); 
	
	m = mxGetM(prhs[0]); n = mxGetN(prhs[0]);
	
	// NEIGHBORHOOD
	
	if !mxIsUint8(prhs[1]) {
		mexErrMsgTxt("Neighborhood matrix must be of class uint8.");
	}
	
	NE = (unsigned char *) mxGetPr(prhs[1]); 
	
	p = (mxGetM(prhs[1]) - 1) / 2; q = (mxGetN(prhs[1]) - 1) / 2;
		
	// MASK
							
	if (nrhs > 2) {
		
		if mxIsEmpty(prhs[2]) {
			
			Z = NULL;
		  		
		} else {
		  	
			if !mxIsUint8(prhs[2]) {
				mexErrMsgTxt("Mask must be of class uint8.");
			}
			
			Z = (unsigned char *) mxGetPr(prhs[2]);
			
			if (m != mxGetM(prhs[2])) || (n != mxGetN(prhs[2])) {
				mexErrMsgTxt("Image and mask must be of the same size.");
			}
			
		}
		
	} else {
		
		Z = NULL;
		
	}
		
	//------------------
	// ALLOCATE OUTPUT
	//------------------
		
	// FILTERED IMAGE
  		
	*mn = (m - 2*p); *(mn + 1) = (n - 2*q);
  		
	X1 = (OUTPUT_TYPE *) mxGetPr(plhs[0] = mxCreateNumericArray(2, mn, mxUINT8_CLASS, mxREAL));
  	
	//------------------
	// COMPUTE
	//------------------
  	
	if (Z == NULL) {
		spatial_filter (X1, X0, m, n, NE, p, q);
	} else {
		spatial_filter_mask (X1, X0, m, n, NE, p, q, Z);
	}

}

