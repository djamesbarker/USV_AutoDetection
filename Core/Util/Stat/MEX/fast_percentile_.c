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

// kth_smallest_uint8 - rank computation
// --------------------------------------
//
// Input:
// ------
//  *x - pointer to data array
//  N - size of data array 
//  k - rank
//
// Output:
// -------
//  kth smallest element of data array

#define ELEM_SWAP(a,b) {unsigned char t = (a); (a) = (b); (b) = t;}

unsigned char kth_smallest_uint8 (unsigned char x[], int N, int k);

unsigned char kth_smallest_uint8 (unsigned char x[], int N, int k)

{

	register int i, j, l, m;
    
	register unsigned char tmp;

    l = 0;
    m = N - 1;
    
    while (l < m) {
    
        tmp = x[k];
        
       	i = l;
        j = m;
        
        do {
        
            while (x[i] < tmp) i++;
            while (tmp < x[j]) j--;
            
            if (i<=j) {
                ELEM_SWAP(x[i],x[j]);
                i++;
                j--;
            }
            
        } while (i <= j);
        
        if (j < k) l = i;
        if (k < i) m = j;
        
    }
    
    return x[k];
    
}

#undef ELEM_SWAP

// kth_smallest_double - rank computation
// --------------------------------------
//
// Input:
// ------
//  *x - pointer to data array (double *)
//  N - size of data array (int)
//  k - lowest rank (int)
//
// Output:
// -------
//  kth smallest element of a array (double)

#define ELEM_SWAP(a,b) {double t = (a); (a) = (b); (b) = t;}

double kth_smallest_double (double x[], int N, int k);

double kth_smallest_double (double x[], int N, int k)

{

	register int i, j, l, m;
    
	register double tmp;

    l = 0;
    m = N - 1;
    
    while (l < m) {
    
        tmp = x[k];
        
       	i = l;
        j = m;
        
        do {
        
            while (x[i] < tmp) i++;
            while (tmp < x[j]) j--;
            
            if (i<=j) {
                ELEM_SWAP(x[i],x[j]);
                i++;
                j--;
            }
            
        } while (i <= j);
        
        if (j < k) l = i;
        if (k < i) m = j;
        
    }
    
    return x[k];
    
}

#undef ELEM_SWAP

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
		
	unsigned char *X8, *B8; double *X, *B; int N;
	
	int k, j;
	
	double *y;
	
	//--
	// UINT8 image
	//--

	if (mxIsUint8(prhs[0])) {

		//--
		// INPUT
		//--
	
		// input image
		
		X8 = (unsigned char *) mxGetPr(prhs[0]);
		N = mxGetM(prhs[0]) * mxGetN(prhs[0]);
	  	
	  	// rank (apply index offset)
	  	
		k = ((int) mxGetScalar(prhs[1])) - 1;
		  	
		if ((k < 0) || (k > N - 1)) {
			mexErrMsgTxt("Rank parameter is out of range.");
		}

  		//--
  		// OUTPUT
  		//--
    	
    	// ranked value
  		  		
  		y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL));
    	  		
  		//--
  		// COMPUTATION
  		//--

		// buffer data
    	
    	B8 = mxCalloc(N,sizeof(unsigned char));	
    	
	    for (j = 0; j < N; j++) {
	    	*(B8 + j) = *(X8 + j);
	    }

		// compute kth smallest element
  			
  		*y = kth_smallest_uint8(B8,N,k);

	//--
	// DOUBLE image
	//--

	} else {

		//--
		// INPUT
		//--
	
		// input image
		
		X = mxGetPr(prhs[0]);
		N = mxGetM(prhs[0]) * mxGetN(prhs[0]);
	  	
	  	// rank (apply index offset)
	  	
		k = ((int) mxGetScalar(prhs[1])) - 1;
		  	
		if ((k < 0) || (k > N - 1)) {
			mexErrMsgTxt("Rank parameter is out of range.");
		}

  		//--
  		// OUTPUT
  		//--
    	
    	// ranked value
  		  		
  		y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL));
    	  		
  		//--
  		// COMPUTATION
  		//--

		// buffer data
    	
    	B = mxCalloc(N, sizeof(double));	
    	
		// replace by memcpy ?

	    for (j = 0; j < N; j++) {
	    	*(B + j) = *(X + j);
	    }

		// compute kth smallest element
  			
  		*y = kth_smallest_double(B,N,k);

	}

}
