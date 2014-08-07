//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
	
#include "mex.h"

#include "matrix.h"

#include "stdio.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

void time_to_str (char *str, double time);

void time_to_str (char *str, double time) {
	
	int t, h, m; 
	
	double s;
	
	//--
	// compute hours, minutes, and seconds from time
	//--
	
	// NOTE: a number of implicit casts are used to compute the floor function here
	
	t = time; // get integer time
	
	h = t / 3600; // get number of hours
	
	t = time = time - (h * 3600); // subtract hours from time and get integer time
	
	m = t / 60; // get number of minutes
	
	s = time - (m * 60); // subtract minutes from time to get seconds
	
	// NOTE: to gain precision control separate the fraction of a second from time
	
	// fs = s - (int) s;
	
	//--
	// put values into string
	//--
	
	// NOTE: handle leading zeros for unit minutes and seconds
	
	if (m < 10) {
		if (s < 10) {
			sprintf(str, "%d:0%d:0%0.2f", h, m, s);
		} else {
			sprintf(str, "%d:0%d:%0.2f", h, m, s);
		}
	} else {
		if (s < 10) {
			sprintf(str, "%d:%d:0%0.2f", h, m, s);
		} else {
			sprintf(str, "%d:%d:%0.2f", h, m, s);
		}
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// sec_to_clock_ - convert time to clock string
// --------------------------------------------
//
// C = sec_to_clock_(T);
//
// Input:
// ------
//  T - times
//
// Output:
// -------
//  C - clock strings


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	double *T; 
	
	int m, n, N, ix;
					
	mxArray *C;
		
	char str[32];
	
	//-----------------------
	// INPUT
	//-----------------------

	//--
	// get times
	//--
	
	T = mxGetPr(prhs[0]);

	m = mxGetM(prhs[0]); n = mxGetN(prhs[0]);
		
	N = (m * n);
	
	//-----------------------
	// OUTPUT AND COMPUTATION
	//-----------------------
	
	//--
	// create output cell array
	//--
		
	plhs[0] = C = mxCreateCellMatrix(m, n);
	
	//--
	// loop over input times
	//--
	
	// NOTE: we use a single index since the arrays are the same shape
	
	for (ix = 0; ix < N; ix++) {
		
		//--
		// convert time to clock string
		//--
		
		time_to_str(str, *(T + ix));
		
		//--
		// store string in cell array
		//--
		
		// NOTE: this is probably the most "intensive" line in this code
		
		mxSetCell(C, ix, mxCreateString(str));
		
	}
	
}
