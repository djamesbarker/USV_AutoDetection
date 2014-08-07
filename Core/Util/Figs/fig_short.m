function str = fig_short(str,h)

% fig_short - get and set fig short caption
% -----------------------------------------
%
% str = fig_short(h)
%     = fig_short(str,h)
%
% Input:
% ------
%  str - short caption string
%  h - figure handle (def: gcf)
%
% Output:
% -------
%  str - short caption string

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
% $Revision: 1.0 $
% $Date: 2003-09-16 01:30:43-04 $
%--------------------------------

%--
% set figure handle
%--

if (nargin < 1)
	str = gcf;
end

%--
% set short caption string
%--

if isstr(str)

	% set figure handle
	
	if (nargin < 2)
		h = gcf;
	end
	
	% set short caption string
	
	data = get(h,'userdata');
	data.fig.short = str;
	set(h,'userdata',data);

%--
% get short caption string
%--

elseif ishandle(str)

	h = str;
	data = get(h,'userdata');
	str = data.fig.short;
	
end
