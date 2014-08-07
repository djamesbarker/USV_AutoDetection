function figs_keep(varargin)

% figs_keep - keep a set of figures and close others
% --------------------------------------------------
% 
% figs_keep x1 ... xN
%
% Input:
% ------
%  x1 ... xN - handles of figures to keep (separated by spaces)

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
% get open figures
%--

h = findobj(0,'type','figure');

%--
% get figures to delete
%--

for k = 1:nargin
	g(k) = str2num(varargin{k});
end

d = setdiff(h(:)',g(:)');

%--
% close remaining figures
%--

for k = 1:length(d)
	close(d(k));
end
