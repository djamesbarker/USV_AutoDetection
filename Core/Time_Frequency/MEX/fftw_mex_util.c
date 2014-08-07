#include "fftw_mex_util.h"

//---------------------------------------------------
// MACROS
//---------------------------------------------------

#define c_re(c) (c[0])
#define c_im(c) (c[1])

//---------------------------------------------------
// FUNCTIONS
//---------------------------------------------------

// mx_to_fftw - convert matlab format to fftw complex array
// --------------------------------------------------------
//
// mx_to_fftw (fftw_complex *X, double *Xr, double *Xi, long N)
//
// Input:
// ------
//  Xr - pointer to real part of mxArray
//  Xi - pointer to imag part of mxArray
//  N - length of the array
//
// Output:
// -------
//  X - pointer to fftw complex array

void mx_to_fftw (
	register fftw_complex *X, register FFT_TYPE *Xr, register FFT_TYPE *Xi, long N
)

{
	
	register long k;

	//--
	// complex array
	//--

	if (Xi) {

		for (k = 0; k < N; ++k) {
			c_re(X[k]) = Xr[k];
			c_im(X[k]) = Xi[k];
		}
	
	//--
	// real array
	//--

	} else { 

		for (k = 0; k < N; ++k) {
			c_re(X[k]) = Xr[k];
			c_im(X[k]) = 0.0;
		}

	}

}


// fftw_to_mx - convert from fftw complex format to matlab format
// --------------------------------------------------------------
//
// fftw_to_mx (double *Xr, double *Xi, fftw_complex *X, long N)
//
// Input:
// ------
//  X - pointer to fftw complex array
//  N - length of the array
//
// Output:
// -------
//  Xr - pointer to real part of mxArray
//  Xi - pointer to imag part of mxArray

void fftw_to_mx (
	register FFT_TYPE *Xr, register FFT_TYPE *Xi, register fftw_complex *X, long N
)

{
	
	register long k;

	for (k = 0; k < N; ++k) {
		Xr[k] = c_re(X[k]);
		Xi[k] = c_im(X[k]);
	}

}


// hc_fftw_to_mx - convert from fftw half-complex format to full matlab format
// ---------------------------------------------------------------------------
//
// hc_fftw_to_mx (double *Xr, double *Xi, double *Yfhc, long N)
//
// Input:
// ------
//  X - pointer to fftw real array storing half complex vector
//  N - length of array
//
// Output:
// -------
//  Xr - pointer to real part of mxArray
//  Xi - pointer to imag part of mxArray

void hc_fftw_to_mx (
	register FFT_TYPE *Xr, register FFT_TYPE *Xi, register FFT_TYPE *X, long N
)

{
	
	register long k;

	register FFT_TYPE re, im;

	//--
	// odd length
	//--

	if (N % 2) {

		Xr[0] = X[0];
		Xi[0] = 0.0;

		for (k = 1; k < ((N + 1) / 2); ++k) {
			re = X[k];
			im = X[N - k];
			Xr[k] = re;
			Xi[k] = im;
			Xr[N - k] = re;
			Xi[N - k] = -im;
		}

	//--
	// even length
	//--

	} else {

		Xr[0] = X[0];
		Xi[0] = 0.0;

		for (k = 1; k < (N / 2); ++k) {
			re = X[k];
			im = X[N - k];
			Xr[k] = re;
			Xi[k] = im;
			Xr[N - k] = re;
			Xi[N - k] = -im;
		}

		Xr[N / 2] = X[N / 2];
		Xi[N / 2] = 0.0;

	}

}


// hc_fftw_to_half_mx - convert from fftw half-complex format to half matlab format
// --------------------------------------------------------------------------------
//
// hc_fftw_to_half_mx (double *Xr, double *Xi, double *Yfhc, long N)
//
// Input:
// ------
//  X - pointer to fftw real array storing half complex vector
//  N - length of array
//
// Output:
// -------
//  Xr - pointer to real part of mxArray
//  Xi - pointer to imag part of mxArray

void hc_fftw_to_half_mx (
	register FFT_TYPE *Xr, register FFT_TYPE *Xi, register FFT_TYPE *X, long N
)

