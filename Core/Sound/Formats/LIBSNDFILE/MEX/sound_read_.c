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

// HELPER FUNCTION PROTO.

void select_channels(void *Y, void *X, int n, int Nch, short *ch, int nch, mxClassID c);

//---------------------------------------------------
// MEX FUNCTION
//---------------------------------------------------

// sound_read_ - read samples from sound file
// ------------------------------------------
//
// X = sound_read_(f,ix,n,c)
//
// Input:
// ------
//  f - full filename including path
//  ix - initial frame
//  n - number of samples
//  c - any array with the desired output class
//  for example: sound_read_(f, ix, n, int32(0))
//
// Output:
// -------
//  X - sound data

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{

	//--------------------------------------------
	// VARIABLES
	//--------------------------------------------
	
	char *input_name;
	
	int ix, m, n, nch, Nch;
	
	int dim[2];
	
	unsigned short *ch;

    void *X, *Y;
	 
	//--
	// libsndfile structures
	//--
	
	SNDFILE *input_file;

	SF_INFO input_info;

    //--
    // MATLAB type vars
    //--
    
    mxClassID data_class;
    
	//--------------------------------------------
	// HANDLE INPUT
	//--------------------------------------------

	//--
	// get path string
	//--

	m = mxGetM(prhs[0]) * mxGetN(prhs[0]) + 1;

	input_name = mxCalloc(m, sizeof(char));

	mxGetString(prhs[0],input_name,m);
	
	//--
	// get initial index
	//--

	ix = (int) mxGetScalar(prhs[1]);

	//--
	// get number of samples
	//--

	n = (int) mxGetScalar(prhs[2]);
	
	//--
	// get channel indexes and number of channels to read
	//--
	
	ch = mxGetData(prhs[3]);
	nch = mxGetM(prhs[3]) * mxGetN(prhs[3]);
	
	if ( nch == 0 ){
		nch = 65535;
	}
	
	//--
	// get desired output data class
	//--
	
	if (nrhs > 3) {
        data_class = mxGetClassID(prhs[4]);
    } else {
        data_class = mxDOUBLE_CLASS;
    }
	
	//--------------------------------------------
	// READ FILE AND OUTPUT DATA
	//--------------------------------------------

	//--
	// open file
	//--

	input_file = sf_open (input_name, SFM_READ, &input_info);

	if (input_file == NULL) {
		
		// dump log buffer (very informative about errors)
		
		char  buffer [2048];
		
        sf_command (input_file, SFC_GET_LOG_INFO, buffer, sizeof (buffer));		
		
		mexPrintf("%s\n", buffer);
			
		// there must be an error, display it, and break.
		
		mexErrMsgTxt( sf_error_number( sf_error(input_file) ) );
		
	}
		
	//--
	// set sound file position
	//--

	sf_seek(input_file, ix, SEEK_SET);

	//-----------------------------------------
	// allocate sound data matrix 
	//-----------------------------------------
    
    plhs[0] = mxCreateNumericMatrix(0, 0, data_class, mxREAL);

	//------------------------------------------
	// read according to data type
	//------------------------------------------
    
	Nch = input_info.channels; 
	
    switch (data_class) {
        
        //--
        // FLOATING POINT TYPES
        //--
            
        case(mxDOUBLE_CLASS):
            
            X = mxCalloc(Nch*n, sizeof(double));
			if (Nch > nch) 
				Y = mxCalloc(nch*n, sizeof(double));
        
        	// NOTE: set normalization to true, this produces samples are in the -1 to 1 range
        
	        sf_command (input_file, SFC_SET_NORM_DOUBLE, NULL, SF_TRUE);
			
            sf_readf_double(input_file,X,n);
        
            break;
        
        case(mxSINGLE_CLASS):
        
            X = mxCalloc(Nch*n, sizeof(float));
			if (Nch > nch) 
				Y = mxCalloc(nch*n, sizeof(float));
        
        	// NOTE: set normalization to true, this produces samples are in the -1 to 1 range
        
	        sf_command (input_file, SFC_SET_NORM_FLOAT, NULL, SF_TRUE);
	        
            sf_readf_float(input_file,X,n);  
        
            break;
        
        //--
        // INTEGER TYPES
        //--
        
        // NOTE: it should be obvious that integer types are not normalized
        
        case(mxINT16_CLASS):
        
            X = mxCalloc(Nch*n, sizeof(short));
			if (Nch > nch) 
				Y = mxCalloc(nch*n, sizeof(short));
			
            sf_readf_short(input_file,X,n);
            
            break;
        
        case(mxINT32_CLASS):
        
            X = mxCalloc(Nch*n, sizeof(int));
			if (Nch > nch) 
				Y = mxCalloc(nch*n, sizeof(int));
        
            sf_readf_int(input_file, X, n);
	        
            break;
        
        //--
        // TYPE ERROR
        //--
        
        default:
            
            mexErrMsgTxt("Sample class must be \"double\", \"single\", \"int16\", or \"int32\".");
        
	}

	//--
	// select only proper channels, point output at Y
	//--
	
	if (Nch > nch){
	
		dim[0] = nch; dim[1] = n; 
	
		mxSetDimensions(plhs[0], dim, 2);
		
		select_channels(Y, X, n, Nch, ch, nch, data_class);
	
		mxSetData(plhs[0], Y);
	
		mxFree(X);
		
	} 
	else {
		
		dim[0] = Nch; dim[1] = n; 
	
		mxSetDimensions(plhs[0], dim, 2);
		
		mxSetData(plhs[0], X);
		
	}
	
		
	//--
	// close file
	//--

	sf_close (input_file);

}


