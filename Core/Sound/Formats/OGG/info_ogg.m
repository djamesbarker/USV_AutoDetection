function info = info_ogg(f)

% info_ogg - get sound file info
% ------------------------------
%
% info = info_ogg(f)
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

% NOTE: consider putting precise file information using vorbis comments
% when we encode, so that we can retrieve it here

% NOTE: this might mean that we only handle files that are ogg encoded using xbat

%--------------------------------------------------
% SET PERSISTENT VARIABLES
%--------------------------------------------------

persistent OGGINFO OGG_INFO;

if isempty(OGGINFO)

	%--
	% set location of command-line helper
	%--
	
	% NOTE: consider a function 'mfilepath' to return the path
	
	OGGINFO = [fileparts(mfilename('fullpath')), filesep, 'ogginfo.exe'];
	
	%--
	% create persistent flac info structure
	%--
	
	% NOTE: we only get some useful info fields by default
	
	OGG_INFO = struct( ...
		'channels', [], ...
		'samplerate', [], ...
		'nominal_bitrate', [], ...
		'average_bitrate', [] ... 
	);

end

info = OGG_INFO;

%--------------------------------------------------
% GET FILE INFO
%--------------------------------------------------

%--
% get info using command-line utility
%--

cmd = ['"', OGGINFO, '" -v "', f, '"'];

[status, str] = system(cmd);

str

%-----------------------------------------------
% PARSE STRING AND PACK INFO STRUCTURE
%-----------------------------------------------

%--
% separate lines of 'ogginfo' output
%--

% NOTE: 10 is the code for the newline character

ix = [0, find(double(str) == 10)];

for k = 2:length(ix);
	info_line{k} = str(ix(k - 1) + 1:ix(k) - 1);
end

%--
% find lines containing information and parse the lines
%--

% info = info_line; 
% 
% return;

%--
% find lines containing information, parse, and pack into info structure
%--

% SAMPLERATE

for k = 1:length(info_line)
	
	if (~isempty(findstr('Rate',info_line{k})))
		
		[t1,t2] = strtok(info_line{k},':');
		
		info.samplerate = eval(t2(2:end));
		break;	
		
	end
	
end

% info.samplerate = eval(info_line{5});

% CHANNELS

for k = 1:length(info_line)
	
	if (~isempty(findstr('Channels',info_line{k})))
		
		[t1,t2] = strtok(info_line{k},':');
		
		info.channels = eval(t2(2:end));
		break;
		
	end
	
end

% NOMINAL BITRATE

% NOTE: for this line we remove the label and the units

for k = 1:length(info_line)
	
	if (~isempty(findstr('Nominal bitrate',info_line{k})))
		
		[t1,t2] = strtok(info_line{k},':');
		[t2,t1] = strtok(t2(2:end),' ');
		
		info.nominal_bitrate = eval(t2);
		break;
		
	end
	
end

% AVERAGE BITRATE

% NOTE: for this line we remove the label and the units

for k = 1:length(info_line)
	
	if (~isempty(findstr('Average bitrate',info_line{k})))
		
		[t1,t2] = strtok(info_line{k},':');
		[t2,t1] = strtok(t2(2:end),' ');
		
		info.average_bitrate = eval(t2);
		break;
		
	end
	
end

