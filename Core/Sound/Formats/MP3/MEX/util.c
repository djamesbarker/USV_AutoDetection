/*
 * MAX MACRO
 * max(a, b) - bigger of [a, b], type independant.
 */

# ifndef max
	# define max(a, b) ((a) > (b) ? (a) : (b))
# endif

#define PAD_FRAMES 9

typedef unsigned long long uint64;

/*
 * Variable bit rate-specific information field structure
 */

struct vbr_tag {
	int tag;
	int is_vbr;
	int flags;
	unsigned int num_frames;
	float bytes;
	float * seek_table;
	int quality;
};
	
/*
 * C-level information structure
 */

struct mp3_info {
	int bitrate;
	int frames;
	int samplerate;
	int stereo;
	int version;
	int layer;
	int channels;
	int samplesize;
	char *format;
	int samples_per_frame;
	double samples;
	double duration;
	int offset;
	int vbr;
	int N;
};

/*
 * VBR_TAG_INIT - initialize VBR tag information structure
 */

void vbr_tag_init(struct vbr_tag * tag){

	tag->seek_table = calloc(100, sizeof(float));
	tag->is_vbr = 0;
	tag->bytes = 0.0;
	tag->num_frames = 0;
	tag->flags = 0;
	tag->tag = 0;
	
}

/*
 * VBR_TAG_FINISH - destroy VBR tag information structure
 */

void vbr_tag_finish(struct vbr_tag * tag){
	
	free(tag->seek_table);
	
}

/*
 * HEADER_VERSION - return MPEG version number of frame
 */

int header_version(struct mad_header * header){

	if (header->flags & MAD_FLAG_MPEG_2_5_EXT)
		return 3;
	
	if (header->flags & MAD_FLAG_LSF_EXT || header->flags & MAD_FLAG_MC_EXT)
		return 2;
	
	return 1;
	
}


/*
 * SAMPLES_PER_FRAME - the number of samples encoded in the frame
 */

int samples_per_frame(struct mad_header * header){
	
	int spf;
	
	/*
	 * information: http://www.dv.co.yu/mpgscript/mpeghdr.htm
	 */
	
	
	switch (header->layer){
	
		case (1): spf = 384; break;
		
		case (2): spf = 1152; break;
	
		case (3): spf = header_version(header) == 1 ? 1152 : 576; break;
			
	}
	
	return spf;
	
}


/*
 * BYTES_PER_FRAME - decode an MPEG header and extrapolate an average 
 * number of bytes per frame
 */

double bytes_per_frame(struct mad_header * header){
	
	int crc;
	double bytes_per_frame;

	crc = (header->flags & MAD_FLAG_PROTECTION) ? 2 : 0;
	
	bytes_per_frame = ((double) (samples_per_frame(header) / 8) * (double)header->bitrate/(double)header->samplerate) + (float)crc;
	
	return bytes_per_frame;
	
}


/*
 * PARSE_VBR_TAG - parse Xing-style VBR tag and populate information struct
 */

void parse_vbr_tag(char * buf, struct vbr_tag * tag){

	int ix, table_ix, flags;
	
	tag->is_vbr = 1;
	
	ix = 7; flags = buf[ix++];
	
	if (flags & 0x01){
		tag->num_frames = (
			0x01000000 * (buf[ix] & 0xff) + 
			0x00010000 * (buf[ix + 1] & 0xff) + 
			0x00000100 * (buf[ix + 2] & 0xff) + 
			0x00000001 * (buf[ix + 3] & 0xff)
		); 
		ix += 4;
	}
	
	if (flags & 0x02){
		tag->bytes = (float) (
			0x01000000 * (buf[ix] & 0xff) + 
			0x00010000 * (buf[ix + 1] & 0xff) + 
			0x00000100 * (buf[ix + 2] & 0xff) + 
			0x00000001 * (buf[ix + 3] & 0xff)
		);
		ix += 4;	
	}
	
	if (flags & 0x04){	
		for(table_ix = 0; table_ix < 100; table_ix++){	
			tag->seek_table[table_ix] = ((float) buf[ix++]) / 256.0;	
		}		
	}
	
	if ((buf[0] == 'I') && (buf[1] == 'n') && (buf[2] == 'f') && (buf[3] == 'o')){
		tag->is_vbr = 0;
	}
	
	tag->flags = flags; 
	
}

/*
 * FIND_NUM_FRAMES - find the number of frames in an mp3 file
 */

int find_num_frames(FILE *fp, struct mad_stream * stream, struct mad_header * header){

	int byte_ix, num_frames;
	
	char buf[8192]; char error[128];
	
	byte_ix = find_first_frame(fp, stream, header, 0, 0);
	
	num_frames = 0;
	
	while(1){
		
		clearerr(fp); fseek(fp, byte_ix, SEEK_SET); fread(buf, sizeof(buf[0]), 1, fp);
		
		if (feof(fp) != 0) 
			break;
		
		byte_ix = find_next_frame(fp, stream, header, buf, byte_ix); num_frames++;
		
		if (byte_ix < 0)
			sprintf(error, "Trouble estimating number of frames: %s\n", mad_stream_errorstr(stream));
	
	}
	
	return num_frames;
	
}