//------------------------------------
// SELECT CHANNELS
//------------------------------------

void select_channels(void *Y, void *X, int n, int Nch, short *ch, int nch, mxClassID c){
	
	int out_ix, in_ix, ch_ix, fr_ix;
	
	
	ch_ix = 0;
	
	fr_ix = 0;
	
	double * Yd, * Xd;
	float  * Yf, * Xf;
	int	   * Yi, * Xi;
	short  * Ys, * Xs;
	
	/*
	 * switch on data class, switch is outside loop for performance reasons
	 */
	
	switch (c){
		
	case(mxDOUBLE_CLASS):
		
		Yd = (double *) Y;
		Xd = (double *) X;
		
		for(out_ix = 0; out_ix < n*nch; out_ix++){
		
			in_ix = fr_ix + (ch[ch_ix] - 1);

			*(Yd + out_ix) = *(Xd + in_ix);

			if (++ch_ix >= nch){
				fr_ix+=Nch;
				ch_ix = 0;
			} 
						
		}	
		
		break;
		
	case(mxSINGLE_CLASS):

		Yf = (float *) Y;
		Xf = (float *) X;		
		
		for(out_ix = 0; out_ix < n*nch; out_ix++){
		
			in_ix = fr_ix + (ch[ch_ix] - 1);

			*(Yf + out_ix) = *(Xf + in_ix);

			if (++ch_ix >= nch){
				fr_ix+=Nch;
				ch_ix = 0;
			} 
						
		}
		break;
		
	case(mxINT32_CLASS):
		
		Yi = (int *) Y;
		Xi = (int *) X;		
		
		for(out_ix = 0; out_ix < n*nch; out_ix++){
		
			in_ix = fr_ix + (ch[ch_ix] - 1);

			*(Yi + out_ix) = *(Xi + in_ix);

			if (++ch_ix >= nch){
				fr_ix+=Nch;
				ch_ix = 0;
			} 
						
		}		
		
		break;
		
	case(mxINT16_CLASS):
		
		Ys = (short *) Y;
		Xs = (short *) X;		
		
		for(out_ix = 0; out_ix < n*nch; out_ix++){
		
			in_ix = fr_ix + (ch[ch_ix] - 1);

			*(Ys + out_ix) = *(Xs + in_ix);

			if (++ch_ix >= nch){
				fr_ix+=Nch;
				ch_ix = 0;
			} 
						
		}		
		
	}
		
}

