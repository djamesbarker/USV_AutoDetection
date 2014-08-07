/*
 * sound_info_mex.c - part of the MP3 file format handler
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

# include "util.c"

/*
 * MEX_FUNCTION
 *
 * sound_read_ - read samples from sound file
 * ------------------------------------------
 *
 * info = sound_info_mex(f,N)
 *
 * Input:
 * ------
 *  f - full filename including path
 *  N - number of desired seek-table entries
 *
 * Output:
 * -------
 *  info - structure containing:
 *
 *    .bitrate - (average) bitrate of file
 *    .duration - in seconds of file
 *	  .frames - the number of MPEG frames in file
 *    .samplerate - the sample rate
 *	  .stereo - 1 if file has 2 channels, 0 otherwise
 *    .version - MPEG version, 1, 2, or 2.5
 *    .layer - MPEG layer, 1, 2 or 3
 *    .channels - stereo + 1
 *    .samplesize - 16 
 *    .format - MPEG format string
 *    .samples_per_frame - samples per frame
 *    .samples - the number of samples in the file
 *    .seektable - single precision N x 2 table of frame number -> byte index
 *    
 *
 *
 */

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{

	struct mp3_info mp3_info;
	int ix, m, result, out_ix, N, k;
	
	char *input_name, *format;
	
	char vbr_str[128];
	
	mxArray *info[13], *out;
	
	FILE *input_file;

	/*
	 * get path string
	 */

	m = mxGetM(prhs[0]) * mxGetN(prhs[0]) + 1;
	input_name = mxCalloc(m, sizeof(char));
	mxGetString(prhs[0],input_name,m);
		
	/*
	 * open file
	 */
	
	input_file = fopen(input_name, "rb");
	
	if (input_file == NULL) 
		mexErrMsgTxt("Unable to open input file.\n");
	
	/*
	 * fill info structure using get_info()
	 */
	
	result = get_info(input_file, &mp3_info);

	/*
	 * Close file
	 */	
	
	fclose(input_file);
		
	//if (mp3_info.duration <= 0)
		//mexErrMsgTxt("Problem reading file duration.\n");
	
	
	/*
	 * create matlab struct output
	 */
		
	static char *fieldname[13] = {
		"bitrate",
		"duration",
		"frames",
		"samplerate",
		"stereo",
		"version",
		"layer",
		"channels",
		"samplesize", 
		"format",
		"vbr",
		"samples_per_frame",
		"samples"
	};
	
	out = plhs[0] = mxCreateStructMatrix(1,1,13,(const char **) fieldname);
	
	/*
	 * create MPEG format string
	 */
	
	if (mp3_info.vbr)
		sprintf(vbr_str, " (VBR)");
	else
		sprintf(vbr_str, "");
	
	format = mxCalloc(25, sizeof(char));
	sprintf(format, "MPEG %d layer %d%s", mp3_info.version, mp3_info.layer, vbr_str);
	
	/*
	 * assign info fields to mxArray types for MATLAB struct
	 */
	
	out_ix = 0;
	
	info[out_ix++] = mxCreateScalarDouble((double)mp3_info.bitrate);
	info[out_ix++] = mxCreateScalarDouble(mp3_info.duration);
	info[out_ix++] = mxCreateScalarDouble(mp3_info.frames);
	info[out_ix++] = mxCreateScalarDouble(mp3_info.samplerate);
	info[out_ix++] = mxCreateScalarDouble((double)mp3_info.stereo);
	info[out_ix++] = mxCreateScalarDouble(mp3_info.version);
	info[out_ix++] = mxCreateScalarDouble((double)mp3_info.layer);
	info[out_ix++] = mxCreateScalarDouble(mp3_info.channels);
	info[out_ix++] = mxCreateScalarDouble(mp3_info.samplesize);
	info[out_ix++] = mxCreateString(format);
	info[out_ix++] = mxCreateScalarDouble(mp3_info.vbr);
	info[out_ix++] = mxCreateScalarDouble(mp3_info.samples_per_frame);
	info[out_ix++] = mxCreateScalarDouble(mp3_info.samples);
	
	/*
	 * populate MATLAB struct
	 */
	
	for (k = 0; k < 13; k++) {
		mxSetField(out,0,fieldname[k],info[k]);
	}
	
	/*
	 * clean up
	 */
	
	mxFree(input_name);
	
}


