//--------------------------------------
// FAST_MIN_MAX
//--------------------------------------

void fast_min_max (double *Lk, double *Uk, double *X, const int N) {

	int k; double x1, x2, xx; double L, U;
	
	// NOTE: initialize limits to first entry
	
	L = U = *X;
	
	for (k = 0; k < N - 1; k = k + 2) {
		        
		x1 = *(X + k); x2 = *(X + k + 1);
		
		// NOTE: sort next pair to consider and update min and max
		
		if (x1 > x2) { xx = x1; x1 = x2; x2 = xx; }

		if (x1 < L) { L = x1; }
		
		if (x2 > U) { U = x2; }
		
	}
	
	// NOTE: consider the odd-length case
	
	if (N & 1) {
	
		xx = *(X + N - 1);
						
		if (xx < L) {
			L = xx;
		} else if (xx > U) {
			U = xx;
		}
		
	}
	
	*Lk = L; *Uk = U;
	
}   