//---------------------------------------
// INCLUDE
//---------------------------------------

#include "mex.h"

//---------------------------------------
// DEFINITIONS AND MACROS
//---------------------------------------

// #define VERBOSE

//---------------------------------------
// MEX FUNCTION
//---------------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 

{

    //---------------------------------------
    // VARIABLES
    //---------------------------------------
    
	//--
	// field of structure in structure array input
	//--
	
    mxArray *in_field; 
	
	//--
	// field of output structure
	//--
	
	mxArray *out_field;
	
	//--
	// loop counter variables
	//--
	
	register int i, j, k;

	//--
	// number of elements in structure array input and number of fields to extract
	//--
	
    int M, N;
	
	//--
	// fields to extract attribute arrays
	//--
	
	int *out_ix, *out_id, *out_complex, *out_size;
	
	//--
	// single field attributes
	//--
	
	register int ix, id, co, n; 
	
	//--
	// pointers to real and complex parts of input fields
	//--
	
	register double *pr, *pi, *ptr, *pti;
	
	//--
	// not a number value
	//--
	
	const double nan = mxGetNaN();
	
	//--
	// names of fields to extract
	//--
	
	const char **out_names;
	
    //---------------------------------------
    // CHECK INPUT AND OUTPUT ARGUMENTS
    //---------------------------------------

	// number of input arguments
	
    if(nrhs != 2) {

        mexErrMsgTxt("Two inputs are required, a structure array and indices of fields to extract.");

	// number of output arguments
		
    } else if (nlhs > 1) {

        mexErrMsgTxt("Too many output arguments.");
		
	// class of first input
		
    } else if (!mxIsStruct(prhs[0])) {

        mexErrMsgTxt("First input must be a structure.");

	// shape of first input
		
    } else if ((mxGetNumberOfDimensions(prhs[0]) > 2) || ((mxGetM(prhs[0]) > 1) && (mxGetN(prhs[0]) > 1))) {

        mexErrMsgTxt("Input structure array must be a vector.");

    }

    //---------------------------------------
    // GET INDEX INPUT
    //---------------------------------------

	//--
	// number of fields to extract
	//--
	
	N = mxGetNumberOfElements(prhs[1]);
	
	//--
	// indices of fields to extract
	//--
	
    out_ix = mxCalloc(N, sizeof(int));
	
	ptr = mxGetPr(prhs[1]);
	
	// NOTE: here we change from 1 based indices to 0 based indices
	
    for (k = 0; k < N; k++) {
		*(out_ix + k) = *(ptr + k) - 1; 
    }
    
    //---------------------------------------
    // CHECK STRUCTURE INPUT
    //---------------------------------------
	
    //--
    // allocate memory for storing field attributes
    //--

	out_names = mxCalloc(N, sizeof(*out_names));
	
    out_id = mxCalloc(N, sizeof(int));
	
	out_complex = mxCalloc(N, sizeof(int));
	
	out_size = mxCalloc(N, sizeof(int));

	//--
    // number of elements in input structure array
    //--
    		
	M = mxGetNumberOfElements(prhs[0]);
	
    //--
    // loop over elements in structure array and fields to extract
    //--

    for (j = 0; j < M; j++) {
    for (k = 0; k < N; k++) {
        
        //--
        // get field using field index 
        //--
        
        ix = *(out_ix + k);
 
        in_field = mxGetFieldByNumber(prhs[0], j, ix);
        
        //--
        // check that field exists
        //--

        if (in_field == NULL) {
			
            mexPrintf("\n%s%d\t%s%d\n", "FIELD: ", ix + 1, "STRUCT INDEX :", j + 1);
            mexErrMsgTxt("Above field is empty!");
			
        }

        //--
        // check datatypes and size of structure fields
        //--

        if (j == 0) {

            //--
            // check that field has structure, string, or numeric non-sparse data
            //--

			// currently we do not extract logical fields, this function should be extended to
			// handle fields with logical value
			
            if((!mxIsStruct(in_field) && !mxIsChar(in_field) && !mxIsNumeric(in_field)) || mxIsSparse(in_field)) {
				
                mexPrintf("\n%s%d\t%s%d\n", "FIELD: ", ix + 1, "STRUCT INDEX :", j + 1);
                mexErrMsgTxt("Above field must have either struct, string, or numeric non-sparse data.");
				
            }

            //--
            // get field attributes name, class id, complexity flag, and size
            //--

			*(out_names + k) = mxGetFieldNameByNumber(prhs[0],ix);
			
            *(out_id + k) = mxGetClassID(in_field);
			
			*(out_complex + k) = mxIsComplex(in_field);
			
			*(out_size + k) = mxGetNumberOfElements(in_field);
			
#ifdef VERBOSE

			mexPrintf("\n");
			
			mexPrintf("%s%d\n", "FIELD INDEX: ", ix);
			
			mexPrintf("%s%s\n", "FIELD NAME: ", *(out_names + k));
			
			mexPrintf("%s%d\n", "FIELD CLASS: ", *(out_id + k));
			
			mexPrintf("%s%d\n", "FIELD COMPLEXITY: ", *(out_complex + k));
			
			mexPrintf("%s%d\n", "FIELD SIZE: ", *(out_size + k));
			
#endif

        } else {

			//--
			// update size of field if needed
			//--
			
			// this is needed when field in first element is empty and only done once
			
			if ((mxGetNumberOfElements(in_field) > 0) && (*(out_size + k) == 0)) {
				*(out_size + k) = mxGetNumberOfElements(in_field);
			}
			
            //--
            // check for class consistency
            //--

            if (mxGetClassID(in_field) != *(out_id + k)) {
                
                mexPrintf("\n%s%d\t%s%d\n", "FIELD: ", ix + 1, "STRUCT INDEX :", j + 1);
                mexErrMsgTxt("Inconsistent data type in above field!");
			
			//--
            // check for complexity consistency
            //--

            } else if (mxIsComplex(in_field) != *(out_complex + k)) {
				
				mexPrintf("\n%s%d\t%s%d\n", "FIELD: ", ix + 1, "STRUCT INDEX :", j + 1);
                mexErrMsgTxt("Inconsistent complexity of elements in above field!");
				
			//--
            // check for size consistency
            //--

			// note that we permit the field to be empty in this consistency test
				
            } else if (
				(mxGetClassID(in_field) != mxSTRUCT_CLASS) && (mxGetClassID(in_field) != mxCHAR_CLASS) &&
				((mxGetNumberOfElements(in_field) > 0) && (mxGetNumberOfElements(in_field) != *(out_size + k)))
			) {
				
				mexPrintf("\n%s%d\t%s%d\n", "FIELD: ", ix + 1, "STRUCT INDEX :", j + 1);
                mexErrMsgTxt("Inconsistent number of elements in above field!");
				
            }

        }

    }
    }

    //---------------------------------------
    // CREATE OUTPUT STRUCTURE
    //---------------------------------------

    plhs[0] = mxCreateStructMatrix(1, 1, N, out_names);
	
    //---------------------------------------
    // COPY INPUT DATA TO OUTPUT
    //---------------------------------------
        
    for(k = 0; k < N; k++) {
        
		//--
		// copy field attributes index, class id, complexity flag, and size
		//--
		
		ix = *(out_ix + k);
		
		id = *(out_id + k);
		
		co = *(out_complex + k); 
		
		n = *(out_size + k);
		
		// empty numeric fields get represented as having a single column filled with not a number
		
		if (n == 0) {
			n++;
		}
		
        //--
        // allocate output field mxArray based on type of field extracted
        //--
        
        if ((id == mxCHAR_CLASS) || (id == mxSTRUCT_CLASS)) {

			//--
			// string and structure fields are output to a cell array
			//--
			
            out_field = mxCreateCellMatrix(M, 1);

        } else {

			//--
			// numeric fields are output to a matrix with M rows and out_size columns
			//--
			
			if (co) {
				
				out_field = mxCreateNumericMatrix(M, n, id, mxREAL);
				
				pr = mxGetPr(out_field);
				pi = mxGetPi(out_field);
				
			} else {
			
				out_field = mxCreateNumericMatrix(M, n, id, mxREAL);
			
				pr = mxGetPr(out_field);
			
			}

        }
        
        //--
        // copy data from input structure array to output structure
        //--
        
        for (j = 0; j < M; j++) {
            
			//--
			// get input structure field
			//--
			
            in_field = mxGetFieldByNumber(prhs[0],j,ix);

			//--
			// copy field contents to output structure
			//--
			
            if (mxIsChar(in_field) || mxIsStruct(in_field)) {
				
				//--
				// copy structure or string fields by replicating the corresponding mxArray
				//--
				
                mxSetCell(out_field, j, mxDuplicateArray(in_field));
				
            } else {
				
				//--
				// copy numeric field data based considering complexity and whether they are empty
				//--
				
				if (co) {
					
					if (mxGetNumberOfElements(in_field) > 0) {
						
						//--
						// fill row of matrix with field data
						//--
						
						ptr = mxGetPr(in_field);
						pti = mxGetPi(in_field);

						for (i = 0; i < n; i++) {
							
							// *(pr + (j * n) + i) = *(ptr + i);
							// *(pi + (j * n) + i) = *(pti + i);
							
							*(pr + (i * n) + j) = *(ptr + i);
							*(pi + (i * n) + j) = *(pti + i);
						}
						
					} else {
						
						//--
						// fill row of matrix with not a number
						//--
					
						for (i = 0; i < n; i++) {
							
							// *(pr + (j * n) + i) = nan;
							// *(pi + (j * n) + i) = nan;
							
							*(pr + (i * n) + j) = nan;
							*(pi + (i * n) + j) = nan;
							
						}
						
					}
					
				} else {
					
					if (mxGetNumberOfElements(in_field) > 0) {
						
						//--
						// fill row of matrix with field data
						//--
						
						ptr = mxGetPr(in_field);

						for (i = 0; i < n; i++) {
							
							// *(pr + (j * n) + i) = *(ptr + i);
							*(pr + (i * M) + j) = *(ptr + i);
							
						}
						
					} else {
						
						//--
						// fill row of matrix with not a number
						//--
						
						for (i = 0; i < n; i++) {
							
							// *(pr + (j * n) + i) = nan;
							*(pr + (i * M) + j) = nan;
							
						}
						
					}
					
				}
				
            }
            
        }
        
        //--
        // set output structure field
        //--
        
        mxSetFieldByNumber(plhs[0], 0, k, out_field);
        
    }
    
    //---------------------------------------
    // FREE TEMPORARY VALUES AND RETURN
    //---------------------------------------

    mxFree(out_names);

    mxFree(out_id);
	
	mxFree(out_complex);
	
	mxFree(out_size);
    
    return;

}
    
