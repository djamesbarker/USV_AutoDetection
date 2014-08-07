//--------------------------------------
// ZERO_CROSSINGS
//--------------------------------------

// NOTE: it is not clear if we gain much from the MEX here

void zero_crossings (double *ZC, double *X, const int N) {

	int k; int zc = 0; double neg;
	
	if (X[0] < 0.0) {
		neg = 1;
	} else {
		neg = 0;
	}
	
	for (k = 1; k < N - 1; k++) {
		if (neg && (X[k] > 0.0)) {
			zc++; neg = 0;
		} else if (!neg && (X[k] < 0.0)) {
			zc++; neg = 1;
		}
	}
}   
