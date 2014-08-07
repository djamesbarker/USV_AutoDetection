function out = sound_file_encode(f1, f2, opt, verb)

% sound_file_encode - encode a sound file to a different format
% -------------------------------------------------------------
%
% opt = sound_file_encode(f1, f2)
%
% out = sound_file_encode(f1, f2, opt)
%
% Input:
% ------
%  f1 - input file
%  f2 - output file
%  opt - output encoding specific options (NOTE: empty means use default)
%
% Output:
% -------
%  opt - output encoding specific options
%  out - encoding results information

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

% TODO: handle formats with missing encoding and decoding methods

% TODO: check for same encoding and just move the file

% TODO: handle status and results from system calls

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set verbosity
%--

% NOTE: this should be set to 0 for release

if (nargin < 4) || isempty(verb)
	verb = 1; 
end

%--
% get input and output formats 
%--

% NOTE: we require input and output files since we need both formats

format1 = get_file_format(f1);

format2 = get_file_format(f2);
	
%--
% check whether output format is WAV
%--

% NOTE: encoding to WAV is provided by each format as decode
	
wav_flag = ~isempty(find(strcmpi(format2.ext, 'wav')));
	
%--
% get encoding options from format if needed
%--

if (nargin < 3) || isempty(opt)
	
	% NOTE: there are no options for decoding to wav
	
	if wav_flag
		opt = []; 
	else
		opt = format2.encode(f1);
	end

end

%--
% check for two-step decoding conditions
%--

% NOTE: consider 'from wav' encoding options if no direct encoding is available

if isequal(opt, -1) && ~wav_flag
	
	opt = format2.encode('temp.wav'); direct_flag = 0;
	
else
	
	direct_flag = 1;
	
end
		
%--
% return encoding options
%--

% NOTE: require third argument to be set to empty in order to use default

if (nargin < 3)
	out = opt; return;
end

%--------------------------------------------
% ENCODING
%--------------------------------------------

% NOTE: we currently limit the encoding and decoding API to the system CLI

%--
% record start time
%--

t = clock;

%---------------------------
% DIRECT DECODING
%---------------------------

% NOTE: encoding to WAV is decoding from any format

if wav_flag
	
	if verb
		str = 'DIRECT DECODING';
		disp(' '); str_line(length(str)); disp(str); str_line(length(str));
	end
	
	%--
	% decode directly using input format decode
	%--
	
	format1 = get_file_format(f1);
	
	% NOTE: the decode function creates a CLI command and we execute it
	
	com = format1.decode(f1, f2);
	
	if verb
		disp(' '); disp(strrep(com, xbat_root, ['$XBAT_ROOT', filesep]));
	end
	
	[status, result] = system(com);
	
	if (verb > 1) || status
		disp(result);
	end
	
%---------------------------
% DIRECT ENCODING
%---------------------------

elseif direct_flag
	
	if verb
		str = 'DIRECT ENCODING';
		disp(' '); str_line(length(str)); disp(str); str_line(length(str));
	end
	
	%--
	% encode directly using output format encode
	%--

	% NOTE: the encode function creates a CLI command and we execute it
		
	com = format2.encode(f1, f2, opt);

	if verb
		disp(' '); disp(strrep(com, xbat_root, '$XBAT_ROOT'));
	end
	
	[status, result] = system(com);

	if (verb > 1) || status
		disp(result);
	end
	
%---------------------------
% TWO-STEP ENCODING
%---------------------------

else
	
	if verb
		str = 'TWO-STEP DECODING ENCODING';
		disp(' '); str_line(length(str)); disp(str); str_line(length(str));
	end
	
	%--
	% set persistent temporary file name for two-step encoding
	%--
		
	persistent ENCODE_TEMP;
	
	if isempty(ENCODE_TEMP)
		ENCODE_TEMP = [tempdir, 'ENCODE_TEMP'];
	end
		
	% NOTE: we produce a random number between 1 and 10^6
	
	temp = [ENCODE_TEMP, int2str(rand_ab(1, 1, 10^6)), '.wav'];
	
	%--
	% decode input to wav, encode to output, and measure performance
	%--
	
	com1 = format1.decode(f1, temp);
	
	if verb
		disp(' '); disp(strrep(com1, xbat_root, ['$XBAT_ROOT', filesep]));
	end
	
	[status, result] = system(com1);

	if (verb > 1) || status
		disp(result);
	end
	
	com2 = format2.encode(temp, f2, opt);
	
	if verb
		disp(strrep(com2, xbat_root, ['$XBAT_ROOT', filesep]));
	end
	
	[status, result] = system(com2);
	
	if (verb > 1) || status
		disp(result);
	end
	
end

%----------------------------------------------------
% OUTPUT ENCODING INFORMATION
%----------------------------------------------------

% TODO: consider making this structure uniform it could be used in a number of places

%--
% input and output files
%--

out.in = f1;

out.out = f2;

%--
% encoding time and compression rate
%--

out.time = etime(clock, t);

% NOTE: when going from a compressed to an uncompressed this is < 1

b1 = get_field(dir(f1), 'bytes'); b2 = get_field(dir(f2), 'bytes');

out.compression = b1 / b2;

%--
% sanity check on basic sound file info
%--

% NOTE: this was used to figure out MP3 problem

% info = sound_file_info(f1);
% 
% out.in_info = [info.channels, info.samplerate, info.samples];
% 
% info = sound_file_info(f2);
% 
% out.out_info = [info.channels, info.samplerate, info.samples];

%--
% display results
%--

if verb
	disp(' '); disp(sprintf(to_xml(out)));
end

