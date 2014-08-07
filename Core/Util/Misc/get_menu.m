function [h,par] = get_menu(g,label,n)

% get_menu - get menu handle using label
% --------------------------------------
%
% h = get_menu(g,label,n)
%
% Input:
% ------
%  g - menu or parent hadles
%  label - menu label string
%  n - single or multiple handle option (def: 1)
%
% Output:
% -------
%  h - menu handle

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
% $Revision: 4816 $
% $Date: 2006-04-26 18:10:12 -0400 (Wed, 26 Apr 2006) $
%--------------------------------

%--
% set option
%--

if (nargin < 3)
	n = 1;
end

%--
% find handles
%--

h = findobj(g,'label',label,'type','uimenu');

%--
% return first handle found
%--

% NOTE: consider warning in the case of non-unique handles

if (length(h) && (n == 1))
	h = h(1);
end

if (nargout > 1)
	par = get(h,'parent');
end

	
