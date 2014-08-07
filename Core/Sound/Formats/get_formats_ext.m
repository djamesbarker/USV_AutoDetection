function ext = get_formats_ext(format)

% get_formats_ext - get extensions from formats
% ---------------------------------------------
%
% ext = get_formats_ext(format)
%
% Input:
% ------
%  format - format array
%
% Output:
% -------
%  ext - cell array of strings containing file extensions

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

%-------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------

%--
% set default formats
%--

if (nargin < 1) || isempty(format)
	format = get_formats;
end

%-------------------------------------------------
% PACK EXTENSIONS
%-------------------------------------------------

% NOTE: all we do is pack all the strings in a single cell array

ext = cell(0);

for k = 1:length(format)
	ext = {ext{:}, format(k).ext{:}};
end

ext = lower(ext);
