function [a, b] = fast_min_max(X, Z)

% fast_min_max - fast min and max value computation
% -------------------------------------------------
%
% [a, b] = fast_min_max(X, Z)
%      b = fast_min_max(X, Z)
%
% Input:
% ------
%  X - input image
%  Z - computation mask (def: [])
%
% Output:
% -------
%  a - min value or min and max values
%  b - max value

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
% $Date: 2006-08-20 22:30:23 -0400 (Sun, 20 Aug 2006) $
% $Revision: 6250 $
%--------------------------------

%--------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------

%--
% set mask
%--

if nargin < 2
	Z = [];
end

%--
% apply mask if needed
%--

if ~isempty(Z)
	ix = find(Z); X = X(ix);
end

%--------------------------------------------------
% COMPUTE MIN AND MAX
%--------------------------------------------------

if ~numel(X)
	
	% NOTE: clearly if there are no elements the limits are not defined

	a = [nan, nan];
	
elseif islogical(X)
	
	% NOTE: handle logical as a special case, simply find one one
	
	ix = find(X, 1);
	
	if isempty(find(X, 1))
		a = [0, 0];
	else
		a = [0, 1];
	end
		
else
	
	% NOTE: we just compute min and max jointly for efficiency
	
	a = fast_min_max_(double(X));
	
end

%--
% separate min and max if needed
%--

if (nargout == 2)
	b = a(2); a = a(1);
end
		
