
#ifdef _WIN32
#include <malloc.h>
#else /* _WIN32 */
#include <stdlib.h>
#endif /* _WIN32 */

#include <math.h>
#include <mex.h>
#include <stdio.h>
#include <string.h>

float   rho;

/* Calculation of the GAMMA function */
double gammaHJB(double z)
{
    int             i;
    double          help,
                    prod;
    static double   a[30] = {
         1.00000000000000000000,

         0.57721566490153286061,
        -0.65587807152025388108,
        -0.04200263503409523553,
         0.16653861138229148950,
        -0.04219773455554433675,

        -0.00962197152787697356,
         0.00721894324666309954,
        -0.00116516759185906511,
        -0.00021524167411495097,
         0.00012805028238811619,

        -0.00002013485478078824,
        -0.00000125049348214267,
         0.00000113302723198170,
        -0.00000020563384169776,
         0.00000000611609510448,

         0.00000000500200764447,
        -0.00000000118127457049,
         0.00000000010434267117,
         0.00000000000778226344,
        -0.00000000000369680562,

         0.00000000000051003703,
        -0.00000000000002058326,
        -0.00000000000000534812,
         0.00000000000000122678,
        -0.00000000000000011813,

         0.00000000000000000119,
         0.00000000000000000141,
        -0.00000000000000000023,
         0.00000000000000000002};


    if (z == 0)
    {
        return (-9999999);
    }
    else if (z > 2) 
    {
        return (gammaHJB(z - 1) * (z - 1));
    }
    else if (z < 1)
    {
        return (gammaHJB(z + 1) / z);
    }
    else    /** now  1 <= z <= 2  **/
    {
        z -=1.0;        /** because the taylor series calculates the gammafunction of z+1 **/
        /** now  0 < z <= 1  **/
        help = 0.0;
        prod = 1.0;
        for (i = 0; i < 30; i++)
        {
            help += a[i] * prod;
            prod *= z;
        }
        return (1 / help);
    }
}


/* Calculation of the generalised Gaussian ratio function */
static float ratio(float q)
{
float  rat;
rat = ((float) gammaHJB(1/q)*gammaHJB(3/q)/pow(gammaHJB(2/q),2)) -rho;
return (rat);
}


/* Numerical Recipes standard error handler */
void nrerror(char error_text[])
{
        fprintf(stderr,"Shape parameter out of bounds...\n");
        fprintf(stderr,"%s\n",error_text);
}


/* Numerical Recipes root solver */
#define MAXIT 50

float rtsec(float (*func)(float), float x1, float x2, float xacc)
{
        void nrerror(char error_text[]);
        int j;
        float fl,f,dx,swap,xl,rts;

        fl=(*func)(x1);
        f=(*func)(x2);
        if (fabs(fl) < fabs(f)) {
                rts=x1;
                xl=x2;
                swap=fl;
                fl=f;
                f=swap;
        } else {
                xl=x1;
                rts=x2;
        }
        for (j=1;j<=MAXIT;j++) {
                dx=(xl-rts)*f/(f-fl);
                xl=rts;
                fl=f;
                rts += dx;
                f=(*func)(rts);
                if (fabs(dx) < xacc || f == 0.0) return rts;
        }
        nrerror("...returning SHAPE=0...");
        return 0.0;
}
#undef MAXIT
/* (C) Copr. 1986-92 Numerical Recipes Software 45D,&4. */


/* MAIN */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
double  *x;
int     x_nr_rows;
int     x_nr_columns;
double  *mu, x_abs_squared=0, sigma_squared=0, *sigma, *gamma;
int     m, n;
float   xacc=10e-4, xb1, xb2, expect, hlp;

/* GATEWAY */

 if (nrhs!=1 || nlhs>3)
    mexErrMsgTxt("GGFIT: Supply arguments\nSyntax: [SHAPE,DEV,MEAN]=GGFIT(X)\n");

 x_nr_rows = mxGetM(prhs[0]);
 x_nr_columns = mxGetN(prhs[0]);
 
 /* match inputs */
 x = mxGetPr(prhs[0]);   /* Complex parts ignored */

 /* match outputs */
 plhs[0] = mxCreateDoubleMatrix(1,1, mxREAL);
 gamma = mxGetPr(plhs[0]);
 plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
 sigma = mxGetPr(plhs[1]);
 plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
 mu = mxGetPr(plhs[2]);

/* INITIALIZATION */
 *sigma = 0;
 *gamma = 0;
 *mu = 0;

/* CALCULATION OF GENERALISED GAUSSIAN PARAMETERS */

 /* calculation of the mean, mu */
 for (m=0; m<x_nr_rows; m++)
    {
    for (n=0; n<x_nr_columns; n++)
       {
       *mu += x[m+n*x_nr_rows];
       } /* for */
    } /* for */
 *mu /= x_nr_rows*x_nr_columns;

 /* calculation of the squared variance, sigma_squared */
 for (m=0; m<x_nr_rows; m++)
    {
    for (n=0; n<x_nr_columns; n++)
       {
       sigma_squared += pow((x[m+n*x_nr_rows]-*mu),2);
       } /* for */
    } /* for */
 sigma_squared /= x_nr_rows*x_nr_columns;
 *sigma = pow(sigma_squared, 0.5);

 /* calculation of the mean square to square mean abs(x) ratio, rho */
 for (m=0; m<x_nr_rows; m++)
    {
    for (n=0; n<x_nr_columns; n++)
       {
       x_abs_squared += fabs(x[m+n*x_nr_rows]);
       } /* for */
    } /* for */
 x_abs_squared = pow(x_abs_squared/(x_nr_rows*x_nr_columns), 2);
 rho = sigma_squared/x_abs_squared;

 /* calculation of the shape parameter, gamma */
 if (rho<2)
 {
    expect = 2*pow(rho, -0.9);
    xb1 = expect+0.2;
    xb2 = expect-0.2;
 }
 else if (rho>7.54)
 {
    expect = 0.00048608247886*pow(rho, 2)-0.02082423035032*rho+0.40544239581756;
    xb1 = expect+0.002;
    xb2 = expect-0.002;
 }
 else		/* Now 2<rho<7.54 */
 {
    expect = 2*pow(rho, -1.05);
    xb1 = expect+0.05;
    xb2 = expect-0.1;
 }

 if (rho>30)
 {   hlp = 0.15;
 }
 else if (rho<1.3335)
 {   hlp = 120;
 }
 else
 {   hlp = rtsec(ratio, xb1, xb2, xacc); 
 } /* if */

 if ((hlp<0.185) || (hlp>12.5))
 {   nrerror("SHAPE calculation is inaccurate");
 }

 *gamma=(double)hlp;

} /* main */
