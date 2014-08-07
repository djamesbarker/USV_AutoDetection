function unregister_palette(obj,event,fun)

% unregister_palette - remove palette handle from palette list
% ------------------------------------------------------------
%
% unregister_palette(obj,event,fun)
%
% Input:
% ------
%  obj - palette handle
%  event - reserved
%  fun - clean fun

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
% $Revision: 1482 $
% $Date: 2005-08-08 16:39:37 -0400 (Mon, 08 Aug 2005) $
%--------------------------------

% NOTE: function handle can be used as callback

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% set default clean fun
%--

% NOTE: set empty fun to skip close

if (nargin < 3)
	fun = @closereq;
end

%---------------------------------
% UNREGISTER PALETTES
%---------------------------------

%--
% unregister sequence of palettes
%--

for k = 1:length(obj)

	%--
	% get parent information from palette
	%--

	% NOTE: this makes this function less efficient than register

	par = get_xbat_figs('child',obj(k));

	if (isempty(par))
		continue;
	end

	%--
	% unregister from parent
	%--

	% NOTE: assume palette has single parent
	
	data = get(par,'userdata');

	data.browser.palette.handle = setdiff(data.browser.palette.handle,obj(k));

	set(par,'userdata',data);

	%--
	% yield to fun
	%--
	
	if (~isempty(fun))
		fun();
	end

end

