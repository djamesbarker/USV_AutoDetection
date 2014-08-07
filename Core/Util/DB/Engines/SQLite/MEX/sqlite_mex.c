#include "sqlite3.h"

#include "mex.h"

#include "matrix.h"

#include <string.h>

#ifdef DEBUG
    #define DEBUG(args) (mexPrintf args)
#else
    #define DEBUG(args) ;
#endif

#define MSG_BUFFER_SIZE 1024

int output_ix = 0;

/*
 * BIND PARAMETERS
 ----------------------------------------*/

void bind_parameters (sqlite3_stmt *statement, const mxArray *source, const int offset, const int count) {
	
	mxArray *cell;
	
	int k, numel; char *str;
	
	int result;
	
	// NOTE: this indicates we only take the first entry of a matrix
	
	const int scalar = 1;
	
	int ix = 0;

	DEBUG(("\n"));
	
	//--
	// loop over parameters
	//--
	
	for (k = offset; k < offset + count; k++) {
		
		// NOTE: this is the parameter position index
		
		ix++;
		
		//--
		// get cell
		//--
		
		cell = mxGetCell(source, k); 
		
		numel = mxGetM(cell) * mxGetN(cell);
		
		DEBUG(("Cell %d: # = %d, ", k, numel));
		
        //--
        // bind NULL for empty
        //--
        
//         if (numel == 0){   
//             result = sqlite3_bind_null(statement, ix); continue;
//         }
        
        //--
        // bind BLOB for multi-elements if we are allowed to
        //--
        
        if (numel > 1 && !scalar){
            result = sqlite3_bind_blob(statement, ix, (void *) mxGetPr(cell), numel * mxGetElementSize(cell), SQLITE_STATIC); continue;
        }
         
        //--
        // bind cell contents to positional parameters
        //--
        
        switch (mxGetClassID(cell)) {
            
            case (mxCHAR_CLASS): {
                
                numel = numel + 1;
                
                str = mxCalloc(numel, sizeof(char));
                
                mxGetString(cell, str, numel);
                
                result = sqlite3_bind_text(statement, ix, (const char *) str, numel, SQLITE_TRANSIENT);
                
                DEBUG(("string = %s\n", str));
                
                mxFree(str);
                
                break;
                
            }
            
            case (mxINT8_CLASS):
                
            case (mxUINT8_CLASS):
                
            case (mxINT16_CLASS):
                
            case (mxUINT16_CLASS):
                
            case (mxINT32_CLASS):
                
            case (mxUINT32_CLASS): {

                if (numel == 0){
                    result = sqlite3_bind_null(statement, ix); DEBUG(("NULL\n")); break;
                }
                
                result = sqlite3_bind_int(statement, ix, (int) mxGetScalar(cell));

                DEBUG(("integer = %d\n", (int) mxGetScalar(cell)));
                  
                break;
                
            }
            
            case (mxINT64_CLASS):
                
            case (mxUINT64_CLASS): {  
                
                if (numel == 0){
                    result = sqlite3_bind_null(statement, ix); DEBUG(("NULL\n")); break;
                }     
                
                result = sqlite3_bind_int64(statement, ix, (long long int) mxGetScalar(cell));

                DEBUG(("long = %d\n", (long long int) mxGetScalar(cell)));
                      
                break;
                
            }
            
            case (mxSINGLE_CLASS):
                
            case (mxDOUBLE_CLASS): {
                
                if (numel == 0){
                    result = sqlite3_bind_null(statement, ix); DEBUG(("NULL\n")); break;
                }
                         
                result = sqlite3_bind_double(statement, ix, mxGetScalar(cell));

                DEBUG(("real = %f\n", mxGetScalar(cell)));
                
                break;
                
            }
            
            default:
                
                DEBUG(("NULL\n"));
                
                /* we don't know how to bind complex types */
                
                result = sqlite3_bind_null(statement, ix);
                
		}
        
	}
	
}

//----------------------------------------
// EXEC_CALLBACK
//----------------------------------------

static int exec_callback(void *output, int argc, char **argv, char **azColName){
    
    mxArray * value;
    
    extern int output_ix;
    
    int rowpr=argc-1;    
    
    mxSetData(
       (mxArray *) output, mxRealloc(mxGetData((mxArray *) output), (output_ix + 1) * sizeof(mxArray *))
    );
    
	/*
    for (rowpr = 0; rowpr < argc; rowpr++){ 
         mexPrintf("%s\n", azColName[rowpr]);
    }
    */
	
    rowpr=argc-1;
    
    value = mxCreateString(argv[rowpr] ? argv[rowpr] : "NULL");
    
    mxSetCell((mxArray *) output, output_ix, value);
    
    output_ix++;
    
    return 0;
}


