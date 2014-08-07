//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
	
#include "math.h"
	
#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

// linear - linear edge-stopping function
// --------------------------------------
//
// y = linear(x,scale)
//
// Input:
// ------
//  x - input value
//  scale - scale parameter
//
// Output:
// -------
//  y - function value

// NOTE: this function is not used and is here for documentation

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

double linear (double x, double scale);

double linear (double x, double scale)

{
    
	//--
	// evaluate function
	//--
		
	// NOTE: scale is ignored since it only rescales integration step size
    
	return x;
	
}

// lorentz - lorentz edge-stopping function
// ----------------------------------------
//
// y = lorentz(x,scale)
//
// Input:
// ------
//  x - input value
//  scale - scale parameter
//
// Output:
// -------
//  y - function value

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

double lorentz (double x, double scale);

double lorentz (double x, double scale)

{
		
	//--
	// evaluate function
	//--
	
	// (2 * x) / (2 * scale^2 + x^2)
		
	return (2 * x) / (2 * scale * scale + x * x);
		
}

// tukey - tukey edge-stopping function
// ------------------------------------
//
// y = tukey(x,scale)
//
// Input:
// ------
//  x - input value
//  scale - scale parameter
//
// Output:
// -------
//  y - function value

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

double tukey (double x, double scale);

double tukey (double x, double scale)

{
	
	double y;
	
	//--
	// return quickly for large values
	//--
	
	if (fabs(x) >= scale) {
		return 0.0;
	}
	
	//--
	// evaluate function for values within scale
	//--
	
	// x * (1 - (x / scale)^2)^2
		
	y = (x / scale); 
	y = 1 - (y * y);
	y = x * (y * y);
	
	return y;
	
}

// tukey_lut - look up table evaluation of tukey edge-stopping function
// --------------------------------------------------------------------
//
// y = tukey(x,scale)
//
// Input:
// ------
//  x - input value
//  scale - scale parameter
//
// Output:
// -------
//  y - function value

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

// NOTE: table evaluation of the function is significantly slower and less accurate

double tukey_lut (double x, double scale);

double tukey_lut (double x, double scale)

{
	
	double DELTA = 0.1000000000000000;

	int OFFSET = 10;

	double TUKEY_TABLE[21] = {
		0.0000000000000000,
		0.0361000000000000,
		0.1295999999999999,
		0.2601000000000000,
		0.4096000000000000,
		0.5625000000000000,
		0.7056000000000001,
		0.8281000000000001,
		0.9216000000000000,
		0.9801000000000000,
		1.0000000000000000,
		0.9801000000000000,
		0.9216000000000000,
		0.8281000000000001,
		0.7056000000000001,
		0.5625000000000000,
		0.4096000000000000,
		0.2601000000000000,
		0.1295999999999999,
		0.0361000000000000,
		0.0000000000000000,
	};
	
	//--
	// return quickly for large values
	//--
	
	if (fabs(x) >= scale) {
		return 0.0;
	}
	
	//--
	// piecewise constant evaluation from table
	//--
				
	return x * *(TUKEY_TABLE + ((int) (DELTA * (x / scale)) + OFFSET));
		
}

// huber - huber edge-stopping function
// ------------------------------------
//
// y = huber(x,scale)
//
// Input:
// ------
//  x - input value
//  scale - scale parameter
//
// Output:
// -------
//  y - function value

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

// NOTE: this function because of its compact support can be replaced by a table

double huber (double x, double scale);

double huber (double x, double scale)

{
		
	//--
	// evaluate piecewise function
	//--
	
	if (x >= scale) {
		return 1.0;
	} else if (x <= -scale) {
		return -1.0;
	} else {
		return (x / scale);
	}
	
}

// aniso_filter - anisotropic diffusion iteration
// ----------------------------------------------
// 
// Input:
// ------
//  *X - input image 
//   m - number of rows
//   n - number of columns
//   type - diffusion type
//   scale - gradient scale
//   step - integration step size
//   N - number of iterations 
//
// Output:
// -------
//  *Y - filtered image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void aniso_filter (
	double *Y,
	double *X, int m, int n, int type, double scale, double step, int ITER
);
	
void aniso_filter (
	double *Y,
	double *X, int m, int n, int type, double scale, double step, int ITER
)

