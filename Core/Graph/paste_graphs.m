function N = (varargin)

% network_setup - setup network data structure
% --------------------------------------------
%
% A = network_setup(X,G,A1,G1,...,An,Gn)
%
% Input:
% ------
%  X - positions
%  G - position graph
%  Ak - attribute k 
%  Gk - attribute graph k
%
% Output:
% -------
%  A - network data structure
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

%--
% check nargin
%--

n = nargin;

if (mod(n,2))
	error('The number of input arguments is not even.');
end

%--
% pack input into network
%--

N.P = varargin{1};
N.G = varargin{2};

for k = 1
	N.A{k} = varargin{};
	N.G{k} = varargin{};
end
