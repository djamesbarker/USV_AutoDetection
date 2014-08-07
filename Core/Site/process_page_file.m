function process_page_file(file, data, debug)

% PROCESS_PAGE_FILE process page file markup
%
% process_page_file(file, data)

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

if nargin < 3
	debug = 0;
end

%--
% create temporary file
%--

temp = [tempname, '.html'];

if ~copyfile(file, temp)
	error('Unable to create temporary file.');
end

%--
% use file process with callback
%--

file_process(file, temp, {@process_callback, data, debug});

%--
% delete temporary file
%--

delete(temp);


