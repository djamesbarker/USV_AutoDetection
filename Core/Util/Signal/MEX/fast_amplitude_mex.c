#include "mex.h"

#include "math.h"

//--------------------------------------
// ZERO_CROSSINGS
//--------------------------------------

// NOTE: it is not clear if we gain much from the MEX here

void zero_crossings (double *ZC, double *X, const int N) {

	int k; int zc = 0; double neg;
	
	if (X[0] < 0.0) {
		neg = 1;
	} else {
		neg = 0;
	}
	
	for (k = 1; k < N - 1; k++) {
		if (neg && (X[k] > 0.0)) {
			zc++; neg = 0;
		} else if (!neg && (X[k] < 0.0)) {
			zc++; neg = 1;
		}
	}
	
}   

//--------------------------------------
// FAST_MIN_MAX
//--------------------------------------

void fast_min_max (double *Lk, double *Uk, double *X, const int N) {

	int k; double x1, x2, xx; double L, U;
	
	// NOTE: initialize limits to first entry
	
	L = U = *X;
	
	for (k = 0; k < N - 1; k = k + 2) {
		        
		x1 = *(X + k); x2 = *(X + k + 1);
		
		// NOTE: sort next pair to consider and update min and max
		
		if (x1 > x2) { xx = x1; x1 = x2; x2 = xx; }

		if (x1 < L) { L = x1; }
		
		if (x2 > U) { U = x2; }
		
	}
	
	// NOTE: consider the odd-length case
	
	if (N % 2) {
	
		xx = *(X + N - 1);
						
		if (xx < L) {
			L = xx;
		} else if (xx > U) {
			U = xx;
		}
		
	}
	
	*Lk = L; *Uk = U;
	
}   

//--------------------------------------
// POS_NEG_MEANS
//--------------------------------------

void pos_neg_means (double *Nk, double *Pk, double *X, const int N, double *W) {

	int k; double Sp, Sn, Wp, Wn; 
	
	Sp = Sn = Wp = Wn = 0.0;
	
	// NOTE: accumulate then normalize positive and negative sums
	
	if (W != NULL) {
	
		for (k = 0; k < N; k++) {   

			if (X[k] > 0) {		
				Wp += W[k]; Sp += X[k] * W[k];
			} else if (X[k] < 0) {	
				Wn += W[k]; Sn += X[k] * W[k];	
			} 

		}
		
	} else {
		
		for (k = 0; k < N; k++) {   

			if (X[k] > 0) {		
				Wp++; Sp += X[k];	
			} else if (X[k] < 0) {	
				Wn++; Sn += X[k];	
			} 

		}
		
	}
	
	// NOTE: normalize positive and negative sums

	if (Wp) { Sp /= Wp; }

	if (Wn) { Sn /= Wn; }
	
	*Nk = Sn; *Pk = Sp;
	
}


//--------------------------------------
// FAST_BOX_AMPLITUDE
//--------------------------------------

// NOTE: we need a couple more tables and operations to handle the sign

void fast_box_amplitude (
	 double *means, int L, double * X, int nX, int nH, int overlap)
{
    
    int k, ix, inc; 
	
	double *Cp, *Cn; long long int *Np, *Nn;
	
	//--
	// allocate and fill tables
	//--

	if ((Cp = mxMalloc(nX * sizeof(double))) == NULL) {
		mexErrMsgTxt("Failed to allocate cumulative sum table.");
	}
	
	if ((Cn = mxMalloc(nX * sizeof(double))) == NULL) {
		mexErrMsgTxt("Failed to allocate cumulative sum table.");
	}
	
	if (X[k] >= 0) {
		Cp[0] = X[0]; Cn[0] = 0.0; Np[0]++; 
	} else {
		Cp[0] = 0.0; Cn[0] = X[0]; Nn[0]++;
	}
	
	for (k = 1; k < nX; k++) {
	
		// NOTE: zeros do not update any tables
		
		if (X[k] == 0.0) {
			
			Cp[k] = Cp[k - 1]; Cn[k] = Cn[k - 1]; 
			Np[k] = Np[k - 1]; Nn[k] = Nn[k - 1];
			
			continue;
			
		}
		
		if (X[k] > 0) {
			
			Cp[k] = Cp[k - 1] + X[k]; Cn[k] = Cn[k - 1]; 
			Np[k] = Np[k - 1] + 1   ; Nn[k] = Nn[k - 1];
			
		} else {
			
			Cp[k] = Cp[k - 1]; Cn[k] = Cn[k - 1] + X[k];
			Np[k] = Np[k - 1]; Nn[k] = Nn[k - 1] + 1;
		}
		
	}
	
	//--
	// compute box averages using tables
	//--
	
	
    ix = 0; inc = nH - overlap;

	for (k = 1; k < (L + 1); k++) {

		means[k] = Cn[ix + nH] - Cn[ix];
		
		means[k + L] = Cp[ix + nH] - Cp[ix];

		ix += inc;

	}
	
}

