function treeplot(p,c,d)

%TREEPLOT Plot picture of tree.
%   TREEPLOT(p) plots a picture of a tree given a row vector of
%   parent pointers, with p(i) == 0 for a root.
%
%   TREEPLOT(P,nodeSpec,edgeSpec) allows optional parameters nodeSpec
%   and edgeSpec to set the node or edge color, marker, and linestyle.
%   Use '' to omit one or both.
%
%   Example:
%      treeplot([2 4 2 0 6 4 6])
%   returns a complete binary tree.
%
%   See also ETREE, TREELAYOUT, ETREEPLOT.

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

%   Copyright 1984-2004 The MathWorks, Inc.
%   $Revision: 5.12.4.2 $  $Date: 2004/06/25 18:52:28 $

%-----------------------------------------
% COMPUTE POSITIONS
%-----------------------------------------

[x,y,h] = treelayout(p);

f = find(p~=0);

pp = p(f);

X = [x(f); x(pp); repmat(NaN,size(f))]; X = X(:);

Y = [y(f); y(pp); repmat(NaN,size(f))]; Y = Y(:);

%-----------------------------------------
% PRODUCE DISPLAY
%-----------------------------------------

if (nargin == 1)

	n = length(p);
	
	if (n < 500)
		
		plot (x, y, 'ro', X, Y, 'r-');
		
	else
		
		plot (X, Y, 'r-');
		
	end

else

	[ignore, clen] = size(c);
	
	if (nargin < 3)
		
		if (clen > 1)
			d = [c(1:clen-1) '-'];
		else
			d = 'r-';
		end
		
	end
	
	[ignore, dlen] = size(d);
	
	if ((clen > 0) && (dlen > 0))
		
		plot (x, y, c, X, Y, d);
		
	elseif (clen > 0)
		
		plot (x, y, c);
		
	elseif (dlen > 0)
		
		plot (X, Y, d);
		
	else
		
	end

end

xlabel(['height = ' int2str(h)]);

axis([0 1 0 1]);
