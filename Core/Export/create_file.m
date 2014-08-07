function [file, created] = create_file(file)

% create_file - create file with extension
% ----------------------------------------
% 
% [file, created] = create_file(file)
%
% Input:
% ------
%  file - file to create
%
% Output:
% -------
%  file - file created
%  created - creation indicator

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

% TODO: consider using 'get_fid' when we need to create a file

created = 0;

%--
% check file input
%--

[p1, p2, p3] = fileparts(file);

if isempty(p3)
	error('File must have an extension.');
end

%--
% create directory
%--

% TODO: update this function to indicate the number of directories created

[p1, created] = create_dir(p1);

% NOTE: failed to create parent directory

if isempty(p1)
	file = ''; return;
end

%--
% check for file, create if needed
%--

if exist(file, 'file')
	return;
end

% TODO: handle various file types properly, create a valid file

try
	
	switch p3
		
		case '.mat'
			save(file); created = 1;
			
		otherwise
			fclose(fopen(file, 'w')); created = 1;
			
	end
	
catch
	
	file = '';

end
