function S = line_type(n,t,C,L,M)

% line_type - create sequence of linetype strings
% -----------------------------------------------
%
% S = line_type(n,t,C,L,M)
%
% Input:
% ------
%  n - length of sequence
%  t - order type of sequence (def: 'mlc')
%  C - color strings to use
%  L - line strings to use
%  M - marker strings to use
%
% Output:
% -------
%  S - linetype strings

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
% set color, line, and marker strings
%--

if ((nargin < 5) | isempty(M))
	M = {'o','+','*','x','s','d','v'};
end

if ((nargin < 4) | isempty(L))
	L = {'-','--',':'};
end

if ((nargin < 3) | isempty(C))
% 	C = {'r','g','b','k','m','c','y'};
	C = {'r','g','b','k','m','y'};
end

%--
% set type of sequence
%--

if (nargin < 2)
	t = 'mlc';
end

%--
% compute linetype strings
%--

switch (t)

	case ('clm')
	
		i = 1;
		for j = 1:length(C)
		for k = 1:length(L)
		for l = 1:length(M)
			S{i} = [C{j}, L{k}, M{l}];
			i = i + 1;
			if (i > n)
				return;
			end
		end
		end
		end
	
	case ('cml')
	
		i = 1;
		for j = 1:length(C)
		for l = 1:length(M)
		for k = 1:length(L)
			S{i} = [C{j}, L{k}, M{l}];
			i = i + 1;
			if (i > n)
				return;
			end
		end
		end
		end
		
	case ('lcm')
	
		i = 1;
		for k = 1:length(L)
		for j = 1:length(C)
		for l = 1:length(M)
			S{i} = [C{j}, L{k}, M{l}];
			i = i + 1;
			if (i > n)
				return;
			end
		end
		end
		end
		
	case ('lmc')
	
		i = 1;
		for k = 1:length(L)
		for l = 1:length(M)
		for j = 1:length(C)
			S{i} = [C{j}, L{k}, M{l}];
			i = i + 1;
			if (i > n)
				return;
			end
		end
		end
		end
		
	case ('mcl')
	
		i = 1;
		for l = 1:length(M)
		for j = 1:length(C)
		for k = 1:length(L)
			S{i} = [C{j}, L{k}, M{l}];
			i = i + 1;
			if (i > n)
				return;
			end
		end
		end
		end
		
	case ('mlc')
	
		i = 1;
		for l = 1:length(M)
		for k = 1:length(L)
		for j = 1:length(C)
			S{i} = [C{j}, L{k}, M{l}];
			i = i + 1;
			if (i > n)
				return;
			end
		end
		end
		end 
		
end


			
