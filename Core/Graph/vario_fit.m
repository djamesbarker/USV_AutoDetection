function p = vario_fit(g,h,t)

% vario_fit - fit empirical variogram to model
% --------------------------------------------
% 
% p = vario_fit(g,h,t)
%
% Input:
% ------
%  g - empirical variogram
%  h - bin centers
%  t - model to fit
%    'exp' - exponential
%    'gauss' - gaussian
%    'lin' - linear
%    'sph' - spherical
%
% Output:
% -------
%  p - model parameters
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
% fit parameters according to model
%--

switch (t)

	%--
	% exponential model
	%--
	
	case 'exp'
	
		%--
		% initial condition
		%--
		
		x0 = [1, 1, 1];
		
		%--
		% optimize
		%--
		
		x = fmins('norm(exponential(h,x) - g)',x0);
		
		%--
		% pack parameters
		%--
		
		p.c0 = x(1);
		p.c1 = x(2);
		p.a = x(3);
		
	%--
	% gaussian model
	%--
	
	case 'gauss'
	
		%--
		% initial condition
		%--
		
		x0 = [1, 1, 1];
		
		%--
		% optimize
		%--
		
		x = fmins('norm(gaussian(h,x) - g)',x0);
		
		%--
		% pack parameters
		%--
		
		p.c0 = x(1);
		p.c1 = x(2);
		p.a = x(3);
		
	%--
	% linear model
	%--
	
	case 'lin'
		
		%--
		% initial conditions
		%--
		
		x0 = [1, 1];
		
		%--
		% optimize
		%--
		
		x = fmins('norm(linear(h,x) - g)',x0);
		
		%--
		% pack parameters
		%--
		
		p.c0 = x(1);
		p.b = x(2);
		
	%--
	% shperical model
	%--
	
	case 'sph'
		
		%--
		% initial condition
		%--
		
		x0 = [1, 1, 1];
		
		%--
		% optimize
		%--
		
		x = fmins('norm(shperical(h,x) - g)',x0);
		
		%--
		% pack parameters
		%--
		
		p.c0 = x(1);
		p.c1 = x(2);
		p.a = x(3);

end


% exponential - exponential variogram model
% -----------------------------------------
%
% y = exponential(h,p)
%
% Input:
% ------
%  h - points of evaluation
%  p - model parameters
%    .c0
%    .c1
%    .a
%
% Output:
% -------
%  g - variogram values
%

function y = exponential(h,p)

y = p(1) + (p(2) * (1 - exp(-h ./ p(3))));


% gaussian - gaussian variogram model
% -----------------------------------
%
% y = gaussian(h,p)
%
% Input:
% ------
%  h - points of evaluation
%  p - model parameters
%    .c0
%    .c1
%    .a
%
% Output:
% -------
%  g - variogram values
%

function y = gaussian(h,p)

y = p(1) + (p(2) * (1 - exp(-h ./ p(3)).^2));

% linear - linear variogram model
% -------------------------------
%
% y = linear(h,p)
%
% Input:
% ------
%  h - points of evaluation
%  p - model parameters
%    .c0
%    .b
%
% Output:
% -------
%  g - variogram values
%

function y = linear(h,p)

y = p(1) + (p(2) * h);



function y = spherical(h,p)

% spherical - spherical variogram model
% -------------------------------------
%
% y = spherical(h,p)
%
% Input:
% ------
%  h - points of evaluation
%  p - model parameters
%    .c0
%    .c1
%    .a
%
% Output:
% -------
%  g - variogram values
%
