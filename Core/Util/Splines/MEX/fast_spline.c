#include <math.h>

void fast_spline(double * s, int N, double * b, int k_0)
{

/*
 * initialize variables
 */

int k;
double z_1;
double *c_plus, *c_minus;

/*
 * precompute pole location and allocate memory
 */

z_1 = -2. + sqrt(3.);

c_plus = calloc(N, sizeof(double)); 

/*
 * compute initial value of c_plus
 */
 
c_plus[0] = 0.;
 
for (k = 0; k < k_0; k++){
    c_plus[0] += s[k] * pow(z_1, k);
}

/*
 * run forward recursion
 */

for (k = 1; k < N; k++){
    c_plus[k] = s[k] + z_1 * c_plus[k - 1];
}

/* 
 * compute initial value of c_minus
 */

b[N-1] = (-z_1 / (1 - z_1 * z_1)) * (c_plus[N-1] + z_1 * c_plus[N-2]);

/* 
 * run backward recursion
 */

for (k = N-2; k >= 0; k--){
    b[k] = z_1 * (b[k + 1] - c_plus[k]);
};

/*
 * clean up
 */

free(c_plus);

}

