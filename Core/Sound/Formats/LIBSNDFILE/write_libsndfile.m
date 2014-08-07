function out = write_libsndfile(f,X,r,opt)

% write_libsndfile - write sound samples to file
% ----------------------------------------------
%
%  opt = write_libsndfile(f)
%
% flag = write_libsndfile(f,X,r,opt)
%
% Input:
% ------
%  f - file location
%  X - samples to write to file
%  r - sample rate
%  opt - format specific write options
%
% Output:
% -------
%  opt - format specific write options
%  flag - success flag

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%------------------------------------------
% CREATE PERSISTENT TABLES
%------------------------------------------

persistent FORMAT_TABLE ENCODING_TABLE;

if (isempty(FORMAT_TABLE))
	
	% NOTE: the order of the formats and encodings is taken from 'sndfile.h'
	
	% TODO: generate using mex or provide as mex input
	
	%--
	% set format table
	%--
	
	FORMAT_TABLE = { ...
		'WAV',	0; ...
		'AIF',	1; ...
		'AU',	2; ...
		'W64',	3; ...
		'FLA',  4; ...
		'FLAC', 4 ...
	};

	%--
	% set encoding table
	%--
	
	ENCODING_TABLE = { ...
		'PCM_U8',		0; ...
		'PCM_S8',		1; ...
		'PCM_16',		2; ...
		'PCM_24',		3; ...
		'PCM_32',		4; ...
		'FLOAT',		5; ... 
		'DOUBLE',		6; ...
		'ULAW',			7; ...
		'ALAW',			8; ...
		'IMA_ADPCM',	9; ...
		'MS_ADPCM',		10; ...
		'GSM610',		11 ...
	};

end

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

if ((nargin < 4) || isempty(opt))
	
	%--
	% set default encoding options based on file extension 
	%--
		
	[ignore,ext] = file_ext(f);

	ext = upper(ext);
	
	if (~isempty(find(strcmpi(ext,FORMAT_TABLE(:,1)))))
		opt.format = upper(ext);
	else
		disp(' ');
		error(['Unsupported file extension ''', ext, '''.']);
	end
		
	%--
	% set default write encoding
	%--
	
	opt.encoding = 'PCM_16';
	
end

%--
% output option structure if needed
%--
	
if (nargin == 1)
	out = opt; return;
end

%------------------------------------------
% WRITE FILE
%------------------------------------------

%--
% get format code from table
%--

ix = find(strcmp(opt.format,FORMAT_TABLE(:,1)));

if (isempty(ix))
	disp(' '); 
	error(['Unsupported format ''' opt.format '''.']);
end

fmt_code = FORMAT_TABLE{ix,2};

%--
% get encoding code from table
%--

ix = find(strcmp(opt.encoding,ENCODING_TABLE(:,1)));

if (isempty(ix))
	disp(' '); 
	error(['Unsupported encoding ''' opt.encoding '''.']);
end

enc_code = ENCODING_TABLE{ix,2};

%--
% convert file string to C string
%--

% NOTE: this string replacement handles network files

f = strrep(f,'\\','??');
f = strrep(f,'\','\\');
f = strrep(f,'??','\\');

%--
% write file using mex
%--

sound_write_(X', r, f, fmt_code, enc_code); % note the transpose

% NOTE: output success flag

out = 1;
