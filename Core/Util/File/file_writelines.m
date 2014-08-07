function info = file_writelines(out, lines, fun, opt)

% file_writelines - write lines to file with optional processing
% --------------------------------------------------------------
%
% info = file_writelines(out, lines, fun, opt)
%
%  opt = file_writelines
%
% Input:
% ------
%  out - output file or file identifier
%  lines - file lines
%  fun - fun to process each line
%  opt - options
%
% Output:
% -------
%  info - output file info
%  opt - options

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

%--------------------------------------
% HANDLE INPUT
%--------------------------------------

%--
% set default options and output options if needed
%--

if (nargin < 4) || isempty(opt)
	
	opt = file_process;
	
	if ~nargin
		info = opt; return;
	end
	
end

%--
% set no fun default
%--

if nargin < 3
	fun = [];
end

%--
% check lines are cell array of strings
%--

if ~iscellstr(lines)
	error('File lines must be a string cell array.');
end

%--------------------------------------
% WRITE LINES TO FILE
%--------------------------------------

% TODO: enforce write to file at this level, process will do buffer to buffer

info = file_process(out, lines, fun, opt);