{
	
	//--
	// iteration indices
	//--
	
	int it;
	
	register int i, j;
	
	//--
	// temporary values
	//--
	
	register int ix;
	
	register double C, N, S ,E, W, U;
					 
	//----------------------------------------
	// SETUP
	//----------------------------------------
	
	//--
	// initialize output to initial conditions
	//--
	
	for (j = 0; j < n; j++) {
	for (i = 0; i < m; i++) {
		ix = i + (j * m); 
		*(Y + ix) = *(X + ix);
	}
	}
			
	//----------------------------------------
	// ITERATION LOOP
	//----------------------------------------
	
	for (it = 0; it < ITER; it++) {

		//----------------------------------------
		// IMAGE LOOP
		//----------------------------------------
		
		// NOTE: there are some issues regarding the boundary conditions
		
	  	for (j = 1; j < (n - 1); j++) {
	  	for (i = 1; i < (m - 1); i++) {

            //----------------------------------------
			// COMPUTE UPDATE
			//----------------------------------------
            
			//--
			// copy center value
			//--
			
			// NOTE: consider computing differences here to make code simpler
			
			ix = i + (j * m);
			
			C = *(Y + ix);
			
			E = *(Y + ix - m) - C;
			N = *(Y + ix - 1) - C; 
			S = *(Y + ix + 1) - C;
			W = *(Y + ix + m) - C;
			
			//--
			// compute update depending on edge-stopping function
			//--
			
			switch (type) {
				
				//--
				// isotropic diffusion
				//--
				
				// NOTE: this is classical diffusion equivalent to gaussian smoothing
						
				case 0:
					
					// NOTE: ignore scale since it only alters the integration step size

					U = N + S + E + W - (4 * C);
					break;
					
				//--
				// lorentz diffusion
				//--
					
				// NOTE: this is the 'original' anisotropic diffusion proposed in perona-malik
					
				case 1:
					
					U = lorentz (N, scale) +
						lorentz (S, scale) +
						lorentz (E, scale) +
						lorentz (W, scale)
					;
					break;
					
				//--
				// tukey diffusion
				//--
					
				// NOTE: this is robust anisotropic diffusion proposed in black, sapiro, etc.
					
				case 2:
									
					U = tukey (N, scale) +
						tukey (S, scale) +
						tukey (E, scale) +
						tukey (W, scale)
					;					
					break;
					
				//--
				// huber diffusion
				//--
					
				// NOTE: this is robust anisotropic diffusion proposed in black, sapiro, etc.
					
				case 3:
					
					// TODO: implement the underlying function huber, not implemented yet
					
					U = huber (N, scale) +
						huber (S, scale) +
						huber (E, scale) +
						huber (W, scale)
					;
					break;
			
			}
			
            //----------------------------------------
			// PERFORM UPDATE
            //----------------------------------------
										
			*(Y + ix) += step * U;
		
		} 
		}
		
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

// aniso_filter_ - anisotropic diffusion filtering
// -----------------------------------------------
//
// Y = aniso_filter_(X,scale,step,N)
//
// Input:
// ------
//  X - input image 
//  scale - gradient scale
//  step - integration step size
//  N - number of iterations
//
// Output:
// -------
//  Y - filtered output image

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 316 $
// $Date: 2004-12-20 14:58:18 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	double *X, *Y; int m, n;
		
	int type; double scale, step;
	
	int N;
	
	//--------------------------------
	// GET INPUT
	//--------------------------------

	//--
	// get input image pointer and size
	//--

	X = mxGetPr(prhs[0]);

	m = mxGetM(prhs[0]); 
	
	n = mxGetN(prhs[0]);		

	//--
	// get diffusion type
	//--
	
	// NOTE: the diffusion types and codes are: 
	// linear (0), lorentz (1), tukey (2), and huber (3)
	
	type = (int) mxGetScalar(prhs[1]);
	
	//--
	// get scale parameter, integration step size, and number of iterations
	//--
	
	scale = mxGetScalar(prhs[2]);
	
	// NOTE: that the step size is divided by the number of neighbors
	
	step = 0.25 * mxGetScalar(prhs[3]);

	N = (int) mxGetScalar(prhs[4]);
	
	//--
	// ALLOCATE OUTPUT 
	//--

	Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL));

	//--
	// COMPUTE OUTPUT
	//--

	aniso_filter (Y, X, m, n, type, scale, step, N);
  	
}
