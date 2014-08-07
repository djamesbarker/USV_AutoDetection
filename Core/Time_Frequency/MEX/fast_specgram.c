#include "fftw_mex_type.h"
#include "fast_specgram.h"

//---------------------------------------------------
// SPECTROGRAM COMPUTATION
//---------------------------------------------------

// fast_specgram_complex - faster spectrogram computation
// ----------------------------------------------
//
// fast_specgram_complex (
//		Br, Bi, F, T,
//		X, nX, H, nH, nFFT, nLAP
// );
//
// Input:
// ------
//  X - input signal
//  nX - signal length
//  H - window
//  nH - window length
//  nFFT - length of fft
//  nLAP - length of overlap
//
// Output:
// -------
//  Br - real part of spectrogram matrix
//  Bi - imag part of spectrogram matrix
//  F - number of distinct frequency rows
//  T - number of time slice columns

void fast_specgram_complex (
	register FFT_TYPE *Br, register FFT_TYPE *Bi, long F, long T,
	register FFT_TYPE *X, mwSize nX, register FFT_TYPE *H, mwSize nH, long nFFT, long nLAP
)

{

	FFTW_PLAN fp;

	register FFT_TYPE *in, *out;

	register long k, ix, dix;

	//--
	// INITIALIZATION
	//--

	//--
	// allocate buffer arrays
	//--

	in = (FFT_TYPE *)mxCalloc(nFFT, sizeof(FFT_TYPE));
	
	out = (FFT_TYPE *)mxCalloc(nFFT, sizeof(FFT_TYPE));
	
	//--
	// create forward plan
	//--
	
	fp = PLAN (
        nFFT, in, out, FFTW_R2HC, FFTW_PATIENT
    );

	//--
	// COMPUTE SPECTROGRAM
	//--

	ix = 0; dix = nH - nLAP;

	for (k = 0; k < T; k++) {

		//--
		// apply window to segment
		//--

		vec_mult(in, X + ix, H, nH);
		
		//--
		// compute real to complex transform
		//--

		GO (fp);

		//--
		// convert half complex to half matlab and store in time slice
		//--

		hc_fftw_to_half_mx (Br + (k * F), Bi + (k * F), out, nFFT);

		//--
		// update starting index
		//--

		ix += dix;

	}

	//--
	// CLEAN UP
	//--

	DIE (fp); 
	
	mxFree(in); mxFree(out);
	
}


// fast_specgram - faster spectrogram magnitude computation
// ----------------------------------------------------------
//
// fast_specgram (
//		P, F, T,
//		X, nX, H, nH, nFFT, nLAP
// );
//
// Input:
// ------
//  X - input signal
//  nX - signal length
//  H - window
//  nH - window length
//  nFFT - length of fft
//  nLAP - length of overlap
//  mode - type of magnitude computation
//
// Output:
// -------
//  P - pointer to power of spectrogram matrix
//  F - number of distinct frequency rows
//  T - number of time slice columns

void fast_specgram (
	register FFT_TYPE *P, long F, long T,
	register FFT_TYPE *X, mwSize nX, register FFT_TYPE *H, 
	mwSize nH, long nFFT, long nLAP, SG_TYPE mode
)

{

	FFTW_PLAN fp;

	register FFT_TYPE *in, *out, *re, *im;

	register long k, ix, dix;

	//--
	// create and initialize pointer to proper magnitude function
	//--
	
	void (*vec_mag)(FFT_TYPE *, FFT_TYPE *, FFT_TYPE *, unsigned long);
	
	switch (mode) {	
		
		case (PWR):	
			vec_mag = vec_power; break;
			
		case (NRM):	
			vec_mag = vec_norm; break;
			
	}
				
	//--
	// INITIALIZATION
	//--

	// allocate buffers

	in = (FFT_TYPE *)mxCalloc(nFFT, sizeof(FFT_TYPE));
	
	out = (FFT_TYPE *)mxCalloc(nFFT, sizeof(FFT_TYPE));

	re = (FFT_TYPE *)mxCalloc(F, sizeof(FFT_TYPE));
	
	im = (FFT_TYPE *)mxCalloc(F, sizeof(FFT_TYPE));

	// create forward plan

	fp = PLAN (
        nFFT, in, out, FFTW_R2HC, FFTW_PATIENT
    );

	//--
	// LOOP OVER SIGNAL SEGMENTS
	//--

	ix = 0; dix = nH - nLAP;

	for (k = 0; k < T; k++) {

		//--
		// apply window and copy data to transform input
		//--
		
		vec_mult(in, X + ix, H, nH);
		
		//--
		// compute real to complex fft
		//--

		GO (fp);

		//--
		// convert half complex to half matlab
		//--

		hc_fftw_to_half_mx (re, im, out, nFFT);

		//--
		// compute power and store in time slice
		//--

		vec_mag(P + (k * F), re, im, F);

		//--
		// update starting index
		//--

		ix += dix;

	}

	//--
	// CLEAN UP
	//--

	DIE (fp);
	
	mxFree(in); mxFree(out); mxFree(re); mxFree(im);

}


// fast_specgram_sum - faster spectrogram computation with summarization
// ---------------------------------------------------------------------
//
// fast_specgram (
//		P, F, T, nSUM
//		X, nX, H, nH, nFFT, nLAP
// );
//
// Input:
// ------
//  X - input signal
//  nX - signal length
//  H - window
//  nH - window length
//  nFFT - length of fft
//  nLAP - length of overlap
//
// Output:
// -------
//  Br - real part of spectrogram matrix
//  Bi - imag part of spectrogram matrix
//  F - number of distinct frequency rows
//  T - number of time slice columns


