// TODO: this is not an elegant algorithm update to the single scan algorithm using union-find

//----------------------------------------------
// INCLUDE
//----------------------------------------------

#include "stdlib.h"

#include "math.h"	

#include "mex.h"

#include "matrix.h"

//----------------------------------------------
// DEFINITIONS
//----------------------------------------------

#define LUT_SIZE 5000

#define LUT_INCR 500

#define ABS(x) (x < 0 ? -(x) : (x))

#define MIN(x,y) (x < y ? x : y)

#define MAX(x,y) (x > y ? x : y)

#define SIGN(x) (x < 0 ? (-1) : 1)

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

// pos_min - positive min element of array
// ---------------------------------------
// 
// Input:
// ------
//  v - input vector
//  n - length of vector
//
// Output:
// -------
//  m - minimum positive value

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

double pos_min (double *v, int n);

double pos_min (double *v, int n)

{

	register int k = 0; register double m, t;
		
	while ((*(v + k) <= 0) && (k < n)) {
		k++;
	}
	
	if (k == n) {
		return(0);
	} else {
		m = *(v + k);
	}
	
	for (; k < n; k++){
		t = *(v + k);
		if ((t > 0) && (t < m)) {
			m = t;
		}
	}
	
	return (m);

}

// sum - sum of array
// ------------------
// 
// Input:
// ------
//  v - input vector
//  n - length of vector 
//
// Output:
// -------
//  m - sum of vector

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

double sum (double *v, int n);

double sum (double *v, int n)

{

	int k; double m = 0.0;
			
	for (k = 0; k < n; k++){
		m =+ *(v + k);
	}
	
	return (m);

}
	 
// label_4_uint8 - 4 neighbor connected component labelling
// --------------------------------------------------------
// 
// Input:
// ------
//  X - input image 
//  m - number of image rows
//  n - number of image columns
//  Z - computation mask
//
// Output:
// -------
//  Y - label image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void label_4_uint8 (
	double *Y, unsigned char *X, int m, int n);
	
void label_4_uint8 (
	double *Y, unsigned char *X, int m, int n)

