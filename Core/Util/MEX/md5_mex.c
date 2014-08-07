#include "mex.h"

#include "md5.c"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    char * msg;
    
    md5_byte_t digest[16];
    
    char hash[32];
    
    int msg_length;
    
    int k;
    
    md5_state_t state;
    
    /*
     * get input signal and length
     */
    
	msg_length = mxGetM(prhs[0]) * mxGetN(prhs[0]) + 1;

	msg = mxCalloc(msg_length, sizeof(char));

	mxGetString(prhs[0], msg, msg_length);    
    
    /*
     * initialize md5
     */
   
    md5_init(&state);
    
    /*
     * add message
     */
    
    md5_append(&state, (md5_byte_t *) msg, msg_length);
    
    /*
     * finish
     */
    
    for (k = 0; k < 16; k++){
        digest[k] = 0;
    }
    
    md5_finish(&state, digest);
    
    /*
     * write output data
     */
    
    for (k = 0; k < 16; k++){ 
        sprintf(hash + 2*k, "%2.2x", digest[k]);
    }
    
    plhs[0] = mxCreateString((const char *) hash);
    
}
