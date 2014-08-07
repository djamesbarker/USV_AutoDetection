function info = info_flac(f)

% info_flac - get sound file info
% -------------------------------
%
% info = info_flac(f)
%
% Input:
% ------
%  f - file location
%
% Output:
% -------
%  info - format specific info structure

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

%--------------------------------------------------
% SET PERSISTENT VARIABLES
%--------------------------------------------------

persistent METAFLAC FLAC_INFO;

if (isempty(METAFLAC))

	%--
	% set location of command-line helper
	%--
	
	% NOTE: consider a function 'mfilepath' to return the path
	
	METAFLAC = [fileparts(mfilename('fullpath')), filesep, 'metaflac.exe'];
	
	%--
	% create persistent flac info structure
	%--
	
	% NOTE: we only get some useful info fields by default
	
	FLAC_INFO = struct( ...
		'blocksize',[], ...
		'framesize',[], ...
		'samplerate', [], ...
		'channels', [], ...
		'samplesize', [], ...
		'samples', [], ... 
		'md5_signature', [] ...
	);

end

info = FLAC_INFO;

%--------------------------------------------------
% GET FILE INFO
%--------------------------------------------------

%--
% get info using command-line utility
%--

cmd = ['"', METAFLAC, '" --list --block-type=STREAMINFO "', f, '"'];

[status,str] = system(cmd);

%-----------------------------------------------
% PARSE STRING AND PACK INFO STRUCTURE
%-----------------------------------------------

%--
% separate lines of 'metaflac' output
%--

% NOTE: 10 is the code for the newline character

ix = [0, find(double(str) == 10)];

for k = 2:length(ix);
	info_line{k} = str(ix(k - 1) + 1:ix(k) - 1);
end

% NOTE: we remove the first lines, not interested in their content

info_line(1:5) = [];

%--
% parse the info lines
%--

% NOTE: all of this strongly depends on the 'metaflac' output string

for k = 1:length(info_line)
	
	% NOTE: in the first pass we remove the label, in the second the units
	
	[ignore,info_line{k}] = strtok(info_line{k},':');	
	[info_line{k},ignore] = strtok(info_line{k}(2:end),' ');	
	
end

%--
% pack contents into info structure
%--

% NOTE: we put blocksize and framesize min and max into vectors

info.blocksize = [eval(info_line{1}), eval(info_line{2})];

info.framesize = [eval(info_line{3}), eval(info_line{4})];

info.samplerate = eval(info_line{5});

info.channels = eval(info_line{6});

info.samplesize = eval(info_line{7});

info.samples = eval(info_line{8});

% NOTE: the md5 signature is a string that does not need evaluation

info.md5_signature = info_line{9};

%--
% compute duration for convenience
%--

info.duration = info.samples / info.samplerate;
