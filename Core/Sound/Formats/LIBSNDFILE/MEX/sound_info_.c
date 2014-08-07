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

#include "sndfile.h"

//---------------------------------------------------
// DEFINE
//---------------------------------------------------

#define BUFFER_LEN 2048

//---------------------------------------------------
// FUNCTIONS
//---------------------------------------------------

static double get_signal_max (SNDFILE *file)

// Copyright (C) 1999-2004 Erik de Castro Lopo <erikd@mega-nerd.com>

{	
	
	double max, temp, data[BUFFER_LEN];
	
	int count, k, save_state;

	save_state = sf_command (file, SFC_GET_NORM_DOUBLE, NULL, 0);
	
	sf_command (file, SFC_SET_NORM_DOUBLE, NULL, SF_FALSE);

	max = 0.0;
	
	while ((count = sf_read_double (file, data, BUFFER_LEN))) {
		
		for (k = 0; k < count; k++) {
			temp = fabs (data[k]);
			if (temp > max) {
				max = temp;
			}
		}
		
	}

	sf_command (file, SFC_SET_NORM_DOUBLE, NULL, save_state);

	return max;
	
} 

//---------------------------------------------------
// MEX FUNCTION
//---------------------------------------------------

// sound_info_ - get sound file info
// ---------------------------------
//
// info = sound_info_(f)
//
// Input:
// ------
//  f - file path
//
// Output:
// -------
//  info - sound file info structure

//--------------------------------
// Author: Harold Figueroa
//--------------------------------
// $Revision: 317 $
// $Date: 2004-12-20 16:46:44 -0500 (Mon, 20 Dec 2004) $
//--------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{

	//--------------------------------------------
	// VARIABLES
	//--------------------------------------------
	
	char *input_name; 
	
	int name_length;
	
	int k;

	mxArray *d, *value[7];

	//--
	// libsndfile structures
	//--
	
	char buffer[BUFFER_LEN];
	
	SNDFILE *in_file;

	SF_INFO in_info;

	//--
	// matlab structure fieldnames
	//--
	
	static char *fieldname[8] = {
		"samples",
		"samplerate",
		"channels",
		"format",
		"sections",
		"seekable",
		"log",
		"max"
	};

	//--------------------------------------------
	// INPUT
	//--------------------------------------------

	//--
	// get file path
	//--

	name_length = mxGetM(prhs[0]) * mxGetN(prhs[0]) + 1;

	input_name = mxCalloc(name_length, sizeof(char));

	mxGetString(prhs[0],input_name,name_length);

	//--------------------------------------------
	// OUTPUT
	//--------------------------------------------

	//--
	// allocate sound file info structure
	//--

	d = plhs[0] = mxCreateStructMatrix(1,1,8,fieldname);

	//--------------------------------------------
	// COMPUTATION
	//--------------------------------------------

	// NOTE: this may all be easier using the matlab 'dll' interface
	
	//--
	// open file and get info
	//--

	in_file = sf_open (input_name, SFM_READ, &in_info);
	
	//--
	// copy sound file info to matlab structure
	//--

	if (in_file) {

		//--
		// put info fields into mxArrays
		//--

		value[0] = mxCreateScalarDouble((double) in_info.frames);
		
		value[1] = mxCreateScalarDouble((double) in_info.samplerate);
		
		value[2] = mxCreateScalarDouble((double) in_info.channels);

		// TODO: handle this field properly, this will involve new fields
		
		value[3] = mxCreateScalarDouble((double) in_info.format);
		
		value[4] = mxCreateScalarDouble((double) in_info.sections);
		
		value[5] = mxCreateScalarDouble((double) in_info.seekable);
		
		// NOTE: this file log typically contains the no longer available bits per sample info
		
		sf_command (in_file, SFC_GET_LOG_INFO, buffer, BUFFER_LEN);
				
		value[6] = mxCreateString(buffer);

		// TODO: make this an option, since it is time intensive, disable for now
		
		// value[7] = mxCreateScalarDouble((double) get_signal_max(in_file));
		
		value[7] = mxCreateScalarDouble(0.0);
		
		//--
		// pack field mxArrays into info structure
		//--
		
		for (k = 0; k < 8; k++) {
			mxSetField(d,0,fieldname[k],value[k]);
		}

	} else {

		//--
		// unable to open the file
		//--
		
		mexErrMsgTxt ("Unable to open sound file.");
		
		sf_strerror (NULL);

	}

	//--
	// close file
	//--

	sf_close (in_file);

}

