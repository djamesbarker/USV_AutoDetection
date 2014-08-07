function pal = find_waitbar(name)

% find_waitbar - find named waitbar 
% ---------------------------------
%
% pal = find_waitbar(name)
%
% Input:
% ------
% name - waitbar name
%
% Output:
% -------
%  pal - waitbar handle

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
% Author: Matt Robbins
%--------------------------------
% $Revision$
% $Date$
%--------------------------------

%--
% get all waitbars
%--

pal = get_xbat_figs('type', 'waitbar');

%--
% return quickly if there are no waitbars
%--

if isempty(pal)
	return;
end

%--
% find named waitbar
%--

tags = get(pal, 'tag');

ix = find(strcmp(['XBAT_WAITBAR::', name], tags));

if isempty(ix)
	pal = []; return;
end

pal = pal(ix);
