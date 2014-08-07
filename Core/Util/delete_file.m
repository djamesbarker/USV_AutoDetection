function delete_file(file, pretend)

% delete_file - delete file from system considering svn status
% ------------------------------------------------------------
%
% delete_file(file, pretend)
%
% Input:
% ------
%  file - file
%  pretend - flag

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

%--
% handle input
%--

if nargin < 2
	pretend = 1;
end

%--
% check svn status to see if we use svn delete or system delete
%--

[status, result] = svn('status', file);

% TODO: add interactive options

if pretend
	disp(result); return;
end

if isempty(result) || (~isempty(result) && (result(1) ~= '?'))
	
	status = svn('delete', file);
	
	% NOTE: this should perhaps not be silent
	
	if status
		delete(file);
	end
	
else
	
	delete(file);
	
end