{
		
	long int i, j, k, ij, jm;

	long int kn;

	long int l, *lut, lut_size;

	long int tn, tw;  

	double *ptr, W[4], t;

	int flag;
	 
	//--
	// allocate look up table
	//--
	
	lut_size = LUT_SIZE;
	
	lut = mxCalloc(LUT_SIZE, sizeof(long int));
	
	for (k = 0; k < lut_size; k++) {
		*(lut + k) = k;
	}
	
	//------------------------------------------
	// FIRST COLUMN
	//------------------------------------------
	
	//--
	// first pixel
	//--
				
	l = 1;
							
	if (*X) {
		*Y = (double) l++;
	}
	
	//--	
	// rest of column
	//--
					
	for (i = 1; i < m; i++) {
		
		if (*(X + i)) {
		
			t = *(Y + i - 1);
			
			//--
  			// copy current label
  			//--
			
			if (t) {
			
				*(Y + i) = t;
				
			//--
	  		// use a new label
			//--
			
			} else {
			
				*(Y + i) = (double) l++;
				
				if (l > lut_size) {
					lut = mxRealloc(lut,(lut_size + LUT_INCR)*sizeof(long int));
					for (k = lut_size; k < lut_size + LUT_INCR; k++) {
						*(lut + k) = k;
					}
					lut_size = lut_size + LUT_INCR;
				}
				
			}
			
		} 
		
	}
		
	//------------------------------------------
	// INTERNAL COLUMNS
	//------------------------------------------
	
  	for (j = 1; j < n; j++) {
  	
  		jm = j * m;
  		
  		//--	 
  		// first pixel
  		//--
  		 			  		
  		if (*(X + jm)) {
  		
  			t = *(Y + jm - m);
  			
			//--
  			// copy current label
  			//--
			
	  		if (t) {
	  		
	  			*(Y + jm) = t;
	  			
			//--
	  		// use a new label
			//--
	  		
	  		} else {
	  		
	  			*(Y + jm) = (double) l++;
	  			
				//--
				// reallocate label table if needed
				//--
				
	  			if (l > lut_size) {
					
	  				lut = mxRealloc(lut,(lut_size + LUT_INCR)*sizeof(long int));
					
					for (k = lut_size; k < lut_size + LUT_INCR; k++) {
						*(lut + k) = k;
					}
					
					lut_size = lut_size + LUT_INCR;
					
				}
				
	  		}
	  		
	  	}
  		
  		//--	
  		// rest of column
  		//--
  			  		
	  	for (i = 1; i < m; i++) {
	  								
			ij = i + jm;
			
			if (*(X + ij)) {
										
				tn = *((Y + ij) - 1);
				tw = *((Y + ij) - m);
									
				switch ((tn != 0.0) + (tw != 0.0)) {
						
					//--
					// new label
					//--
					
					case 0:
					
						*(Y + ij) = (double) l++;
						
						if (l > lut_size) {
							lut = mxRealloc(lut,(lut_size + LUT_INCR)*sizeof(long int));
							for (k = lut_size; k < lut_size + LUT_INCR; k++) {
								*(lut + k) = k;
							}
							lut_size = lut_size + LUT_INCR;
						}
						
						break;
					
					//--
					// existing label (single label in neighborhood)
					//--
						
					case 1:
					
						*(Y + ij) = (double) MAX(tn,tw);
						
						break;
						
					//--
					// exising label (more than one label in neighborhood)
					//--

					case 2:
						
						if (tn < tw) {
							*(Y + ij) = (double) tn;
							*(lut + tw) = tn;
						} else if (tw < tn){
							*(Y + ij) = (double) tw;
							*(lut + tn) = tw;
						} else {
							*(Y + ij) = (double) tn;
						}
										
				}
			
			}
																			      							
		}
	}
			
	//------------------------------------------
	// REDUCE LOOK UP TABLE
	//------------------------------------------

		for (k = 0; k < l; k++) {
		
			kn = k;
			
			while (*(lut + kn) != kn) {
				*(lut + k) = *(lut + kn);
				kn =  *(lut + kn);
			}
			
		}
										
	//------------------------------------------
	// APPLY LOOK UP TABLE
	//------------------------------------------
	
		for (k = 0; k < (m*n - 1); k++) {
			if (*(ptr = (Y + k))) {
				*ptr = (double) *(lut + (long int) *ptr);
			}
		}
		
	//------------------------------------------
	// UPDATE LOOK UP TABLE
	//------------------------------------------
	
	flag = 1;
		
	while (flag) {
	
		flag = 0;
	
		//------------------------------------------
		// UPDATE LOOK UP TABLE
		//------------------------------------------
		
	  	for (j = 1; j < (n - 1); j++) {
	  	
	  		jm = j * m;
	  			
		  	for (i = 1; i < (m - 1); i++) {
		  								
				ij = i + jm;
									
				if (*(Y + ij)) {
					
					*W = *((Y + ij) - m);
					*(W + 1) = *((Y + ij) - 1);
					*(W + 2) = *((Y + ij) + 1);
					*(W + 3) = *((Y + ij) + m);
					
					t = pos_min(W,4);
					
					if ((t > 0) && (t < *(Y + ij))) {
						*(lut + (long int) *(Y + ij)) = (long int) t;
						 flag = 1;
					}
															
				}
																				      							
			}
			
		}
						
		//------------------------------------------
		// REDUCE LOOK UP TABLE
		//------------------------------------------

		for (k = 0; k < l; k++) {
		
			kn = k;
								
			while (*(lut + kn) != kn) {
				*(lut + k) = *(lut + kn);
				kn =  *(lut + kn);
			}
								
		}
													
		//------------------------------------------
		// APPLY LOOK UP TABLE
		//------------------------------------------
		
		for (k = 0; k < (m*n - 1); k++) {
			if (*(ptr = (Y + k))) {
				*ptr = (double) *(lut + (long int) *ptr);
			}
		}
			
	}
				
}
	 
// label_8_uint8 - 8 neighbor connected component labelling
// --------------------------------------------------------
// 
// Input:
// ------
//  X - input image 
//  m - number of image rows
//  n - number of image columns
//  Z - computation mask
//
// Output:
// -------
//  Y - label image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void label_8_uint8 (
	double *Y, unsigned char *X, int m, int n);
	
