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

// median_uint8 - in-place median computation (quickselect)
// --------------------------------------------------------
// 
// Input:
// ------
//  *x - pointer to data array (*uint8, N)
//  N - length of index array (int)
//
// Output:
// -------
//  median of data array

#define ELEM_SWAP(a,b) {unsigned char t = (a); (a) = (b); (b) = t;}

unsigned char median_uint8(unsigned char x[], int N);

unsigned char median_uint8(unsigned char x[], int N) 

{

	register int low, median, high;
        
	register int middle, ll, hh;

	// set location values
	
    low = 0;
    high = N - 1;
    median = (low + high) / 2;
    
    for (;;) {
    
    	// one element only
    	
        if (high <= low)
        
            return x[median];
            
		// two elements only
		
        if (high == low + 1) {
        
            if (x[low] > x[high]) {
                ELEM_SWAP(x[low], x[high]);
           	}
           	
            return x[median];
            
        }

	    // find median of low, middle and high items, swap into position low
	    
	    middle = (low + high) / 2;
	    
	    if (x[middle] > x[high]) {
	    	ELEM_SWAP(x[middle], x[high]);
	    }
	    
	    if (x[low] > x[high]) {
	    	ELEM_SWAP(x[low], x[high]);
	    }
	    
	    if (x[middle] > x[low]) {
	    	ELEM_SWAP(x[middle], x[low]);
	    }

	    // swap low item (now in position middle) into position (low + 1)
	    
	    ELEM_SWAP(x[middle], x[low + 1]);

	    // nibble from each end towards middle, swapping items when stuck
	    
	    ll = low + 1;
	    hh = high;
    
	    for (;;) {
	    
	        do ll++; while (x[low] > x[ll]);
	        do hh--; while (x[hh]  > x[low]);

	        if (hh < ll) {
	        	break;
	        }

	        ELEM_SWAP(x[ll], x[hh]);
	        
	    }

	    // swap middle item (in position low) back into correct position
	    
	    ELEM_SWAP(x[low], x[hh]);

	    // reset active partition
	    
	    if (hh <= median) {
	        low = ll;
	    }
	        
        if (hh >= median) {
        	high = hh - 1;
        }
	        
	}
	    
}

#undef ELEM_SWAP

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
//  kth smallest element of a array

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

// median_double - in-place median computation (quickselect)
// ---------------------------------------------------------
// 
// Input:
// ------
//  *x - pointer to data array (*double, N)
//  N - length of index array (int)
//
// Output:
// -------
//  

#define ELEM_SWAP(a,b) {double t = (a); (a) = (b); (b) = t;}

double median_double(double x[], int N);

double median_double(double x[], int N) 

{

	register int low, median, high;
        
	register int middle, ll, hh;

	// set location values
	
    low = 0;
    high = N - 1;
    median = (low + high) / 2;
    
    for (;;) {
    
    	// one element only
    	
        if (high <= low)
        
            return x[median];
            
		// two elements only
		
        if (high == low + 1) {
        
            if (x[low] > x[high]) {
                ELEM_SWAP(x[low], x[high]);
           	}
           	
            return x[median];
            
        }

	    // find median of low, middle and high items, swap into position low
	    
	    middle = (low + high) / 2;
	    
	    if (x[middle] > x[high]) {
	    	ELEM_SWAP(x[middle], x[high]);
	    }
	    
	    if (x[low] > x[high]) {
	    	ELEM_SWAP(x[low], x[high]);
	    }
	    
	    if (x[middle] > x[low]) {
	    	ELEM_SWAP(x[middle], x[low]);
	    }

	    // swap low item (now in position middle) into position (low + 1)
	    
	    ELEM_SWAP(x[middle], x[low + 1]);

	    // nibble from each end towards middle, swapping items when stuck
	    
	    ll = low + 1;
	    hh = high;
    
	    for (;;) {
	    
	        do ll++; while (x[low] > x[ll]);
	        do hh--; while (x[hh]  > x[low]);

	        if (hh < ll) {
	        	break;
	        }

	        ELEM_SWAP(x[ll], x[hh]);
	        
	    }

	    // swap middle item (in position low) back into correct position
	    
	    ELEM_SWAP(x[low], x[hh]);

	    // reset active partition
	    
	    if (hh <= median) {
	        low = ll;
	    }
	        
        if (hh >= median) {
        	high = hh - 1;
        }
	        
	}
	    
}

#undef ELEM_SWAP

//
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
//

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
	
	int k;
	
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

  		//--
  		// OUTPUT
  		//--
    	
    	// median
  		  		
  		y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL));
  		
		//--
		// COMPUTATION
		//--

		// buffer image
    	    
		B8 = mxCalloc(N,sizeof(unsigned char));
	    	
		for (k = 0; k < N; k++) {
			*(B8 + k) = *(X8 + k);
		}
  		
  		// compute median
  		
	  	if (N % 2) {
	  		*y = (double) median_uint8(B8,N);
	  	} else {
	  		*y = ((double) kth_smallest_uint8(B8,N,N/2 - 1) + 
				(double) kth_smallest_uint8(B8,N,N/2)) / 2.0;
	  	}

	} else {

		//--
		// INPUT
		//--

		// input image

		X = mxGetPr(prhs[0]);
		N = mxGetM(prhs[0]) * mxGetN(prhs[0]);

  		//--
  		// OUTPUT
  		//--
    	
    	// median
  		  		
  		y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL));
  		
		//--
		// COMPUTATION
		//--

		// buffer image
    	    
		B = mxCalloc(N,sizeof(double));
	    	
		for (k = 0; k < N; k++) {
			*(B + k) = *(X + k);
		}
  		
  		// compute median
  		
	  	if (N % 2) {
	  		*y = median_double(B,N);
	  	} else {
	  		*y = (kth_smallest_double(B,N,N/2 - 1) + kth_smallest_double(B,N,N/2)) / 2.0;
	  	}

	}

}
