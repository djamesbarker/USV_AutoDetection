function out = encode_ogg(f1,f2,opt)

% encode_ogg - encode a file to ogg
% ---------------------------------
%
% opt = encode_ogg(f1,f2)
%
% com = encode_ogg(f1,f2,opt)
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
	
	opt.quality = 5; % NOTE: this is a summary flag for a complex configuration
	
end

%--
% check for directly handled input format, if not indicate in options
%--

ext1 = get_formats_ext(get_file_format('temp.wav'));

ext2 = get_formats_ext(get_file_format('temp.aif'));

ext3 = get_formats_ext(get_file_format('temp.flac'));

exts = {ext1{:}, ext2{:}, ext3{:}};

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
	error(['Direct OGG encoding from ', upper(ext), ' is not supported']);
end

%----------------------------------------------------
% BUILD COMMAND STRING
%----------------------------------------------------

%--
% persistently  store location of command-line helper
%--

persistent OGGENC;

if (isempty(OGGENC))
	OGGENC = [fileparts(mfilename('fullpath')), filesep, 'oggenc.exe'];
end

%--
% build full command string
%--

% NOTE: the 'Q' flag tries to make the encoding quiet

out = [ ...
	'"', OGGENC, '" -Q --quality ', num2str(opt.quality), ' --output="', f2, '" "', f1, '"' ...
];