/*
 * IS_VBR - check of vbr-ness of file  
 */

int is_vbr(FILE *fp, struct mad_stream * stream, struct mad_header * header, struct vbr_tag * tag, int byte_ix){
	
	int crc, is_vbr, synched, tag_offset, j, prev_rate, init_ix;
	
	struct mad_header new_header;
	
	double bpf;
	
	char buf[8192];
	
	char error[128];
	
	/*
	 * Early return for empty tag
	 */
	
	if (!tag)
		return 0;
	
	init_ix = byte_ix;
	
	/*
	 * get information from vbr tag if possible
	 */
	
	if (header->mode != MAD_MODE_SINGLE_CHANNEL) 
		tag_offset = 32 + 4;
	else
		tag_offset = 17 + 4;
	
	fseek(fp, byte_ix + tag_offset, SEEK_SET);
	fread(buf, sizeof(buf[0]), 120, fp);	
	
	if (((buf[0] == 'X') && (buf[1] == 'i') && (buf[2] == 'n') && (buf[3] == 'g')) ||
		((buf[0] == 'I') && (buf[1] == 'n') && (buf[2] == 'f') && (buf[3] == 'o'))) {
			
		tag->tag = 1; parse_vbr_tag(buf, tag); return 1; 
		
	}
		
	/*
	 * Otherwise. Check into stream and see if bitrate is still the same
	 */
	
	tag->tag = 0;
	
	prev_rate = header->bitrate; byte_ix = init_ix; tag->is_vbr = 0;
	
	mad_header_init(&new_header);
	
	for (j = 0; j < 50; j++){
		
		byte_ix = find_next_frame(fp, stream, &new_header, buf, byte_ix);
		
		if (byte_ix < 0){
			
			if (feof(fp))
				tag->is_vbr = 0;	
			else
				continue;
	
		}
			
		if (new_header.bitrate != prev_rate){
			tag->is_vbr = 1; break;
		}
		
		prev_rate = new_header.bitrate;
			
	}
	
	/*
	 * find number of frames
	 */
	
	if (tag->is_vbr){
		
		tag->num_frames = find_num_frames(fp, stream, &new_header);
		
		if (tag->num_frames < 0){
			sprintf(error, "Trouble estimating number of frames: %s\n",  mad_stream_errorstr(stream)); mexErrMsgTxt(error);
		}
		
	}
	
	mad_header_finish(&new_header);
	
	return tag->is_vbr;
	
}


/*
 * FIND_NEXT_FRAME - find the next frame, given the index to this frame
 */

int find_next_frame(FILE *fp, struct mad_stream * stream, struct mad_header * header, char * buf, int byte_ix){
	
	int bytes;
	
	fseek(fp, byte_ix, SEEK_SET);	
	fread(buf, sizeof(buf[0]), 8192, fp);	
	
	mad_stream_buffer(stream, buf, 8192);
	stream->sync = 0;
	mad_header_decode(header, stream);
	
	bytes = stream->next_frame - stream->this_frame;
	
	if (stream->error){
		return -1;	
	}
	
	byte_ix += bytes;
	
	return byte_ix;
	
}


/*
 * FIND_FIRST_FRAME - seek into mp3 file until the first valid frame
 */

int find_first_frame(FILE *fp, struct mad_stream * stream, struct mad_header * header, struct vbr_tag * vbr_tag, int ix){
	
	int byte_ix, buflen, vbr;
	
	char buf[8192]; char error[128];
	
	byte_ix = ix; buflen = 8192;
	
	/*
	 * look for first header
	 */
	
	while(1) {
	
		fseek(fp, byte_ix, SEEK_SET); ungetc(fgetc(fp), fp);
		
		if (feof(fp))
			mexErrMsgTxt("End of file before first header.\n");
		
		fread(buf, sizeof(char), buflen, fp);	
		
		mad_stream_buffer(stream, buf, buflen);
	
		/* 
		 * force sync 
		 */
		
		stream->sync = 0;
		
		//--------------------
		
        if (mad_header_decode(header, stream) == 0) {	
			byte_ix += (stream->this_frame - stream->buffer); stream->error = 0; break;
		} 
    
		//--------------------
		
		if (stream->error == MAD_ERROR_BUFLEN) {
			byte_ix += buflen; continue;
		}
		
		byte_ix += stream->ptr.byte - stream->buffer + 2;		
				
	}
	
	if (stream->error) {
		
		sprintf(error, 
			"Trouble Finding First Frame: %s\n(Layer: %d, Bitrate: %d)\n", 
			mad_stream_errorstr(stream), header->layer, header->bitrate
		); 
		
		mexErrMsgTxt(error);
		
	}
	
	/*
	 * first valid frame is AFTER VBR tag frame
	 */
	
	if (vbr_tag == 0)
		return byte_ix;
	
	vbr = is_vbr(fp, stream, header, vbr_tag, byte_ix);
	
	if ((vbr == 1) && vbr_tag->tag){	
		byte_ix = find_next_frame(fp, stream, header, buf, byte_ix);
		stream->error = 0;
		return byte_ix;
	}
	
	stream->error = 0;
	
	return byte_ix;
	
}

