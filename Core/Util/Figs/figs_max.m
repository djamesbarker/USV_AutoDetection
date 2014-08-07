function figs_max(h)

% figs_max - maximize figure windows
% ----------------------------------
%
% figs_max(h)
%
% Input:
% ------
%  h - handles to figures to maximize

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
% $Date: 2003-09-16 01:30:50-04 $
%--------------------------------

%--
% get screensize
%--

ss = get(0,'screensize');

%--
% get and sort open figure handles
%--

if (~nargin)
	h = get(0,'children');
	h = sort(h);
end

%--
% maximize figure windows
%--

for k = 1:length(h)
	fig_sub(1,1,1,h(k));
end