void fast_specgram_summary (
	FFT_TYPE *P, long F, long T, long nSUM,
	FFT_TYPE *X, mwSize nX, FFT_TYPE *H, mwSize nH, 
	long nFFT, long nLAP, SG_TYPE mode, SUM_TYPE sum_t,
	int quality
)

{

	FFTW_PLAN fp;

	FFT_TYPE *in, *out, *out_re, *out_im, *Pbuf;

	long ix, dix, bix, six, oix, mod, nBUF;

	//--
	// magnitude function pointer
	//--
	
	void (*vec_mag) (FFT_TYPE *, FFT_TYPE *, FFT_TYPE *, unsigned long);
	
	switch (mode) {	
		case (PWR):	
			vec_mag = vec_power;
			
		case (NRM):	
			vec_mag = vec_norm;	
			
	}
	
	//--
	// INITIALIZATION
	//--
	
	//--
	// allocate buffer arrays
	//--

	in = (FFT_TYPE *)mxCalloc(nFFT, sizeof(FFT_TYPE));
	
	out = (FFT_TYPE *)mxCalloc(nFFT, sizeof(FFT_TYPE));	
	
	out_re = (FFT_TYPE *)mxCalloc(F, sizeof(FFT_TYPE));
	
	out_im = (FFT_TYPE *)mxCalloc(F, sizeof(FFT_TYPE));

	
	//--
	// set up circular spectrogram slice buffer (for median computation)
	//--
	
	nBUF = nSUM; // NOTE: This does not in general have to be true
	
	Pbuf = (FFT_TYPE *)mxCalloc(F * nBUF, sizeof(FFT_TYPE));
	
	//--
	// create forward plan
	//--
	
	fp = PLAN (
        nFFT, in, out, FFTW_R2HC, FFTW_PATIENT
    );

	//--
	// COMPUTE SPECTROGRAM
	//--

	ix = 0;  // input signal index
	dix = nH - nLAP;
	
	bix = 0; // input buffer index
	oix = 0; // output slice index
	six = 0; // dummy summary period index (to avoid % operation)
	
	if (sum_t == DECIMATE)
	{
		while(oix < (T / nSUM))
		{
			
			// window
			vec_mult(in, X + ix, H, nH);	
			
			// fourier transform
			GO (fp);
			
			// transform to normal indexing
			hc_fftw_to_half_mx(out_re, out_im, out, nFFT);
			
			// take magnitude (either norm or power)
			vec_mag(P+oix*F, out_re, out_im, F);

			// update indexes	
			ix+=(dix*nSUM);
			oix++;
			
		}
		
	} else {
	
		
		mod = pow(2, (4-quality));
		
		while (oix < (T / nSUM))
		{
			
			//--
			// only take one out of every 2^quality
			//--
					
			if ( !(six % mod) ){
				
				//--
				// window and transform
				//--

				vec_mult(in, X+ix, H, nH);

				GO (fp);

				//--
				// convert to re/im form and compute (real) amplitude estimate
				//--

				hc_fftw_to_half_mx (out_re, out_im, out, nFFT);

				vec_mag(Pbuf+bix*F, out_re, out_im, F);

				//--
				// compute (update) summary
				//--

				summary(P+oix*F, F, Pbuf, bix, nSUM, six, sum_t);

				// circular buffer index update
				if(++bix >= nBUF) {
					bix = 0;		
				}
				
			}
			
			// summary index update (dummy)
			if(++six >= nSUM) six = 0;

			// output index update	
			if (!six) oix++;

			// input index update
			ix += dix;

		}
	}
	
	DIE (fp);

	mxFree(in);	
	mxFree(out);
	mxFree(out_re);
	mxFree(out_im);
	mxFree(Pbuf);

}

void summary(
	FFT_TYPE *S, long F, FFT_TYPE *B, long bix, long nSUM, long six, SUM_TYPE mode
)

{

	long j;
	
	switch (mode)
	{
		
	case (MEAN): 
		
		// initialize on first call
		
		if(!six){
			for(j=0;j<F;j++){
				S[j] = 0;
			}		
		}
		
		// accumulate
		
		for(j=0;j<F;j++){
			S[j] += B[bix*F + j];
		}
			
		// divide on last call
		
		if(six == nSUM-1){
		    for(j=0;j<F;j++){
				S[j] /= (FFT_TYPE) nSUM; 
			}
		}
		
		break;
		
	case (MAX): 	
		
		// initialize on beginning
		
		if(!six){
			for(j=0;j<F;j++){
				S[j] = 0;
			}		
		}
		
		for(j=0;j<F;j++){
			S[j] = max(S[j], B[bix*F + j]);
		}
		
		break;
		
	case (MIN): 	
		
		// initialize on beginning
		
		if(!six){
			for(j=0;j<F;j++){
				S[j] = 100000.;
			}		
		}
		
		for(j=0;j<F;j++){
			S[j] = min(S[j], B[bix*F + j]);
		}
		
		break;		
		
// 	case (MEDIAN):
// 		
// 		if(six = nSUM-1){
// 			for(j=0; j<F; j++){
// 				S[j] = median(B+j, nSUM, F);  
// 			}
// 		}
// 		break;
		
	}	
}

FFT_TYPE median(FFT_TYPE *B, mwSize nB, mwSize stride)
{
	//--
	// NOT IMPLEMENTED YET, THIS IS A PLACEHOLDER
	//--
	
	return (FFT_TYPE) 0;
}
