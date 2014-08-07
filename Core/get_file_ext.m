function ext = get_file_ext(str)

% get_file_ext - get file extensions from strings
% -----------------------------------------------
%
% ext = get_file_ext(str)
%
% Input:
% ------
%  str - strings containing filenames
%
% Output:
% -------
%  ext - file extensions

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

% this function should be private

%--
% filenames are stored in a cell array
%--

for k = 1:length(str)
	
	ix = findstr(str{k},'.');
				
	if (isempty(ix))
		ext{k} = '';
	else
		ext{k} = str{k}((ix(end) + 1):end);
	end
	
end
