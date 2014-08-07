function [c,ia] = setdiff_unique(a,b,flag)

% setdiff_unique - faster setdiff that assumes set unique input
% -------------------------------------------------------------
%
% SETDIFF Set difference.
%
%   SETDIFF(A,B) when A and B are vectors returns the values
%   in A that are not in B. The result will be sorted.  A and B
%   can be cell arrays of strings.
%

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

%   SETDIFF(A,B,'rows') when A are B are matrices with the same
%   number of columns returns the rows from A that are not in B.
%
%   [C,I] = SETDIFF(...) also returns an index vector I such that
%   C = A(I) (or C = A(I,:)).
%
%   See also UNIQUE, UNION, INTERSECT, SETXOR, ISMEMBER.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.15 $  $Date: 1997/11/21 23:40:14 $

%   Cell array implementation in @cell/setdiff.m

error(nargchk(2,3,nargin));

if (nargin == 2)
	flag = '';
end

if isempty(b)
	[c,ia] = unique(a,flag);
	return;
end

if isempty(a)
	c = a;
	ia = [];
	return;
end

if ((nargin == 2) | isempty(flag))

	if ((length(a) ~= prod(size(a))) | (length(b) ~= prod(size(b))))
		error('A and B must be vectors or ''rows'' must be specified.');
	end
	
	rowvec = (size(a,1) == 1) | (size(b,1) == 1);

	%--
	% Make sure a and b contain unique elements.
	%--
	
	[a,ia] = unique(a(:));
	b = unique(b(:));
	
	% Find matching entries
	
	[c,ndx] = sort([a;b]);
	
	% d indicates the location of matching entries
	
	d = find(c(1:end-1)==c(2:end));
	
	ndx([d;d+1]) = []; % Remove all matching entries
	
	d = ndx <= length(a); % Values in a that don't match.
	ia = ia(ndx(d));
	c = a(ndx(d));
	
	if rowvec
		c = c.';
		ia = ia.';
	end

else

	%--
	% Make sure a and b contain unique elements.
	%--
	
	[a,ia] = unique(a,flag);
	b = unique(b,flag);

	%--
	% Automatically pad strings with spaces
	%--
	
	if (isstr(a) & isstr(b))
	
		if (size(a,2) > size(b,2))
			b = [b repmat(' ',size(b,1),size(a,2)-size(b,2))];
		end
		
		if (size(a,2) < size(b,2))
			a = [a repmat(' ',size(a,1),size(b,2)-size(a,2))];
		end
		
	end
	
	if (size(a,2) ~= size(b,2)) 
		error('A and B must have the same number of columns.');
	end
	
	%--
	% Find matching entries
	%--
	
	[c,ndx] = sortrows([a;b]);
	
	%--
	% d indicates the location of matching entries
	%--
	
	d = c(1:end-1,:) == c(2:end,:);
	
	if ~isempty(d)
		d = find(all(d,2));
	end
	
	ndx([d;d+1]) = []; % Remove all matching entries

	d = ndx <= size(a,1); % Values in a that don't match.
	
	ia = ia(ndx(d));
	c = a(ndx(d),:);
  
end
