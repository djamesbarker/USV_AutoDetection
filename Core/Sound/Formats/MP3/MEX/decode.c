/*
 * this code is based on minimad.c which is included with the libmad distribution $
 */

# define BUFLEN 8192 /* file buffer length */

# include "util.c" 

/*
 * This is a private message structure. A generic pointer to this structure
 * is passed to each of the callback functions. Put here any data you need
 * to access from within the callbacks.
 */

struct msg {
    FILE * ifp;
    double * samples;
    int sample_ix;
	int num_samples;
    unsigned char * buffer;
    int buflen;
};

/*
 * Input callback. (re)fill input buffer from file
 */

static
enum mad_flow input(void *data, struct mad_stream *stream)
{
    struct msg *msg = data;        
    unsigned int unconsumedBytes;
    int numbytes;
	
	int flag;
   
	/*
	 * if this is not the first frame, then we need to keep the buffer 
	 * contiguous, we do this by scooting the unused portion of the buffer
	 * to the beginning
	 */
	
    if(stream->next_frame) {
        unconsumedBytes = msg->buffer - stream->next_frame + BUFLEN;
        memmove(msg->buffer, stream->next_frame, unconsumedBytes);
		flag = 0;
    }
    else {	
        unconsumedBytes = 0; flag = 1;
    }
    
	/*
	 * read in the number of bytes necessary to replace all the consumed ones
	 */
	
    numbytes = fread(msg->buffer + unconsumedBytes, 
                    sizeof(msg->buffer[0]), BUFLEN - unconsumedBytes, 
                    msg->ifp);
	
	/*
	 * stop at eof, this means that data will just be zero-padded if samples
	 * beyond the file boundary are requested
	 */

    if(numbytes == 0){
        return MAD_FLOW_STOP;    
	}
	
	/*
	 * point the libMAD stream at the beginning of the buffer, and continue
	 * decoding
	 */
	
    mad_stream_buffer(stream, msg->buffer, BUFLEN);
	
	/*
	 * synchronize for first buffer
	 */
	
	if (flag){	
		mad_stream_sync(stream); stream->error = 0;	
	}
	
    return MAD_FLOW_CONTINUE;
}

/*
 * scale - make 16-bit integers from libMAD's wierd format
 *
 * NOTE: The following utility routine performs simple rounding, clipping, and
 * scaling of MAD's high-resolution samples down to 16 bits. It does not
 * perform any dithering or noise shaping, which would be recommended to
 * obtain any exceptional audio quality. It is therefore not recommended to
 * use this routine if high-quality output is desired.
 */

static inline
signed int scale(mad_fixed_t sample)
{
    /* round */
    sample += (1L << (MAD_F_FRACBITS - 16));
    
    /* clip */
    if (sample >= MAD_F_ONE)
        sample = MAD_F_ONE - 1;
    else if (sample < -MAD_F_ONE)
        sample = -MAD_F_ONE;
    
    /* quantize */
    return sample >> (MAD_F_FRACBITS + 1 - 16);
}

/*
 * This is the output callback function. It is called after each frame of
 * MPEG audio data has been completely decoded. The purpose of this callback
 * is to output (or play) the decoded PCM audio.
 */

static
enum mad_flow output(void *data,
		     struct mad_header const *header,
		     struct mad_pcm *pcm)
{
    unsigned int nchannels, nsamples, maxsamples;
    mad_fixed_t const *left_ch, *right_ch;
    double sample;  
	
    struct msg *msg = data;
    
    /* 
	 * get local copies of pcm struct data 
	 */
    
    nchannels = pcm->channels;
    nsamples  = pcm->length;
    left_ch   = pcm->samples[0];
    right_ch  = pcm->samples[1];
    
	/*
	 * output sample(s) in 16-bit signed little-endian PCM 
	 *
	 * NOTE: in order to do better conversion down to 16 bits, we would need
	 * a routine that operates on the entire pcm->samples[x] array, or at least
	 * some subset of it, noise shaping uses a 1st or 2nd order feedback filter
	 */
	
    while (nsamples--) {
              
        sample = (double) *left_ch++ / (double) MAD_F_ONE;
        msg->samples[msg->sample_ix++] = sample;      
        
		if (nchannels > 1){
		
			sample = (double) *right_ch++ / (double) MAD_F_ONE;
			msg->samples[msg->sample_ix++] = sample;
			
		}
		else {
			msg->samples[msg->sample_ix++] = 0.0;
		}

    }
    
	/*
	 * stop if we've read the requested number of samples
	 */
	
	maxsamples = 2*(msg->num_samples + 2*samples_per_frame((struct mad_header *) header));
    if( msg->sample_ix > maxsamples ) return MAD_FLOW_STOP;
	
	/*
	 * otherwise, just keep on truckin'
	 */
    
    return MAD_FLOW_CONTINUE;
}

/*
 * This is the error callback function. It is called whenever a decoding
 * error occurs. The error is indicated by stream->error; the list of
 * possible MAD_ERROR_* errors can be found in the mad.h (or stream.h)
 * header file.
 */

static
enum mad_flow error(void *data,
		    struct mad_stream *stream,
		    struct mad_frame *frame)
{
	
	/*
	 * actually: ignore errors
	 */
	
    // mexPrintf("%s\n", mad_stream_errorstr(stream));
	
    return MAD_FLOW_IGNORE;
    
}

/*
 * decode: instantiate a decoder object and configure it with callback funtion pointers
 * this code is derived from minimad.c included with the libmad distribution.
 */

static
int decode(FILE *ifp, double *samples, uint64 ix, int n)
{
    struct msg msg;
    char *buffer;     
    struct mad_decoder decoder;
    int result, frame_ix;
    
    /*
	 * allocate file buffer
	 */
    
    buffer = calloc(BUFLEN, sizeof(char));
    
	/* 
	 * initialize our private message structure 
	 */
	
    msg.ifp = ifp;			/* file pointer */
    msg.buffer = buffer;	/* file buffer */
    msg.buflen = BUFLEN;	/* file buffer length */    
	
    msg.sample_ix = 0;		/* samples read */
	msg.num_samples = n;	/* samples to read */
	msg.samples = samples;	/* sample buffer */
	
	/*
	 * seek into file to nearest frame, and return desired sample index into frame
	 */
		
	frame_ix = seek_to_frame(msg.ifp, ix);
	
	/* 
	 * initialize decoder with callbacks 
	 */
	
	mad_decoder_init(&decoder, &msg,
       input, 0 /*header*/, 0 /* filter */, output,
       error, 0 /* message */);
	
    /* 
	 * do actual decoding 
	 */
    
    result = mad_decoder_run(&decoder, MAD_DECODER_MODE_SYNC);
	
    /* 
	 * clean up and return
	 */
    
    mad_decoder_finish(&decoder); 
	
	free(buffer);
    
	return result ? -1 : frame_ix;
	
}

