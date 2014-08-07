#include "mex.h"

#include "fast_spline.c"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    double * s, * b; 
    
    int N, k_0, dim[2];
    
    /*
     * get input signal and length
     */
    
    s = (double *) mxGetPr(prhs[0]);
    
	N = (int) (mxGetM(prhs[0]) * mxGetN(prhs[0]));
    
    /*
     * get precision
     */
    
    k_0 = (int) mxGetScalar(prhs[1]);
    
    /*
     * allocate output
     */
    
    b = mxCalloc(N, sizeof(double));
    
    /*
     * compute spline coefficients
     */
    
    fast_spline(s, N, b, k_0);
    
    /*
     * write output data
     */
    
    plhs[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
    
    mxSetM(plhs[0],N); mxSetN(plhs[0],1);
    
    mxSetPr(plhs[0],b);
    
}
