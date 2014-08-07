function lines = file_readlines(in, fun, opt)

% file_readlines - load and possibly process lines of file
% --------------------------------------------------------
%
% lines = file_readlines(in, fun, opt)
%
%   opt = file_readlines
%
% Input:
% ------
%  in - input file or file identifier
%  fun - fun to process each line
%  opt - options
%
% Output:
% -------
%  lines - file lines
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

if (nargin < 3) || isempty(opt)
	
	opt = file_process;
	
	if ~nargin
		lines = opt; return;
	end
	
end

%--
% set no fun default
%--

if nargin < 2
	fun = [];
end

%--------------------------------------
% READ FILE LINES
%--------------------------------------

% NOTE: setting empty output indicates read to buffer behavior

lines = file_process([], in, fun, opt); 
