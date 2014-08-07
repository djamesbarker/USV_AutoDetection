function ext = get_write_ext(format)

% get_write_ext - get extensions we may write to
% ----------------------------------------------
%
% ext = get_write_ext(format)
%
% Input:
% ------
%  format - list of formats
%
% Output:
% -------
%  ext - extensions we may write to

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
% $Revision: 563 $
% $Date: 2005-02-21 05:59:20 -0500 (Mon, 21 Feb 2005) $
%--------------------------------

%--
% get all formats if needed
%--

if (nargin < 1)
	format = get_formats;
end

%--
% get writeable extensions
%--

ext = cell(0);

for k = 1:length(format)
	if (~isempty(format(k).write))
		ext = {ext{:}, format(k).ext{:}};
	end
end

ext = ext';
