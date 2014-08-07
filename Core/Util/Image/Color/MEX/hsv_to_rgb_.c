//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------

#include "stdlib.h"

#include "math.h"

#include "mex.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

// range_3 - min and max of three values
// -------------------------------------
//
// Input:
// ------
//  r,g,b - input values
//
// Output:
// -------
//  a - pointer to min and max value array

void range_3 (double *a, double r, double g, double b);

void range_3 (double *a, double r, double g, double b) 

{

	//-----------------------------
	// VARIABLES
	//-----------------------------
	
	double l, u;
	
	//-----------------------------
	// COMPUTATION
	//-----------------------------
	
	//--
	// compare red and green
	//--
	
	if (r > g){
		u = r;
		l = g;
	} else {
		u = g;
		l = r;
	}
	
	//--
	// compare blue to existing bounds
	//--
	
	if (b > u) {
		u = b;
	} else if (b < l) {
		l = b;
	}
	
	//--
	// output bounds
	//--
	
	*a = l;
	*(a + 1) = u;
	
}

// rgb_to_hsv - rgb to hsv conversion
// ----------------------------------
//
// Input:
// ------
//  R,G,B - pointers to red, green, and blue color channels
//  n - number of pixels to convert
//
// Output:
// -------
//  H,S,V - pointers to hue saturation and value color channels

void rgb_to_hsv (
	double *H, double *S, double *V, double *R, double *G, double *B, int n
);

void rgb_to_hsv (
	double *H, double *S, double *V, double *R, double *G, double *B, int n
)

{

	//-----------------------------
	// VARIABLES
	//-----------------------------
	
	double a[2], u, l, w;
	
	double r, g, b;
	
	double rp, gp, bp;
		
	int k;
	
	//-----------------------------
	// CONVERSION
	//-----------------------------
	
	for (k = 0; k < n; k++) {
	
		//--
		// copy rgb pixel values
		//--
		
		r = *(R + k);
		g = *(G + k);
		b = *(B + k);
		
		//--
		// compute bounds and spread
		//--
		
		range_3(a,r,g,b);
		
		l = *a;
		u = *(a + 1);
	   	w = u - l;
	   	
		//--
	   	// compute value - this takes values in the input range
		//--
	   	
	   	*(V + k) = u; 
	   	
		//--
	   	// compute saturation - this takes values in the unit interval
		//--
	   	
		if (u != 0) {
			*(S + k) = w / u;
		} else {
			*(S + k) = 0;
		}
		
		//--
		// compute hue - this takes angular values in degrees
		//--
		
		if (*(S + k) == 0) {
		
			// undefined hue for no saturation
			
			*(H + k) = 0;
			
		} else {
		
			// this is a hexagonal approximation
			
			rp = (u - r) / w;
			gp = (u - g) / w;
			bp = (u - b) / w;
			
			if (r == u) { 
				*(H + k) = bp - gp;
			} else if (g == u) {
				*(H + k) = 2 + rp - bp;
			} else if (b == u) {
				*(H + k) = 4 + gp - rp;
			}
			
			*(H + k) = *(H + k) * 60;

			if (*(H + k) < 0) {
				*(H + k) = *(H + k) + 360;
			}
		
		}
		
	}
		
}

// hsv_to_rgb - hsv to rgb conversion
// ----------------------------------
//
// Input:
// ------
//  H,S,V - pointers to hue saturation and value color channels
//  n - number of pixels to convert
//
// Output:
// -------
//  R,G,B - pointers to red, green, and blue color channels

void hsv_to_rgb(
	double *R, double *G, double *B, double *H, double *S, double *V, int n
);

void hsv_to_rgb(
	double *R, double *G, double *B, double *H, double *S, double *V, int n
)

{

	//-----------------------------
	// VARIABLES
	//-----------------------------
	
	int i, k;
	
	double f, a, b, c, h, s, v;
	
	//-----------------------------
	// CONVERSION
	//-----------------------------
	
	for (k = 0; k < n; k++) {
	
		//--
		// copy hsv pixel values
		//--
		
		h = *(H + k);
		s = *(S + k);
		v = *(V + k);
		
		if (s == 0) {

			//--
			// when saturation is zero the color is gray
			//--
			
			*(R + k) = *(G + k) = *(B + k) = *(V + k);
			
		} else {
	   
			//--
			// map the extreme angles to the same point
			//--
			
			if (h == 360) {
				h = 0;
			}
			
			//--
			// compute the facet on the hexagon
			//--
			
			h = h / 60;
			
			i = (int) h;
			
			//--
			// compute facet related values
			//--
			
			f = h - i;
			
			a = v * (1 - s);
			
			b = v * (1 - (s * f));
			
			c = v * (1 - (s * (1 - f)));
			
			//--
			// compute according to the hexagon facet
			//--
			
			switch (i) {
			
				case 0: 
					*(R + k) = v;
					*(G + k) = c;
					*(B + k) = a;
					break;
					
				case 1:
					*(R + k) = b;
					*(G + k) = v;
					*(B + k) = a;
					break;
				
				case 2:
					*(R + k) = a;
					*(G + k) = v;
					*(B + k) = c;
					break;
				
				case 3:
					*(R + k) = a;
					*(G + k) = b;
					*(B + k) = v;
					break;
				
				case 4:
					*(R + k) = c;
					*(G + k) = a;
					*(B + k) = v;
					break;
				
				case 5:
					*(R + k) = v;
					*(G + k) = a;
					*(B + k) = b;
					break;
			
			}
			
		}
		
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{

	//----------------------------------------------
	// VARIABLES
	//----------------------------------------------
	
	double *X, *Y;
	
	double *R, *G, *B; 
	
	double *H, *S, *V;
	
	int m, n;
	
	//----------------------------------------------
	// GET INPUT
	//----------------------------------------------
	
	X = mxGetPr(prhs[0]);
	
	m = mxGetM(prhs[0]);
	n = mxGetN(prhs[0]);
  		
	if (n != 3) {
		mexErrMsgTxt("Input must have three columns.");
	}
	
	H = X;
	S = X + m;
	V = X + 2*m;
	 
  	//----------------------------------------------
	// ALLOCATE OUTPUT
	//----------------------------------------------

	Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL));
  		
	R = Y;
	G = Y + m;
	B = Y + 2*m;
  		
  	//----------------------------------------------
	// COMPUTATION
	//----------------------------------------------
  		  		
	// rgb_to_hsv(H, S, V, R, G, B, m);
  		
	hsv_to_rgb(R, G, B, H, S, V, m);

}

		

	