{
	
	register long k;
	long Nover2 = N >> 1;
	//--
	// odd length
	//--

	if (N & 1) {

		Xr[0] = X[0];
		Xi[0] = 0.0;

		for (k = 1; k < ((N + 1) >> 1); ++k) {
			
			Xr[k] = X[k];
			Xi[k] = X[N - k];
			
		}

	//--
	// even length
	//--

	} else {

		Xr[0] = X[0];
		Xi[0] = 0.0;

		for (k = 1; k < (Nover2); ++k) {

			Xr[k] = X[k];
			Xi[k] = X[N - k];
			
		}

		Xr[Nover2] = X[Nover2];
		Xi[Nover2] = 0.0;

	}

}


// hc_mult - multiply half complex arrays
// --------------------------------------
//
// hc_mult (double *Y, double *X1, double X2, long N)
//
// Input:
// ------
//  X1 - half complex input
//  X2 - half complex input
//
// Output:
// -------
//  Y - half complex product

void hc_mult (
	FFT_TYPE *Y, FFT_TYPE *X1, FFT_TYPE *X2, long N
)

{
	
	register long k;

	register FFT_TYPE re1, im1, re2, im2;

	//--
	// odd length
	//--

	if (N % 2) {

		Y[0] = X1[0] * X2[0];

		for (k = 1; k < ((N + 1) / 2); k++) {

			re1 = X1[k];
			im1 = X1[N - k];
			re2 = X2[k];
			im2 = X2[N - k];

			Y[k] = (re1 * re2) - (im1 * im2);
			Y[N - k] = (re1 * im2) + (im1 * re2);

		}

	//--
	// even length
	//--

	} else {

		Y[0] = X1[0] * X2[0];

		for (k = 1; k < ((N + 1) / 2); k++) {

			re1 = X1[k];
			im1 = X1[N - k];
			re2 = X2[k];
			im2 = X2[N - k];

			Y[k] = (re1 * re2) - (im1 * im2);
			Y[N - k] = (re1 * im2) + (im1 * re2);

		}

		Y[N / 2] = X1[N / 2] * X2[N / 2];

	}

}


// hc_power_spectrum - compute power spectrum for half complex array
// -----------------------------------------------------------------
//
// hc_power_spectrum (double *P, double *X, long N)
//
// Input:
// ------
//  X - pointer to fftw real array storing half complex vector
//  N - length of array
//
// Output:
// -------
//  P - power spectrum of half complex vector

void hc_power_spectrum (FFT_TYPE *P, FFT_TYPE *X, long N)

{
	
	register long k;

	register FFT_TYPE re, im;

	//--
	// odd length
	//--

	if (N % 2) {

		P[0] = X[0] * X[0];

		for (k = 1; k < ((N + 1) / 2); ++k) {
			re = X[k];
			im = X[N - k];
			P[k] = (re * re) + (im * im);
		}

	//--
	// even length
	//--

	} else {

		P[0] = X[0] * X[0];

		for (k = 1; k < (N / 2); ++k) {
			re = X[k];
			im = X[N - k];
			P[k] = (re * re) + (im * im);
		}

		P[N / 2] = X[N / 2] * X[N / 2];

	}

}

// vec_mult - multiply two equal-length vectors
// -----------------------------------------------------------------
//
// vec_mult(FFT_TYPE *Y, FFT_TYPE *X1, FFT_TYPE *X2, unsigned long N)
//
// Input:
// ------
//  X1 - pointer to the first input vector
//  X2 - pointer to the second input vector
//  N  - the number of elements in each vector
//
// Output:
// -------
//  Y - pointer to the multiplied vector

void vec_mult(FFT_TYPE *Y, FFT_TYPE *X1, FFT_TYPE *X2, unsigned long N)
{
	long k;
	for (k = 0; k < N; k++) {		
		*(Y + k) = *(X1 + k) * *(X2 + k);		
	}
}
	
void vec_power(FFT_TYPE *P, FFT_TYPE *re, FFT_TYPE *im, unsigned long N)
{
	long j;
	for (j = 0; j < N; j++) {
		*(P + j) = (*(re + j) * *(re + j)) + (*(im + j) * *(im + j));
	}
}

void vec_norm(FFT_TYPE *P, FFT_TYPE *re, FFT_TYPE *im, unsigned long N)
{
	long j;
	for (j = 0; j < N; j++) {
		*(P + j) = sqrt((*(re + j) * *(re + j)) + (*(im + j) * *(im + j)));
	}
}