//--------------------------------------
// FAST_AMPLITUDE
//--------------------------------------

void fast_amplitude (
    double *means, double *extremes, int L, double * X, int nX, double * H, int nH, int overlap)
{
    
    int k, ix, inc;
    
    ix = 0; inc = nH - overlap;

	for (k = 0; k < L; k++) {

		pos_neg_means(means + k, means + k + L, X + ix, nH, H);

		if (extremes != NULL) {
			fast_min_max(extremes + k, extremes + k + L, X + ix, nH);
		}
		
		ix += inc;

	}
    
}

//--------------------------------------
// MEX FUNCTION
//--------------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	double *means, *extremes; int k, L;
    
    double *X; int nX;
    
	double *H, Sh, O; int nH;

	int block_size, block_overlap;
	
    //--
	// HANDLE INPUT
	//--
	
	if (nlhs < 1) {
        return;    
	}
	
	// SIGNAL

	X = (double *) mxGetData(prhs[0]); 
	
	nX = mxGetM(prhs[0]) * mxGetN(prhs[0]);

    // WINDOW

	H = (double *) mxGetData(prhs[1]);
	
	nH = mxGetM(prhs[1]) * mxGetN(prhs[1]);
    
    block_size = nH;
	
	// NOTE: when the window is nearly a box, there is no window, otherwise normalize
	
	for (k = 0; k < nH; k++) {
		Sh += H[k]; O =+ fabs(H[k] - 1.0);
	}
	
	if (O < 0.0001) {
		H = NULL;
	} else {
		for (k = 0; k < nH; k++) {
			H[k] /= Sh;
		}
	}

	// OVERLAP
	
    // NOTE: get block overlap or set no overlap default

    block_overlap = nrhs > 2 ? (int) mxGetScalar(prhs[2]) : 0;
	
    // NOTE: compute the number of output points, the expressions are equivalent

	L = (nX - block_overlap) / (block_size - block_overlap);
	
	// L = 1 + ((nX - block_size) / (block_size - block_overlap));
	
    //--
	// OUTPUT
	//--
    
	// MEANS
	
	plhs[0] = mxCreateNumericMatrix(0, 0, mxDOUBLE_CLASS, mxREAL);
    
    mxSetM(plhs[0], L); mxSetN(plhs[0], 2);
    
    means = (double *) mxCalloc(2 * L, sizeof(double));	
	
	// EXTREMES
	
    if (nlhs < 2) {
        
		extremes = NULL;
		
	} else {
		
        plhs[1] = mxCreateNumericMatrix(0, 0, mxDOUBLE_CLASS, mxREAL);
        
        mxSetM(plhs[1], L); mxSetN(plhs[1], 2);
        
        extremes = (double *) mxCalloc(2 * L, sizeof(double));
        
    }   
   
	//--
	// COMPUTE
	//--

    fast_amplitude(means, extremes, L, X, nX, H, nH, block_overlap);
   
    mxSetData(plhs[0], means);
    
    if (nlhs > 1) { mxSetData(plhs[1], extremes); }
    
}
