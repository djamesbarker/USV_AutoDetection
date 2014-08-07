//---------------------------------------------------
// INCLUDE
//---------------------------------------------------

// C

#include "math.h"
#include "string.h"
#include "stdio.h"

// MATLAB

#include "mex.h"
#include "matrix.h"

// LIBSNDFILE

#include <sndfile.h>

//---------------------------------------------------
// MEX FUNCTION
//---------------------------------------------------

// sound_write_ - write samples to sound file
// ------------------------------------------
//
// sound_write_(X,s,f,fmt,enc)
//
// Input:
// ------
//  X - sound data
//  s - samplerate
//  f - output file
//  fmt - format code
//  enc - encoding code

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

// TODO: modify function to output format and encoding tables

/* NOTE: at the moment the format and encoding tables need to be 
 * synchronized by hand.
 */

// TODO: add support for writing float arrays

/* NOTE: reading data from sound files as float will lead to faster 
 * spectrogram computations. the performance of FFTW can be significantly 
 * faster for float arrays. since this is the case it makes sense to also
 * write from float
 */

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{

	//--------------------------------------------
	// VARIABLES
	//--------------------------------------------

	//--
	// samples and rate
	//--
	
	// NOTE: this includes the samples array pointer, number of channels and samples, and rate
	
	void *X; 
	
	int n, ch, r, e;
	
	//--
	// output file name
	//--
	
	char *f;
	
	int len;
	
	//--
	// format and encoding
	//--
	
	int fmt_code, enc_code;
	
	//--
	// libsndfile structures
	//--
		
	SNDFILE *out_file;

	SF_INFO out_info;
	
	
	mxClassID cls;

	//--------------------------------------------
	// INPUT
	//--------------------------------------------

	// TODO: add some check on the number of channels and samples
	
	//--------------------------------
	// samples and rate
	//--------------------------------

	X = mxGetPr(prhs[0]);
	
	cls = mxGetClassID(prhs[0]);

	n = mxGetN(prhs[0]);
	
	ch = mxGetM(prhs[0]); 

	r = (int) mxGetScalar(prhs[1]);

	//--------------------------------
	// output file
	//--------------------------------

	len = mxGetM(prhs[2]) * mxGetN(prhs[2]) + 1;

	f = mxCalloc(len, sizeof(char));

	mxGetString(prhs[2], f, len);
	
	//--------------------------------
	// format and encoding
	//--------------------------------
	
	// NOTE: although we could extract the format from the file name it it easier in MATLAB
	
	fmt_code = (int) mxGetScalar(prhs[3]);
	
	enc_code = (int) mxGetScalar(prhs[4]);
	
	//--------------------------------------------
	// COMPUTATION
	//--------------------------------------------

	//--------------------------------
	// fill info structure
	//--------------------------------
	
	out_info.frames = n;
	
	out_info.channels = ch;
			
	out_info.samplerate = r;
	
	out_info.sections = 1;
	
	out_info.seekable = 1;
	
	// NOTE: look at 'sndfile.h' for the meanings of these
	
	switch (fmt_code) {
		
		case 0:
			fmt_code = SF_FORMAT_WAV; break;
					
		case 1:
			fmt_code = SF_FORMAT_AIFF; break;
			
		case 2:
			fmt_code = SF_FORMAT_AU; break;
			
		case 3:
			fmt_code = SF_FORMAT_W64; break;
			
		case 4:
			fmt_code = SF_FORMAT_FLAC; break;
			
		default:
			mexErrMsgTxt("Unsupported major file format.");

	}
	
	// NOTE: look at 'sndfile.h' for the meanings of these
	
	switch (enc_code) {
		
		case 0:
			if (fmt_code == SF_FORMAT_AU) {
				mexErrMsgTxt("Unsupported encoding for major file format.");
			}
			enc_code = SF_FORMAT_PCM_U8; break;

		case 1:
			if ((fmt_code == SF_FORMAT_WAV) || (fmt_code == SF_FORMAT_WAV)) {
				mexErrMsgTxt("Unsupported encoding for major file format.");
			}
			enc_code = SF_FORMAT_PCM_S8; break;
			
		case 2:
			enc_code = SF_FORMAT_PCM_16; break;
			
		case 3:
			enc_code = SF_FORMAT_PCM_24; break;
			
		case 4:
			enc_code = SF_FORMAT_PCM_32; break;
			
		case 5:
			enc_code = SF_FORMAT_FLOAT; break;
			
		case 6:
			enc_code = SF_FORMAT_DOUBLE; break;
			
		case 7:
			enc_code = SF_FORMAT_ULAW; break;
			
		case 8:
			enc_code = SF_FORMAT_ALAW; break;
			
		case 9:
			if ((fmt_code == SF_FORMAT_AIFF) || (fmt_code == SF_FORMAT_AU)) {
				mexErrMsgTxt("Unsupported encoding for major file format.");
			}
			enc_code = SF_FORMAT_IMA_ADPCM; break;

		case 10:
			if ((fmt_code == SF_FORMAT_AIFF) || (fmt_code == SF_FORMAT_AU)) {
				mexErrMsgTxt("Unsupported encoding for major file format.");
			}
			enc_code = SF_FORMAT_MS_ADPCM; break;
			
		case 11:
			if (fmt_code == SF_FORMAT_AU) {
				mexErrMsgTxt("Unsupported encoding for major file format.");
			}
			enc_code = SF_FORMAT_GSM610; 
			break;
			
		default:
			mexErrMsgTxt("Unsupported encoding.");
			
	}
	
	out_info.format = fmt_code | enc_code;
	
	if (!sf_format_check(&out_info)) mexErrMsgTxt("failed format check.");
	
	//--------------------------------
	// create output file
	//--------------------------------
	
	//--
	// open output file (create if needed)
	//--
	
	out_file = sf_open (f, SFM_WRITE, &out_info);
	
	if (out_file == NULL) {
		
		// grab log buffer (very informative about errors)
		
		char  buffer [2048] ;
        sf_command (out_file, SFC_GET_LOG_INFO, buffer, sizeof (buffer)) ;		
		mexPrintf("%s\n", buffer);
			
		// there must be an error, display it, and break.
		
		mexErrMsgTxt(sf_error_number(sf_error(out_file))) ;
		
	}
		
	//--
	// write samples to output file
	//--
	
	// NOTE: set normalization to true, this assumes samples are in the -1 to 1 range
	
	switch (cls){
		
		case (mxDOUBLE_CLASS):
	
			sf_command (out_file, SFC_SET_NORM_DOUBLE, NULL, SF_TRUE);
	
			sf_writef_double (out_file, (double *) X, n);
			
			break;
			
		case (mxSINGLE_CLASS):
			
			sf_command (out_file, SFC_SET_NORM_FLOAT, NULL, SF_TRUE);
	
			sf_writef_float (out_file, (float *) X, n);
			
			break;
			
		default:
			
			mexErrMsgTxt("Unsupported class.\n");
			
	}

	
	//--
	// close file
	//--

	sf_close (out_file);

}

