#include <math.h>
#include <fftw3.h>

#include "mex.h"

#include "fftw_mex_type.h"
#include "fftw_mex_util.c"
#include "fast_specgram.c"

//---------------------------------------------------
// MEX FUNCTION
//---------------------------------------------------

// fast_specgram - faster spectrogram computation
// ----------------------------------------------
//
// B = fast_specgram(X,H,n,overlap,opt)
//
// Input:
// ------
//  X - input signal
//  H - window
//  n - length of fft
//  overlap - length of overlap
//  opt - computation option
//
// Output:
// -------
//  B - spectrogram matrix

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{

	FFT_TYPE *P, *Br, *Bi; long F, T, FT[2], S, FS[2];

	FFT_TYPE *X; mwSize nX;
	FFT_TYPE *H; mwSize nH;

	mwSize nFFT, nLAP, nSUM, nQAL;
	
	SG_TYPE opt;
	
	SUM_TYPE sum_t;

	//--
	// INPUT
	//--

	//--
	// real	input signal
	//--

	X = (FFT_TYPE *) mxGetData(prhs[0]);
	nX = mxGetM(prhs[0]) * mxGetN(prhs[0]);

	//--
	// window
	//--

	H = (FFT_TYPE *) mxGetData(prhs[1]);
	nH = mxGetM(prhs[1]) * mxGetN(prhs[1]);

	//--
	// fft length
	//--

	if (nrhs > 2) {
		nFFT = (mwSize) mxGetScalar(prhs[2]);
	} else {
		nFFT = nH;
	}

	//--
	// overlap length
	//--

	if (nrhs > 3) {
		nLAP = (mwSize) mxGetScalar(prhs[3]);
	} else {
		nLAP = (mwSize) nFFT / 2.0;
	}

	//--
	// computation option
	//--

	if (nrhs > 4) {
		opt = (SG_TYPE) mxGetScalar(prhs[4]);
	} else {
		opt = PWR;
	}
	
	//--
	// summarization interval
	//--
	
	if (nrhs > 5) {
		nSUM = (mwSize) mxGetScalar(prhs[5]);
	} else {
		nSUM = 1;
	}
	
	//--
	// summarization type
	//--
	
	if (nrhs > 6) {
		sum_t = (mwSize) mxGetScalar(prhs[6]);
	} else {
		sum_t = MAX;
	}
	
	//--
	// summarization quality
	//--
	
	if (nrhs > 7) {
		nQAL = (mwSize) mxGetScalar(prhs[7]);
	} else {
		nQAL = 4;
	}
	
	if (nSUM < 8) nQAL = 4;

	//--
	// OUTPUT
	//--

	//--
	// get dimensions of spectrogram
	//--

	// number of distinct frequencies depends on parity of nFFT

	F = (nFFT & 1) ? (nFFT + 1) / 2 : (nFFT / 2) + 1;
	
	// number of time slices depends on signal, window, and overlap length

	T = (nX - nLAP) / (nH - nLAP);
	
	//--
	// compute according to option, NOTE: summarization only occurs for magnitude (NRM/PWR) options
	//--
	
	if (opt == CPX) {
		
		//--
		// allocate complex spectrogram matrix and get pointers
		//--
        
        plhs[0] = mxCreateNumericMatrix(0, 0, MX_CLASS, mxCOMPLEX);
    
		mxSetDimensions(plhs[0],FT,2);
		
        Br = mxMalloc(T * F * sizeof(FFT_TYPE));
		
        Bi = mxMalloc(T * F * sizeof(FFT_TYPE));
		 	
		//--
		// compute spectrogram
		//--	
	
		fast_specgram_complex (
			Br, Bi, F, T,
			X, nX, H, nH, nFFT, nLAP
		);
		
		mxSetData(plhs[0],Br);
		
        mxSetImagData(plhs[0],Bi);
			
	} else {
		
		//--
		// allocate real spectrogram matrix and get pointer
		//--
        
        plhs[0] = mxCreateNumericMatrix(0, 0, MX_CLASS, mxREAL);
		
		//--
		// compute spectrogram
		//--	
		
		if (nSUM <= 1){
			
			FT[0] = F; FT[1] = T;
			
			mxSetDimensions(plhs[0],FT,2);
        
			P = (FFT_TYPE *) mxMalloc(F * T * sizeof(FFT_TYPE));		
        	
			fast_specgram (
				P, F, T,
				X, nX, H, nH, nFFT, nLAP, opt
			);
			
		} else {
			
			S = T / nSUM; FS[0] = F; FS[1] = S;
			
			mxSetDimensions(plhs[0],FS,2);
        
			P = (FFT_TYPE *) mxMalloc(F * S * sizeof(FFT_TYPE));
		
			fast_specgram_summary (
				P, F, T, nSUM,
				X, nX, H, nH, nFFT, 
				nLAP, opt, sum_t, nQAL
			);
			
		}
		
		mxSetData(plhs[0],P);

	}
	
}
