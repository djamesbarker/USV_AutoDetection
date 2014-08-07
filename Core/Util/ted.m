function [status, result] = ted(file)

% ted - text edit file in an appropiate editor
% -------------------------------------------
%
% ted file
%
% [status, result] = ted(file)
%
% Input:
% ------
%  file - file
%
% Output:
% -------
%  status - status
%  result - result

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

%-----------------
% HANDLE INPUT
%-----------------

%--
% check input is simple file name, not full name
%--

name = isempty(strfind(file, filesep));

if name
	file0 = file;
end

%--
% check for file
%--

% TODO: try to find the file in the current directory first

file = which(file);

% NOTE: create file if needed, consider asking for confirmation

if isempty(file) && name
	file = [pwd, filesep, file0]; fclose(fopen(file, 'w'));
end

if isempty(file) || ~exist(file, 'file')
	error('Unable to find file for editing.');
end

%-----------------
% HANDLE INPUT
%-----------------

%--
% select editor using file extension
%--

[ignore, ignore, ext] = fileparts(file); ext = lower(ext);

switch ext
	
	%--
	% matlab editor
	%--
	
	case {'.c', '.m', '.java'}, edit(file); status = 1; result = '';
		
	%--
	% binary files and sound files
	%--
	
	% TODO: use hex editor for these, this is a kind of text
	
	% NOTE: the exported symbols tool is called directly on 'dll' files
	
	case {'dll', 'exe', mexext}
		
	case get_formats_ext, hxd(file);
	
	%--
	% scite
	%--
	
	otherwise, [status, result] = scite(file);
		
end

