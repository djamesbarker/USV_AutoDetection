function info = info_libsndfile(f)

% info_libsndfile - get sound file info
% -------------------------------------
%
% info = info_libsndfile(f)
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

%--
% convert file string to C string
%--

% NOTE: this string replacement handles network files

f = strrep(f,'\\','??');
f = strrep(f,'\','\\');
f = strrep(f,'??','\\');

%--
% get sound file info using mex
%--

info = sound_info_(f); 

%--
% parse log string into field value pairs
%--

info.log = parse_log(format_log(info.log));

%--
% get bitwidth from file log
%--

% NOTE: there are possibly other names for the bits per sample fields

bit_fields = {'SampleSize','BitWidth'}; 

for k = 1:size(info.log,1)
	
	if (~isempty(find(strcmp(bit_fields,info.log{k,1}))))
		info.samplesize = eval(info.log{k,2});
	end
	
end

%--
% compute duration for convenience
%--

info.duration = info.samples / info.samplerate; 


%---------------------------------------------------
% FORMAT_LOG
%---------------------------------------------------

function log = format_log(log)

% format_log - format raw log string into simple to parse string
% --------------------------------------------------------------
%
% log = parse_log(log)
%
% Input:
% ------
%  log - raw log string
%
% Output:
% -------
%  log - formatted log string

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

%--
% convert to double, remove spaces, and replace new lines with semicolons
%--

log = double(log);

log(log == double(' ')) = [];

log(log == 10) = double(';');

%--
% convert back to string and replace double backslaches to singles
%--

log = char(log);

log = strrep(log,'\\','\');


%---------------------------------------------------
% PARSE_LOG
%---------------------------------------------------

function log = parse_log(log)

% parse_log - parse log string into field value pairs
% ---------------------------------------------------
%
% log = parse_log(log)
%
% Input:
% ------
%  log - formatted log string
%
% Output:
% -------
%  log - field value cell array

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

%--
% separate into key value strings
%--

ix = findstr(log,';');

n = ix(end);
ix = ix(1:(end - 1));

ix1 = [1, ix + 1];
ix2 = [ix - 1, n - 1];

for k = 1:length(ix1)
	str{k} = log(ix1(k):ix2(k));
end

%--
% separate keys and values
%--

for k = 1:length(str)
	
	ix = findstr(str{k},':');
	
	if (~isempty(ix))
		out{k,1} = str{k}(1:(ix(1) - 1));
		out{k,2} = str{k}((ix(1) + 1):end);
	else
		out{k,1} = str{k};
		out{k,2} = '';
	end
	
end

%--
% output key value pair cell array
%--

log = out;
