function [X, opt] = read_mp3_cli(f, ix, n, ch, opt)

% read_mp3 - read samples from sound file
% ---------------------------------------
%
% X = read_mp3(f,ix,n,ch)
%
% Input:
% ------
%  f - file location
%  ix - initial sample
%  n - number of samples
%  ch - channels to select
%  opt - conversion request options
%
% Output:
% -------
%  X - samples from sound file
%  opt - conversion request options

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
% $Revision: 587 $
% $Date: 2005-02-22 23:28:55 -0500 (Tue, 22 Feb 2005) $
%--------------------------------
	
%---------------------------------------
% SET PERSISTENT VARIABLES
%---------------------------------------

%--
% set location of command-line utility and temporary file
%--

persistent MPG123 MP3_READ_TEMP;

if (isempty(MPG123))
	
	MPG123 = [fileparts(mfilename('fullpath')), filesep, 'mpg123.exe'];
	
	% NOTE: use a single temporary file to avoid name creation and delete
	
	MP3_READ_TEMP = [tempdir, 'MP3_READ_TEMP.wav'];
	
end

%---------------------------------------
% GET FILE INFORMATION
%---------------------------------------

% TODO: try not get file information on every read, for the moment get the format specific info

info = info_mp3_cli(f);

%--
% create convenience variables
%--

% NOTE: express stereo as number of channels and convert the bitrate from
% kilobits to bits

nch = 2^info.stereo;

bitrate = info.bitrate * 1000;

%---------------------------------------
% BUILD SYSTEM COMMAND STRING
%---------------------------------------

%--
% set channel output string
%--

if (isempty(ch) || (length(ch) == 2))
	
	chan_str = '';			% stereo output
	
else

	if (ch(1) == 1)
		chan_str = ' -0';	% left channel only output
	else
		chan_str = ' -1';	% right channel only output
	end
	
end

%--
% compute frames to skip and set string
%--

skip_ix = 0;

skip_blocks = 0;

skip_str = '';

% NOTE: the conversion to zero index

if (ix > 0)
	
	skip_blocks = floor(ix / info.samples_per_frame);
	
	skip_ix = ix - (skip_blocks * info.samples_per_frame);
	
	skip_str = [' -k ', int2str(skip_blocks)];
	
end

%--
% compute frames to decode and set string
%--

len_str = '';

ixf = ix + n;

if (ixf > ix)

	decode_blocks = ceil(ixf / info.samples_per_frame) - skip_blocks;

	len_str = [' -n ', int2str(decode_blocks)];

end

%---------------------------------------
% DECODE USING BINARY AND LOAD TEMP FILE
%---------------------------------------


%-------------------------------
% TEST MD5 CACHE READING
%-------------------------------

% NOTE: this code is now out of sync with the single temp file idea

% cmd_str = [ ...
% 	'"', MPG123, '" -q', ...
% 	chan_str, skip_str, len_str, ' --wav "TEMP_FILE" ', '"',f,'"' ...
% ];
% 
% temp_file = [tempdir, 'XBAT_CACHE', filesep, md5(cmd_str), '.wav'];
% 
% cmd_str = strrep(cmd_str, 'TEMP_FILE', temp_file);


%--
% decode mp3 to temporary file
%--

cmd_str = [ ...
	'"', MPG123, '" -q', ...
	chan_str, skip_str, len_str, ' --wav "', MP3_READ_TEMP, '" ', '"',f,'"' ...
];

system(cmd_str);

%--
% load data from temporary sound file
%--

% NOTE: out of the alternatives below the last is fastest and not recursive

% NOTE: the only disadvantage has to do with coupling the two unrelated formats

% tic;
% X = sound_file_read(temp_file);
% t1 = toc
% 
% toc
% X = wavread(temp_file);
% t2 = toc
% 
% tic;
% X = read_libsndfile(temp_file,0,decode_blocks * info.samples_per_frame,ch);
% t3 = toc

ifo.file = MP3_READ_TEMP;

if (length(ch) == 1)
	
	% NOTE: when reading a single channel the temporary file has a single channel
	
	X = read_libsndfile(ifo,0,decode_blocks * info.samples_per_frame,1);
	
else
	
	% NOTE: this read swaps the channels if this is needed
	
	X = read_libsndfile(ifo,0,decode_blocks * info.samples_per_frame,ch);

end

%--
% select the desired part of recording
%--

if (ixf > ix)
	
	X = X(skip_ix + [1:(ixf - ix)],:);
	
elseif (skip_ix > 0)
	
	X = X((skip_ix + 1):end,:);
	
end
