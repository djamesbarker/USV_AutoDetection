function test_poly(d,N)

%--
% set default values
%--

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

if (nargin < 2) 
	N = 6;
end 

if (nargin < 1)
	d = 2;
end

%--
% create polynomial bases
%--

n = 512;

x = linspace(0,1,n)';

for k = 1:(d + 1)
	y = x.^(k - 1); ny = norm(y);
	X(:,k) = y;
end

[Q,R] = qr(X,0); 

R, S = sign(R)

%--
% create random coefficients
%--

C = rand_ab([d + 1,N^2],-1,2); % NOTE: coefficients are uniform in an interval

% C = randn([d + 1,N^2]); % NOTE: coefficients are unit normal

%--
% build and display random polynomials
%--

PX = X * C; 
 
PQ = Q * C; 

test_plot_2(x,PX,'Non-Orthogonal Basis');

test_plot_2(x,PQ,'Orthogonal Basis');


%----------------------------------------------

function test_plot_1(x,P,str)

fig; plot(x,P); title(str);


%----------------------------------------------

function test_plot_2(x,P,str)

h = fig; set(h,'name',str);

N = sqrt(size(P,2));

for k = 1:size(P,2)
	subplot(N,N,k); plot(x,P(:,k));
end
