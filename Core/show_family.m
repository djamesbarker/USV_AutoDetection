function show_family(h,eventdata)

% show_family - show parent and siblings of a figure
% --------------------------------------------------
%
% show_family(h);
%
% Input:
% ------
%  h - figure handle

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
% $Revision: 1772 $
% $Date: 2005-09-09 18:34:37 -0400 (Fri, 09 Sep 2005) $
%--------------------------------

% NOTE: for now this only shows the ancestral family

% TODO: add the display of children to this

figure(h);

%--
% check for double click
%--

if (~double_click(h))
	return;
end

%--
% get parent and siblings
%--

par = get_xbat_figs('child',h);

% NOTE: return since no parent implies no siblings

if (isempty(par))
	return;
end

sib = setdiff(get_xbat_figs('parent',par),h);

%--
% display siblings and parent
%--

for k = 1:length(sib)
	figure(sib(k));
end

figure(par);

%--
% keep focus on ourselves
%--

figure(h);