//----------------------------------------
// MEX FUNCTION
//----------------------------------------

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  
	//----------------------------------------
	// VARIABLES
	//----------------------------------------
    
	char *file, *sql; int len;
	
	int mode, full_names;
	
	sqlite3 *db; 
	
	sqlite3_stmt *statement = 0;	
	
	int status, j, k, count = 0, sets = 0;
	
	char *errmsg, **result; 
    char errmsg_buf[MSG_BUFFER_SIZE];
    
    int rows, cols;
    
    mxArray *value;
    
    char **fieldnames;
    
    char buf[128];
    
    int ix;
    
    extern int output_ix;
	
	//----------------------------------------
	// HANDLE INPUT
	//----------------------------------------
	
	//--
	// DATABASE
	//--
	
	len = mxGetM(prhs[0]) * mxGetN(prhs[0]) + 1;

	file = mxCalloc(len, sizeof(char));

	mxGetString(prhs[0], file, len);  
	
	//--
	// ACCESS MODE
	//--
	
	mode = (int) mxGetScalar(prhs[1]);
	
	//--
	// SQL
	//--
	
	len = mxGetM(prhs[2]) * mxGetN(prhs[2]) + 1;

	sql = mxCalloc(len, sizeof(char));

	mxGetString(prhs[2], sql, len);
    
	//----------------------------------------
	// ACCESS DATABASE
	//----------------------------------------
	
	//---------------------------
	// OPEN
	//---------------------------
	
	status = sqlite3_open(file, &db);
	
	if (status) {
		sqlite3_close(db); mexErrMsgTxt(sqlite3_errmsg(db));
	}
	
    //--
    // set up full column names
    //--
    
    if (mode & 0x100){
    
        status = sqlite3_exec(db, "PRAGMA short_column_names=OFF; PRAGMA full_column_names=ON; ", 0, 0, &errmsg);

        if (status != SQLITE_OK) {
            sqlite3_close(db); mexErrMsgTxt(errmsg);
        }  
    
    }
    
	//---------------------------
	// ACCESS
	//---------------------------
	
	switch (mode & 0xf) {
	
		//---------------------------
		// EXECUTE
		//---------------------------
		
		case (1): {
                
            plhs[1] = mxCreateCellMatrix(0, 1); output_ix = 0;
            
			status = sqlite3_exec(db, sql, exec_callback, plhs[1], &errmsg);
			
			if (status != SQLITE_OK) {
				sqlite3_close(db); mexErrMsgTxt(errmsg);
			}
            
            mxSetM(plhs[1], output_ix);
            
            sqlite3_free(errmsg);
            
            break;
			
		}
		
		//---------------------------
		// GET TABLE
		//---------------------------
		
		case (2): {
			
			status = sqlite3_get_table(db, sql, &result, &rows, &cols, &errmsg);
			
			if (status != SQLITE_OK) {
				sqlite3_close(db); mexErrMsgTxt(errmsg);
			}
            
            sqlite3_free(errmsg);
			
			// TODO: process results
			
			sqlite3_free_table(result);
            
            break;
			
		}
		
		//---------------------------
		// PREPARED
		//---------------------------
		
		case (3): {
            
			//---------------------------
			// PREPARE
			//---------------------------
			
			status = sqlite3_prepare(db, sql, len, &statement, 0);

			if (status || statement == NULL) {
                /* NOTE: memory for errmsg is managed by sqlite.  No need to free it */
                errmsg = sqlite3_errmsg(db);
                snprintf(errmsg_buf, MSG_BUFFER_SIZE, 
                    "sqlite error: \n%s\n", errmsg);
                
                sqlite3_close(db);
                mexErrMsgTxt(errmsg_buf);
			}
				
			// NOTE: get output colums to recognize select

			cols = sqlite3_column_count(statement);

			//---------------------------
			// NOT SELECT
			//---------------------------

			if (cols == 0) {

				//---------------------------
				// LITERAL SQL
				//---------------------------
				
				if (nrhs < 4) {
					
					//--
					// step over results
					//--

					status = sqlite3_step(statement);
					
					while (status == SQLITE_ROW) {
						status = sqlite3_step(statement);
					}
					
				//---------------------------
				// PARAMETRIZED SQL
				//---------------------------
					
				} else {
					
					//--
					// get parameter count and number of parameter sets
					//--
					
					count = mxGetM(prhs[3]); sets = mxGetN(prhs[3]);
				
					//--
					// iterate over parameter sets
					//--
					
					for (k = 0; k < sets; k++) {
						
						//--
						// reset and bind statement
						//--
						
						sqlite3_reset(statement);
						
						bind_parameters(statement, (mxArray *) prhs[3], k * count, count);
						
						//--
						// step over results
						//--

						status = sqlite3_step(statement);
						
						while (status == SQLITE_ROW) {
							status = sqlite3_step(statement);
						}
						
						//--
						// handle error
						//--
						
						if (status != SQLITE_DONE) {
							sqlite3_close(db); sqlite3_finalize(statement); mexErrMsgTxt(sqlite3_errmsg(db)); 
						}
						
					}
					
				}
					
			//---------------------------
			// SELECT
			//---------------------------

			} else {
                
				//--
				// step for status and number of rows
				//--

				status = sqlite3_step(statement);

                // NOTE: this does NOT give the number of rows.
                
				//rows = sqlite3_data_count(statement);

				//--
				// allocate output
				//--
                
				if (nlhs > 1) {
					
                    fieldnames = mxCalloc(cols, sizeof(char *));
                    
                    for (k = 0; k < cols; k++) {
                        
                        fieldnames[k] = mxCalloc(128, sizeof(char *));
                        
                        strcpy(fieldnames[k], sqlite3_column_name(statement, k));
                        
                        //--
                        // replace '.'s with '_'s
                        //--
                        
                        if (strchr(fieldnames[k],'.') != NULL)
                            *strchr(fieldnames[k],'.') = '_';
                        
                    }
                                      
					plhs[1] = mxCreateStructMatrix(
                        0, 1, cols, fieldnames
                    );                  
                    
					if (!plhs[1]) {
						sqlite3_close(db); mexErrMsgTxt("Problem allocating output.\n"); 
					}

				}
				
				//--
				// step over results and output rows
				//--
                
                j = 0;

				while (status == SQLITE_ROW) {	
                        
                    //--
                    // dynamically grow struct array
                    //--
                    
                    mxSetData(
                        plhs[1], mxRealloc(mxGetData(plhs[1]), (j + 1) * cols * sizeof(mxArray *))
                    );
                    
                    //mxSetM(plhs[1], j + 1);
                              
					//--
					// get row
					//--

					for (k = 0; k < cols; k++) {
                        
                        switch (sqlite3_column_type(statement, k)){
                        
                            case (SQLITE_INTEGER):
                                
                            case (SQLITE_FLOAT):
                                
                                value = mxCreateDoubleScalar(sqlite3_column_double(statement, k)); break;
                                
                            case (SQLITE_TEXT):
                                
                                value = mxCreateString((const char *)sqlite3_column_text(statement, k)); break;

                            case (SQLITE_BLOB):
                                
                                // what do we do in this case? what is this used for?
                                      
                            case (SQLITE_NULL):
                                
                                value = mxCreateDoubleMatrix(0, 0, mxREAL);  break;
                                
                        }
                        
                       // mxFree(mxGetField(plhs[1], j, fieldnames[k]));
                        
                        mxSetField(plhs[1], j, fieldnames[k], value);
                                      
					}

					//--
					// step to get next row
					//--

					status = sqlite3_step(statement);  j++;

				}
                
                for (k = 0; k < cols; k++){
                    mxFree(fieldnames[k]);
                }
                
                mxFree(fieldnames);
                
                mxSetM(plhs[1], j);

			}

			//--
			// finalize statement
			//--

			sqlite3_finalize(statement);
            
			//--
			// handle error
			//--

			if (status != SQLITE_DONE) {
				sqlite3_close(db); mexErrMsgTxt(sqlite3_errmsg(db));
			}
			
		}
		
	}
	
	//---------------------------
	// CLOSE
	//---------------------------
	
	done:    
        
	sqlite3_close(db);
	
	if (nlhs) {
		plhs[0] = mxCreateDoubleScalar((double) status);
	}
    
	mxFree(file); 
	
	mxFree(sql);
	
}
