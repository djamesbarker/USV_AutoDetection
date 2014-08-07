function format = get_file_format(f) 

% get_file_format - get format from file
% --------------------------------------
%
% format = get_file_format(f)
%
% Input:
% ------
%  f - filename
%
% Output:
% -------
%  format - format to handle file

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
% $Revision: 587 $
% $Date: 2005-02-22 23:28:55 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%--
% try to get format handler using file extension
%--

[ignore,ext] = file_ext(f);

format = get_formats(0,'ext',ext);

%--
% display warning when format was not found
%--

% NOTE: this is the goal of this function, to handle failure, develop other ways

if (isempty(format))
	disp(' ');
	error(['Unable to get format handler for sound file with extension ''' ext '''.']);
end
