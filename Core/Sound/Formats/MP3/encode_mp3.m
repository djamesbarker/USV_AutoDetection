function out = encode_mp3(f1, f2, opt)

% encode_mp3 - encode a file to mp3
% ---------------------------------
%
% opt = encode_mp3(f1)
%
% com = encode_mp3(f1, f2, opt)
%
% Input:
% ------
%  f1 - input file
%  f2 - output file
%  opt - encoding options
%
% Output:
% -------
%  opt - encoding options, -1 if no direct encoding
%  com - command to execute to perform encoding

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

%------------------------------------------
% CREATE PERSISTENT TABLES
%------------------------------------------

persistent LAME_PATH;

persistent MPEG1_SAMPLERATES MPEG1_BITRATES MPEG2_SAMPLERATES MPEG2_BITRATES;

if isempty(LAME_PATH)

	%--
	% set location of command-line utility
	%--
	
	LAME_PATH = [fileparts(mfilename('fullpath')), filesep , 'lame.exe'];
	
	%--
	% create format based sample rate and bit rate tables
	%--
	
	MPEG1_SAMPLERATES = [ ...
		32, 44.1, 48 ...
	];

	MPEG1_BITRATES = [ ...
		32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 192, 224, 256, 320 ...
	];

	MPEG2_SAMPLERATES = [ ...
		8, 11.025, 12, 16, 22.05, 24 ...
	];

	MPEG2_BITRATES = [ ...
		8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160 ...
	];
	
	%--
	% allowed resample rates table
	%--
	
	RE_SAMPLERATES = unique([MPEG1_SAMPLERATES, MPEG2_SAMPLERATES]);
	
end

%------------------------------------------
% OUTPUT FORMAT SPECIFIC WRITE OPTIONS
%------------------------------------------

% TODO: evaluate whether to expose other LAME flags

if (nargin < 3) || isempty(opt)
	
	%--
	% set encoding options
	%--
	
	opt.format = 'MP3';		% encoding format
	
	opt.encoding = 'CBR';	% encoding type 'CBR' (constant), 'ABR' (average), or 'VBR' (variable) bit rate
	
	opt.bitrate = 160;		% desired bit rate, is the minimum bit rate for variable bit rate encodings
	
	opt.lowpass = 1;		% flag to enable lowpass filtering before encoding
	
	opt.quality = 2;		% quality of encoding algorithm  0-9, smaller means slower and better
	
	opt.resample = [];		% output sample rate
	
end

%--
% check for directly handled input format, otherwise indicate in options
%--

ext1 = get_formats_ext(get_file_format('temp.wav'));

ext2 = get_formats_ext(get_file_format('temp.aif'));

exts = {ext1{:}, ext2{:}};

[ignore, ext] = file_ext(f1);

if isempty(find(strcmpi(ext, exts)))
	opt = -1;
end
	
%--
% return options if needed
%--

if nargin < 3
	out = opt; return;
end

%--
% indicate that encoding is not supported
%--

if isequal(opt, -1)
	error(['Direct MP3 encoding from ', upper(ext), ' is not supported']);
end

%----------------------------------------------------
% BUILD COMMAND STRING
%----------------------------------------------------

%--
% check sample rate and bit rate compatibility
%--

try
	
	%--
	% get samplerate of file to encode
	%--
	
	info = sound_file_info(f1);
	
	% NOTE: convert hertz sample rate to kilohertz

	rk = info.samplerate / 1000;

	test1 = ...
		~isempty(find(rk == MPEG1_SAMPLERATES)) && ...
		~isempty(find(opt.bitrate == MPEG1_BITRATES)) ...
	;

	test2 = ...
		~isempty(find(rk == MPEG2_SAMPLERATES)) && ...
		~isempty(find(opt.bitrate == MPEG2_BITRATES)) ...
	;

	if ~test1 && ~test2
		error(['Sample rate (', num2str(r), ' kHz) and bit rate (', int2str(opt.bitrate), ' kbps) are not supported.']);
	end
	
end

%--
% set encoding string using encoding and bitrate
%--

switch lower(opt.encoding)
	
	case 'cbr'
		enc_str = [' --cbr -b ', int2str(opt.bitrate)];
		
	% NOTE: this is supposed to be the 'safe' variable bit rate
	
	case 'abr'
		enc_str = [' --abr ', int2str(opt.bitrate)];
	
	% NOTE: there are problems getting this option to work
	
	case 'vbr'
		enc_str = [' -v '];
		
	otherwise
		error(['Unsupported encoding ''', opt.encoding, '''.']);
		
end

%--
% check resample if needed and set resample string
%--

if ~isempty(opt.resample)
	
	if isempty(find(opt.resample == RE_SAMPLERATES))
		error(['Output sample rate (', num2str(opt.resample), ' kHz) is not supported.']);
	end
	
	res_str = [' --resample ' num2str(opt.resample)];
	
else
	
	res_str = '';
	
end

%--
% check quality and set quality string
%--

if (opt.quality < 0) || (opt.quality > 9) || (round(opt.quality) ~= opt.quality)
	error('Encoding algorithm quality must be an integer in the range 0-9.');
end

qual_str = [' -q ', int2str(opt.quality)];

%--
% build full command string
%--

% NOTE: there is a problem getting the right number of frames from these files

% out = ['"', LAME_PATH, '" --strictly-enforce-ISO --S', enc_str, res_str, qual_str, ' "', f1, '" "', f2, '"'];

out = ['"', LAME_PATH, '" -S', enc_str, res_str, qual_str, ' "', f1, '" "', f2, '"'];