void label_8_uint8 (
	double *Y, unsigned char *X, int m, int n)

{
		
	 long int i, j, k, ij, jm;
	
	 long int kn;
	
	 long int l, *lut, lut_size;
			
	 long int t1, t2;  
	
	 double *ptr, W[8], t;
	
	 int flag;
	
	//--
	// allocate look up table
	//--
	
	lut_size = LUT_SIZE;
	
	lut = mxCalloc(LUT_SIZE, sizeof(long int));
	
	for (k = 0; k < lut_size; k++) {
		*(lut + k) = k;
	}
	
	//------------------------------------------
	// FIRST COLUMN
	//------------------------------------------
	
	// first pixel
				
	l = 1;
							
	if (*X) {
		*Y = (double) l++;
	}
		
	// rest of column
					
	for (i = 1; i < m; i++) {
		
		if (*(X + i)) {
		
			t = (long int) *(Y + i - 1);
			
			// existing label
			
			if (t) {
			
				*(Y + i) = (double) t;
				
			// new label
			
			} else {
			
				*(Y + i) = (double) l++;
				
				if (l > lut_size) {
					lut = mxRealloc(lut,(lut_size + LUT_INCR)*sizeof(long int));
					for (k = lut_size; k < lut_size + LUT_INCR; k++) {
						*(lut + k) = k;
					}
					lut_size = lut_size + LUT_INCR;
				}
				
			}
			
		} 
		
	}
		
	//------------------------------------------
	// INTERNAL COLUMNS
	//------------------------------------------
	
  	for (j = 1; j < n; j++) {
  	
  		jm = j * m;
  			 
  		// first pixel
  		 				  		
  		if (*(X + jm)) {
  		
  			t1 = (long int) *(Y + jm - m);
  			t2 = (long int) *(Y + jm - m + 1);
   			
   			switch ((t1 != 0) + (t2 != 0)) {
						
				// new label
								
				case 0:
				
					*(Y + jm) = (double) l++;
					
					if (l > lut_size) {
						lut = mxRealloc(lut,(lut_size + LUT_INCR)*sizeof(long int));
						for (k = lut_size; k < lut_size + LUT_INCR; k++) {
							*(lut + k) = k;
						}
						lut_size = lut_size + LUT_INCR;
					}
					
					break;
				
				// existing label (single label in neighborhood)
										
				case 1:
				
					*(Y + jm) = (double) MAX(t1,t2);
					
					break;
						
				// exising label (more than one label in neighborhood
									
				case 2:
					
					if (t2 < t1) {
						*(Y + jm) = (double) t2;
						*(lut + t1) = t2;
					} else if (t1 < t2){
						*(Y + jm) = (double) t1;
						*(lut + t2) = t1;
					} else {
						*(Y + jm) = (double) t2;
					}
								
			}
   			
	  	}
  			
  		// rest of column
  		  			  		
	  	for (i = 1; i < m; i++) {
	  								
			ij = i + jm;
			
			if (*(X + ij)) {
										
				*W = *((Y + ij) - m - 1);
				*(W + 1) = *((Y + ij) - m);
				*(W + 2) = *((Y + ij) - m + 1);
				*(W + 3) = *((Y + ij) - 1);
				
				switch ((*(W) != 0) + (*(W + 1) != 0) + (*(W + 2) != 0) + (*(W + 3) != 0)) {
						
					// new label
									
					case 0:
					
						*(Y + ij) = (double) l++;
						
						if (l > lut_size) {
							lut = mxRealloc(lut,(lut_size + LUT_INCR)*sizeof(long int));
							for (k = lut_size; k < lut_size + LUT_INCR; k++) {
								*(lut + k) = k;
							}
							lut_size = lut_size + LUT_INCR;
						}
						
						break;
					
					// existing label (single label in neighborhood)
											
					case 1:
					
						*(Y + ij) = pos_min(W,4);
						
						break;
							
					// existing label (more than one label in neighborhood
										
					default:
						
						t1 = *(Y + ij) = pos_min(W,4);
						
						for (k = 0; k < 4; k++) {
							if ((t2 = *(W + k)) && (t2 > t1)) {
								*(lut + (long int) t2) = (long int) t1;
							}
						}					
																
				}
			
			}
																			      							
		}
	}
			
	//------------------------------------------
	// REDUCE LOOK UP TABLE
	//------------------------------------------

		for (k = 0; k < l; k++) {
		
			kn = k;
			
			while (*(lut + kn) != kn) {
				*(lut + k) = *(lut + kn);
				kn =  *(lut + kn);
			}
			
		}
										
	//------------------------------------------
	// APPLY LOOK UP TABLE
	//------------------------------------------
	
		for (k = 0; k < (m*n - 1); k++) {
			if (*(ptr = (Y + k))) {
				*ptr = (double) *(lut + (long int) *ptr);
			}
		}
		
	//------------------------------------------
	// UPDATE LOOK UP TABLE
	//------------------------------------------
	
	flag = 1;
		
	while (flag) {
	
		flag = 0;
	
		//------------------------------------------
		// UPDATE LOOK UP TABLE
		//------------------------------------------
		
	  	for (j = 1; j < (n - 1); j++) {
	  	
	  		jm = j * m;
	  			
		  	for (i = 1; i < (m - 1); i++) {
		  								
				ij = i + jm;
									
				if (*(Y + ij)) {
					
					*W = *((Y + ij) - m - 1);
					*(W + 1) = *((Y + ij) - m);
					*(W + 2) = *((Y + ij) - m + 1);
					*(W + 3) = *((Y + ij) - 1);
					*(W + 4) = *((Y + ij) + 1);
					*(W + 5) = *((Y + ij) + m - 1);
					*(W + 6) = *((Y + ij) + m);
					*(W + 7) = *((Y + ij) + m + 1);
					
					t = pos_min(W,8);
					
					if ((t > 0) && (t < *(Y + ij))) {
						*(lut + (long int) *(Y + ij)) = (long int) t;
						 flag = 1;
					}
															
				}
																				      							
			}
			
		}
						
		//------------------------------------------
		// REDUCE LOOK UP TABLE
		//------------------------------------------

		for (k = 0; k < l; k++) {
		
			kn = k;
								
			while (*(lut + kn) != kn) {
				*(lut + k) = *(lut + kn);
				kn =  *(lut + kn);
			}
								
		}
													
		//------------------------------------------
		// APPLY LOOK UP TABLE
		//------------------------------------------
		
		for (k = 0; k < (m*n - 1); k++) {
			if (*(ptr = (Y + k))) {
				*ptr = (double) *(lut + (long int) *ptr);
			}
		}
			
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// label_uint8 - connected component labelling
// -------------------------------------------
//
// Y = label_uint8(X,nn)
//
// Input:
// ------
//  X - input image
//  nn - number of neighbors 4 or 8
//
// Output:
// -------
//  Y - label image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	 double *Y;
	
	 unsigned char *X;  int m, n, nn;
				
	//------------------------------------------
	// INPUT
	//------------------------------------------
		
	//--
	// input image
	//--

	if (mxIsUint8(prhs[0])) {
		X = (unsigned char *) mxGetPr(prhs[0]);
	} else {
		mexErrMsgTxt("Input image must be of class uint8.");
	}

	m = mxGetM(prhs[0]);
	n = mxGetN(prhs[0]);

	//--
	// number of neighbors
	//--

	nn = (int) mxGetScalar(prhs[1]);

	if ((nn != 4) && (nn != 8)) {
		mexErrMsgTxt("Number of neighbors must be 4 or 8.");
	}			
				
	//------------------------------------------
  	// OUTPUT 
  	//------------------------------------------
  		
	//--
	// label image
	//--

	Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL));
  	
  	//------------------------------------------
  	// COMPUTATION
  	//------------------------------------------
  	
	switch (nn) { 

		//--
		// 4-neighbor computation
		//--
		
		case 4:
			label_4_uint8 (Y, X, m, n);
			break;

		//--
		// 8-neighbor computation
		//--
			
		case 8:
			label_8_uint8 (Y, X, m, n);
			break;

	}

}