/* 
 * SEEK_TO_FRAME - seek to the frame containing sample sample_num, and return
 * the remainder index, ie. how far into the frame sample sample_num occurs.
 */

int seek_to_frame(FILE * fp, uint64 sample_num){
		
	struct mad_stream stream;
    
	struct mad_header header;
    
	struct vbr_tag vbr_tag;
	
	int sample_ix, byte_ix, spf, k; 
	
	int first_frame_ix, pad_frames, start_frame, target_frame;
	
	char buf[8192]; 
    
    /*
     * -- SETUP --
     */
    
    /*
     * Initialize Structures
     */
    
    mad_stream_init(&stream); mad_header_init(&header); vbr_tag_init(&vbr_tag);
	
	/*
	 * find and decode first frame
	 */
	
	first_frame_ix = find_first_frame(fp, &stream, &header, &vbr_tag, 0);
	
	if (first_frame_ix < 0) {
		sprintf(buf, "Trouble Finding First Frame: %s\n", mad_stream_errorstr(&stream)); mexErrMsgTxt(buf);
	}
	
	/*
	 * Calculate samples per frame, starting frame number, and local sample index
	 */
	
	spf = samples_per_frame(&header); target_frame = sample_num/spf;
    
    /* NOTE: Read 2 frames early to catch bit-reservoir problems, setup to discard padding frames. */
	
    start_frame = max(target_frame - PAD_FRAMES, 0); pad_frames = target_frame - start_frame;	
    
	sample_ix = sample_num % spf + pad_frames * spf;
    
    /*
     * -- SEEK --
     */
    
	/*
	 * constant bitrate: Seek blindly - 1 byte early to account for byte padding
	 */
	
	if (vbr_tag.is_vbr == 0){
        
        byte_ix = first_frame_ix + (double)start_frame * bytes_per_frame(&header) - 1;
		
		byte_ix = find_first_frame(fp, &stream, &header, 0, max(byte_ix, 0));
		
		fseek(fp, byte_ix, SEEK_SET);
		
	}
		
	/*
	 * Variable bitrate: Jump frame to frame until we get there...
	 */
	
	else {
	
		byte_ix = first_frame_ix;

		for(k = 0; k < start_frame; k++){
            
			byte_ix = find_next_frame(fp, &stream, &header, buf, byte_ix);	
			
			if (byte_ix < 0){
				sprintf(buf, "Trouble Seeking: %s\n", mad_stream_errorstr(&stream)); mexErrMsgTxt(buf);
			}
            
		}	

		fseek(fp, byte_ix, SEEK_SET);
	
	}
	
    /*
     * -- CLEAN UP --
     */
    
	mad_stream_finish(&stream);
	mad_header_finish(&header);
	vbr_tag_finish(&vbr_tag);
	
    return sample_ix;
	
}


/*
 * GET_INFO - grab mp3 file information using libmad
 */

int get_info(FILE * fp, struct mp3_info * info){
	
	int vbr, file_size, spf;
	
	struct vbr_tag vbr_tag;
	
	struct mad_stream stream; struct mad_header header;
	
	char error[128]; char buf[8192];
	
	mad_stream_init(&stream); mad_header_init(&header);
	
	vbr_tag_init(&vbr_tag);
		
	/* 
	 * get size of file in bytes.
	 */
	
	fseek(fp, 0, SEEK_END);
	file_size = ftell(fp);
	
	/*
	 * find first header and read it, return the byte offset.
	 */
	
	info->offset = find_first_frame(fp, &stream, &header, &vbr_tag, 0);
	
	fseek(fp, info->offset, SEEK_SET);	
	fread(buf, sizeof(char), 8192, fp);	

	mad_stream_buffer(&stream, buf, 8192);
	
	mad_header_decode(&header, &stream);
	
	info->vbr = vbr_tag.is_vbr;
	
	/*
	 * compute information fields
	 */

	info->samplerate = header.samplerate;
	info->stereo = (header.mode != MAD_MODE_SINGLE_CHANNEL);
	info->version = header_version(&header);
	info->layer = (int) header.layer;
	info->channels = info->stereo ? 2 : 1;
	info->samplesize = 16;
	info->samples_per_frame = samples_per_frame(&header);	
	
	if (vbr_tag.num_frames) {
		
		info->frames = vbr_tag.num_frames;	
		info->samples = (double)info->frames * (double)info->samples_per_frame;
		info->duration = info->samples / (double) info->samplerate;
		info->bitrate = (int) ((double) ((file_size - info->offset) / 125) / info->duration);
		
	} else {
		
		info->frames = (file_size - info->offset) / bytes_per_frame(&header);
		info->samples = (double)info->frames * (double)info->samples_per_frame;
		info->duration = info->samples / (double) info->samplerate;
		info->bitrate = header.bitrate / 1000;
			
	}
	
	/* 
	 * clean up.
	 */
	
	mad_stream_finish(&stream);
	mad_header_finish(&header);	
	vbr_tag_finish(&vbr_tag);
	
	return 0;
	
}
