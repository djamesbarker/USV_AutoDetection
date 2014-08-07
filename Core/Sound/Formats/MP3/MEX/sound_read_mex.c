/*
 * sound_read_mex.c - part of the MP3 file format handler
 *
 * Author: Matt Robbins
 * $Revision: 587 $
 * $Date: 2005-02-22 23:28:55 -0500 (Tue, 22 Feb 2005) $
 *
 */

#include <mad.h>

/*
 * MATLAB INCLUDES
 */

#include "mex.h"
#include "matrix.h"

/* 
 * LOCAL INCLUDES
 */

# include "decode.c"

/*
 * deinterlace - copy samples from interlaced LIBMAD format into column-
 * oriented MATLAB format
 */

void deinterlace(double *output, double *input, int N, int ix, int ch){
	
	int i;
	int jl, jr;

	
	if (ch == 2){
		for(i = 2*ix, jl = 0, jr = N; i < 2*N + 2*ix; i+=2){
			output[jl++] = input[i];
			output[jr++] = input[i+1];
		}
	}
	else{
		for(i = ix, jl = 0; i < N + ix; i++){
			output[jl++] = input[i];
		}
	}
}

/*
 * MEX FUNCTION
 *---------------------------------------------------
 *
 * sound_read_mex - read samples from sound file
 * ------------------------------------------
 *
 * X = sound_read_(f,ix,n,c)
 *
 * Input:
 * ------
 *  f - full filename including path
 *  ix - initial frame
 *  n - number of samples
 *  c - any array with the desired output class
 *  for example: sound_read_(f, ix, n, int32(0))
 *
 * Output:
 * -------
 *  X - sound data
 */

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	uint64 ix;
	
	unsigned int n, ch, start_ix;
	
	char *input_name; int str_len;
	
    double *X, *samples; int dim[2];
	
	struct mp3_info info;
	
	int spf;
	
	FILE *input_file;
    
	/*
	 * get path string
	 */

	str_len = mxGetM(prhs[0]) * mxGetN(prhs[0]) + 1;

	input_name = mxCalloc(str_len, sizeof(char));

	mxGetString(prhs[0],input_name,str_len);
	
	/*
	 * get initial index, number of samples and number of channels
	 */

	ix = (uint64) mxGetScalar(prhs[1]);

	n = (int) mxGetScalar(prhs[2]); ch = (int) mxGetScalar(prhs[3]);
	
	/*
	 * Create MATLAB storage for output
	 */
	
	dim[0] = n; dim[1] = ch;

	plhs[0] = mxCreateDoubleMatrix(0, 0, mxREAL); mxSetDimensions(plhs[0], dim, 2);	

	/*
	 * open file
	 */

	input_file = fopen(input_name, "rb");
	
	if (input_file == NULL) 
		mexErrMsgTxt("unable to open input file\n");
	
	/*
	 * find frame size in samples
	 */
	
	get_info(input_file, &info); spf = info.samples_per_frame;
	
	/*
	 * allocate sample buffer (n + 3 extra frames at maximum frame size)
	 */
	
	samples = mxCalloc(2*(n + (PAD_FRAMES + 3) * spf), sizeof(double));
	
	if(samples == NULL) 
		mexErrMsgTxt("unable to allocate sufficient memory.\n");
		
	/*
	 * seek and decode into sample buffer
	 */
	
	start_ix = decode(input_file, samples, ix, n + PAD_FRAMES * spf);
	
	if(start_ix == -1)
		mexErrMsgTxt("unrecoverable stream error from libMAD\n");
	
	/*
	 * close file
	 */
	
	fclose(input_file);
		
	/*
	 * point output array at correct position in sample buffer
	 */
	
	X = mxCalloc(ch*n, sizeof(double));
	
	/*
	 * set pointer and copy samples
	 */
	
	mxSetPr(plhs[0], X);
	
	deinterlace(X, samples, n, start_ix, 2);
	
	mxFree(samples); mxFree(input_name);
		

}
