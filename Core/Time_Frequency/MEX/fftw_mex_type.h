//---------------------------------------------------
// TYPE ALIASING
//---------------------------------------------------

#ifndef FFTW_MEX_TYPE_H
#define FFTW_MEX_TYPE_H

#ifdef FLOAT

#define MX_CLASS mxSINGLE_CLASS
#define FFT_TYPE float
#define FFTW_PLAN fftwf_plan

#define PLAN(N, I, O, T, F) (fftwf_plan_r2r_1d(N, I, O, T, F))
#define GO(FP) (fftwf_execute(FP))
#define DIE(FP) (fftwf_destroy_plan(FP))

#else

#define MX_CLASS mxDOUBLE_CLASS
#define FFT_TYPE double
#define FFTW_PLAN fftw_plan

#define PLAN(N, I, O, T, F) (fftw_plan_r2r_1d(N, I, O, T, F))
#define GO(FP) (fftw_execute(FP))
#define DIE(FP) (fftw_destroy_plan(FP))

#endif

//--
// spectrogram computation types
//--

typedef enum {NRM=0, PWR, CPX} SG_TYPE;

//--
// summarization types
//--

typedef enum {MEAN=0, MAX, MIN, DECIMATE} SUM_TYPE;

#endif /* FFTW_MEX_TYPE_H */

