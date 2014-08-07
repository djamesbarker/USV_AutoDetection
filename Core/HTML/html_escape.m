function str = html_escape(str)

% html_escape - very basic HTML escape 
% -------------------------------------
%
% str = html_escape(str)
%
% Input:
% ------
%  str - string to escape
%
% Output:
% -------
%  str - escaped string

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
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

%--
% set some replacement patterns
%--

% TODO: add other common entities, for example '&amp;'

table = { ...
	'<', '&lt;'; ...
	'>', '&gt;'; ... 
	'"', '&quot;'; ...
	'\', '\\' ...
}; 

%--
% perform replacement
%--

pat = table(:, 1); rep = table(:, 2);

for k = 1:length(pat)
	str = strrep(str, pat{k}, rep{k});
end
