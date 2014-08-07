
#ifdef _WIN32
#include <malloc.h>
#else /* _WIN32 */
#include <stdlib.h>
#endif /* _WIN32 */

#include <math.h>
#include <mex.h>
#include <stdio.h>
#include <string.h>

/* Calculation of the GAMMA function */

double gammaHJB(double z) {
	
	//--
	// DECLARATION
	//--
	
    int i; 
	
	double help, prod;
	
    static double a[30] = {
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
         0.00000000000000000002
	};

	//--
	// COMPUTE
	//--
	
	// NOTE: this function uses gamma function properties and taylor approximation
	
    if (z == 0) {
        return (-9999999);
		
    } else if (z > 2){
		return (gammaHJB(z - 1) * (z - 1));
		
    } else if (z < 1) {
        return (gammaHJB(z + 1) / z);
		
    } else {
		
        z -= 1.0; help = 0.0; prod = 1.0;
		
        for (i = 0; i < 30; i++) {
            help += a[i] * prod; prod *= z;
        }
		
        return (1 / help);
		
    }
	
}

/* MAIN */

void mexFunction(
	int nlhs, mxArray *plhs[], 
	int nrhs, const mxArray *prhs[]
) {
	
//--
// DECLARE
//--
	
double  *x, *y, a, b; int x_nr_rows, x_nr_columns;

double  *mu, *var, *gamma;

int m;

//--
// HANDLE INPUT
//--
 
 /* GATEWAY */

 if (nrhs!=4 || nlhs>1)
    mexErrMsgTxt("GGFIT: Supply arguments\nSyntax: Y = GENGG(X,SHAPE,DEV,MEAN)\n");

 x_nr_rows = mxGetM(prhs[0]);
 x_nr_columns = mxGetN(prhs[0]);
 if (x_nr_rows >= x_nr_columns)
   {
   x_nr_columns = 1;
   }
   else
   {
   x_nr_rows = 1;
   }

 /* match inputs */
 x = mxGetPr(prhs[0]);       /* Complex parts ignored */
 gamma = mxGetPr(prhs[1]);   /* Complex parts ignored */
 var = mxGetPr(prhs[2]);     /* Complex parts ignored */
 mu = mxGetPr(prhs[3]);      /* Complex parts ignored */

 /* match outputs */
 y = mxCalloc(x_nr_rows*x_nr_columns,sizeof(double));
 plhs[0] = mxCreateDoubleMatrix(x_nr_rows, x_nr_columns, mxREAL);
 mxSetM(plhs[0],x_nr_rows);
 mxSetN(plhs[0],x_nr_columns);
 mxSetPr(plhs[0],y);

 /* CALCULATION OF GENERALISED GAUSSIAN */
 for (m=0; m<(x_nr_rows*x_nr_columns); m++)
   {
   b = pow( ( gammaHJB(3/(*gamma))/gammaHJB(1/(*gamma)) ),0.5 )/(*var);
   a = b*(*gamma)/(2*gammaHJB(1/(*gamma)));
   y[m] = a*exp( -pow( fabs(b*(x[m]- *mu)), *gamma ) );
 } /* for */

} /* main */
