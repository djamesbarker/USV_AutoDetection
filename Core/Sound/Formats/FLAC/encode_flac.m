function out = encode_flac(f1,f2,opt)

% encode_flac - encode a file to flac
% -----------------------------------
%
% opt = encode_flac(f1)
%
% com = encode_flac(f1,f2,opt)
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

%----------------------------------------------------
% HANDLE INPUT
%----------------------------------------------------

%--
% set default encoding options
%--

if ((nargin < 3) || isempty(opt))

	opt.compression_level = 5; % NOTE: this is a summary flag for a complex configuration
	
end

%--
% possibly translate string compression level
%--

% NOTE: this code is typically not used, it serves to document level values

if (isstr(opt.compression_level))
	
	switch (opt.compression_level)
	
		case ('fastest')
			opt.compression_level = 0;
		
		case ('default')
			opt.compression_level = 5;
		
		case ('best')
			opt.compression_level = 8;
			
		otherwise
			disp(' ');
			error(['Unrecognized character compression level ''', opt.compression_level, '''.']);
			
	end
	
end

%--
% check for directly handled input format, otherwise indicate in options
%--

ext1 = get_formats_ext(get_file_format('temp.wav'));

ext2 = get_formats_ext(get_file_format('temp.aif'));

exts = {ext1{:}, ext2{:}};

[ignore,ext] = file_ext(f1);

if (isempty(find(strcmpi(ext,exts))))
	opt = -1;
end
	
%--
% return options if needed
%--

if (nargin < 3)
	out = opt; return;
end

%--
% indicate that encoding is not supported
%--

if (isequal(opt,-1))
	disp(' ');
	error(['Direct FLAC encoding from ', upper(ext), ' is not supported']);
end

%----------------------------------------------------
% BUILD COMMAND STRING
%----------------------------------------------------

%--
% persistently  store location of command-line helper
%--

persistent FLAC;

if (isempty(FLAC))
	FLAC = [fileparts(mfilename('fullpath')), filesep, 'flac.exe'];
end

%--
% build full command string
%--

% NOTE: read on the implications of the 'lax' option

out = [ ...
	'"', FLAC, '" --force --lax --totally-silent --compression-level-', int2str(opt.compression_level), ...
	' --output-name="', f2, '" "', f1, '"' ...
];











