//---------------------------------------------------
// FUNCTIONS
//---------------------------------------------------

#ifndef FAST_SPECGRAM_H
#define FAST_SPECGRAM_H

// max - max
//---------------------------------------------------

#ifndef max
 #define max(A,B) ((A) > (B) ? (A) : (B)) 
#endif

// min - min
//---------------------------------------------------

#ifndef min
 #define min(A,B) ((A) < (B) ? (A) : (B))
#endif

// summary - compute summary of buffer
// -----------------------------------------------------

void summary(
	FFT_TYPE *S, long F, FFT_TYPE *B, long bix, long nSUM, long six, SUM_TYPE mode
);

// median - compute median of a vector with variable stride indexing
// -----------------------------------------------------------------

// NOT IMPLEMENTED
FFT_TYPE median(FFT_TYPE *B, mwSize nB, mwSize stride);


// fast_specgram - spectrogram computation (norm or power)
// ----------------------------------------------------------

void fast_specgram (
	register FFT_TYPE *P, long F, long T,
	register FFT_TYPE *X, mwSize nX, register FFT_TYPE *H, 
	mwSize nH, long nFFT, long nLAP, SG_TYPE mode
);

// fast_specgram_complex - faster complex spectrogram computation
// ----------------------------------------------

void fast_specgram_complex (
	register FFT_TYPE *Br, register FFT_TYPE *Bi, long F, long T,
	register FFT_TYPE *X, mwSize nX, register FFT_TYPE *H, 
	mwSize nH, long nFFT, long nLAP
);

// fast_specgram_sum - faster spectrogram computation
// with summarization
// --------------------------------------------------

void fast_specgram_summary (
	FFT_TYPE *P, long F, long T, long nSUM,
	FFT_TYPE *X, mwSize nX, FFT_TYPE *H, mwSize nH, 
	long nFFT, long nLAP, SG_TYPE mode, SUM_TYPE sum_t,
	int quality
);

#endif /* FAST_SPECGRAM_H */
