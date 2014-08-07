function g = over_obj(type)

%OVEROBJ Get handle of object the pointer is over.
%   H = OVEROBJ(TYPE) check searches visible objects of type TYPE in
%   the PointerWindow looking for one that is under the pointer.  It
%   returns the handle to the first object it finds under the pointer
%   or else the empty matrix.
%
%   Notes:
%   Assumes root units are pixels
%   Only works with object types that are children of figure

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

%   L. Ljung 9-27-94, Adopted from Joe, AFP 1-30-95
%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1953 $

% TODO: make this a leaner function and replace over_obj

% TODO: add more filtering than simple type

%--
% get current figure
%--

% NOTE: get 'pointerfigure' not 'currentfigure'

h = get(0,'currentfigure');

if (isempty(h))
	g = []; return;
end

%--
% get location of pointer in figure
%--

% NOTE: assume root and figure units are pixels

loc = get(0,'pointerlocation'); pos = get(h,'position');

x = (loc(1) - pos(1)) / pos(3);

y = (loc(2) - pos(2)) / pos(4);

%--
% check location of figure children
%--

ch = findobj(get(h,'children'),'flat','type',type,'visible','on');

for g = ch'

	u0 = get(g,'units'); set(g,'units','norm');
	
	r = get(g,'Position');
	
	set(g,'Units',u0);

	if ((x > r(1)) && (x < (r(1) + r(3))) && (y > r(2)) && (y < (r(2) + r(4))))
		return;
	end

end

g = [];
