function out = find_in_path(pat)

% find_in_path - find path components containing pattern
% ------------------------------------------------------
%
% out = find_in_path(pat)
%
% Input:
% ------
%  pat - pattern to look for, look at 'filter_strings'
%
% Output:
% -------
%  out - path elements containing pattern

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
% $Revision: 1160 $
% $Date: 2005-07-05 14:55:22 -0400 (Tue, 05 Jul 2005) $
%--------------------------------

%--
% filter path strings to get elements containing pattern
%--

out = filter_strings(str_split(path,pathsep),pat);

%--
% display results if no output was required
%--

if (~nargout)
		
	% NOTE: display nothing if nothing ws found
	
	if (~length(out))
		return;
	end
	
	%--
	% prepare display string
	%--
	
	str = strrep(out,'\','\\'); % escape windows filesep
	
	str = strcat(str,pathsep,'\n'); % append pathsep and newline
	
	str = strcat(str{:}); % concatenate cells
	
	%--
	% display
	%--
	
	disp(' '); disp(sprintf(str));
	
end
