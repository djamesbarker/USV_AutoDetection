function lagrange_chebyshev() 
% Comparison of Lagrangian interpolation polynomials for
% equidistant and non-equidistant (Chebyshev) sample points
% for the function
%
%  f(x) = 1/(1+x^2)
%
% using polynomials of degree 5 and 10.

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

% Author : Andreas Klimke
% Date   : July 2002
% Version: 1.1

% Funktionen definieren
f = inline('1./(1+x.^2)');

% Stützstellen bestimmen
xi = { linspace(-5,5,6); ...
		   [chebyshev(6)*5]; ...
		   linspace(-5,5,11); ...
		   [chebyshev(11)*5] };

for k = 1:4
	yi{k} = f(xi{k});
	ci{k} = polyfit(xi{k},yi{k},length(xi{k})-1);
end

% Plotten der Funktionen
x = linspace(-5,5,101);
for k = 1:2
	subplot(2,2,k*2-1)
	hold on;
	plot(x,polyval(ci{k*2-1},x),'r-','LineWidth',2);
	plot(x,polyval(ci{k*2},x),'b-','LineWidth',2);
	plot(x,f(x),'k-');
	axis tight;
	axis square;
	grid on;
	title('f(x) = 1/(1+x^2)');
	legend(['P_{' num2str(k*5) ', equidistant}'], ...
				 ['P_{' num2str(k*5) ', Chebyshev}'],'exact');
end
for k = 1:2
	subplot(2,2,k*2)
	hold on;
	plot(x,abs((f(x)-polyval(ci{k*2-1},x))),'r-','LineWidth',2);
	plot(x,abs((f(x)-polyval(ci{k*2},x))),'b-','LineWidth',2);
	axis tight;
	axis square;
	grid on;
	title('Error Plot');
	ylabel('absolute error');
end


function x = chebyshev(n)
	x(n:-1:1) = cos( (2* (0:n-1)+1) / (2*n) * pi );
	
