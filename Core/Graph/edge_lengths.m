function [L,l] = edge_lengths(X,E)

% edge_lengths - compute edge lengths
% -----------------------------------
%
%  L = edge_lengths(X,E)
%
% Input:
% ------
%  X - vertex positions
%  E - edge cell array
%
% Output:
% -------

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

%--
% create complex representation of position
%--

% this only works for planar graphs

x = X*[1; i];

%--
% compute edge lengths
%--

for k = 1:length(E)
	L{k} = abs(x(k) - x(E{k})');
end

%--
% put lengths in a vector
%--

if (nargout > 1)
	
	l = [];
	for k = 1:length(L)
		l = [l; L{k}'];
	end

end








% This function can be generalized to the case of measuring
% how distant other variables, linking features, are with
% respect to the graph of another, or even to their own graph,
% for example in this way we may determine if we can tighten
% the linking interval

% Sensitivity analysis of the linking interval is definitely
% an interesting thing to do, it is not clear yet what is the
% mathematical statement behind this
