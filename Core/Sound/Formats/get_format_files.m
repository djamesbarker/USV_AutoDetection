function [out, ext] = get_format_files(in, format)

% get_format_files - get format files from a directory
% ----------------------------------------------------
%
% [out, ext] = get_format_files(in, format)
%
% Input:
% ------
%  in - file parent path
%  format - formats desired (def: all)
%
% Output:
% -------
%  out - files structured by extension
%  ext - extensions

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
% $Revision: 928 $
% $Date: 2005-04-07 18:27:05 -0400 (Thu, 07 Apr 2005) $get
%--------------------------------

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% set default formats
%--

if (nargin < 2)
	format = get_readable_formats;
end

if isempty(format)
	out = []; return;
end

%--
% get available format file extensions
%--

ext = get_formats_ext(format)';

if isempty(ext)
	out = []; return;
end

%--
% set default directory
%--

if (nargin < 1)
	in = pwd;
end

%------------------------------
% GET FILES
%------------------------------

%--
% get all format sound files in directory
%--

out = what_ext(in, ext{:}, 'insensitive');

%--
% remove extensions with no files
%--

for k = length(ext):-1:1
	
	if isempty(out.(ext{k}))
		out = rmfield(out, ext{k}); ext(k) = [];
	end
	
end
