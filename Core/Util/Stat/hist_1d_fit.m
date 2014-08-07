function [p,y,ci] = hist_1d_fit(X,f,c,a)

% hist_1d_fit - fit model distribution to data
% --------------------------------------------
%
% [p,y,ci] = hist_1d_fit(X,f,c,a)
% 
% Input:
% ------
%  X - input data
%  f - model distribution to fit
%  c - bin centers to evaluate
%  a - alpha for computation of confidence intervals (def: 0.05)
%
% Output:
% -------
%  p - fit parameters for f
%  y - bin values
%  ci - confidence intervals for fit parameters

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
% $Date: 2003-09-16 01:32:04-04 $
% $Revision: 1.0 $
%--------------------------------

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set default alpha
%--

if (nargin < 4)
	a = 0.05;
end

%--
% ensure double data and put in column
%--

x = double(X(:));

%--------------------------------------------
% COMPUTE FIT ACCORDING TO MODEL
%--------------------------------------------

switch (f)
		
%--
% Gaussian
%--

case ('Gaussian')
	
	%--
	% compute fit
	%--
	
	if (nargout > 2)
		
		p = zeros(1,2);
		ci = zeros(1,2);
		[p(1),p(2),ci(1),ci(2)] = normfit(x,a);		
		
	else
		
		p = zeros(1,2);
		[p(1),p(2)] = normfit(x);
		
	end
	
	%--
	% evaluate fit on bin centers
	%--
	
	if (nargin > 2)
		y = normpdf(c,p(1),p(2));
	end
	
%--
% Generalized Gaussian
%--

case ('Generalized Gaussian')

	%--
	% compute fit
	%--
	
	p = gauss_fit(x);
	
	% NOTE: warn about missing confidence intervals
	
	if (nargin > 3)
		disp(' ');
		warning([ ...
			'Confidence intervals not available for', ...
			' ''Generalized Gaussian'' distribution.' ...
		]);
	end
	
	%--
	% evaluate fit on bin centers
	%--
	
	if (nargin > 2)
		y = gauss_pdf(c,p);
	end
	
%--
% Log-Gaussian
%--

case ('Log-Gaussian')

	%--
	% compute fit
	%--
	
	p = lognormal_fit(x);
	
	% warn about missing confidence intervals
	
	if (nargin > 3)
		disp(' ');
		warning(['Confidence intervals not available for' ...
			' ''Log-Gaussian'' distribution.'] ...
		);
		disp(' ');
	end
	
	%--
	% evaluate fit on bin centers
	%--
	
	if (nargin > 2)
		y = lognormal_pdf(c,p);
	end
	
%--
% Log-Gaussian
%--

case ('Log-Generalized Gaussian')

	%--
	% compute fit
	%--
	
	p = loggauss_fit(x);
	
	% warn about missing confidence intervals
	
	if (nargin > 3)
		disp(' ');
		warning(['Confidence intervals not available for' ...
			' ''Log-Generalized Gaussian'' distribution.'] ...
		);
		disp(' ');
	end
	
	%--
	% evaluate fit on bin centers
	%--
	
	if (nargin > 2)
		y = loggauss_pdf(c,p);
	end

%--
% Exponential
%--

case ('Exponential')

	%--
	% compute fit
	%--
	
	if (nargout > 2)		
		[p,ci] = expfit(x,a);	
	else
		p = expfit(x);
	end
	
	%--
	% evaluate fit on bin centers
	%--
	
	if (nargin > 2)
		y = exppdf(c,p);
	end
	
%--
% Exponential
%--

case ('Exponential (Two Sided)')

	%--
	% compute fit
	%--
	
	if (nargout > 2)		
		[p,ci] = dexp_fit(x,a);	
	else
		p = dexp_fit(x);
	end
	
	%--
	% evaluate fit on bin centers
	%--
	
	if (nargin > 2)
		y = dexp_pdf(c,p);
	end
	
case ('Gamma')
	
	%--
	% compute fit
	%--
	
	if (nargout > 2)
		[p,ci] = gamfit(x,a);	
	else
		p = gamfit(x);
	end
	
	%--
	% evaluate fit on bin centers
	%--
	
	if (nargin > 2)
		y = gampdf(c,p(1),p(2));
	end
	
case ('Rayleigh')
	
	%--
	% compute fit
	%--
	
	if (nargout > 2)
		[p,ci] = raylfit(x,a);	
	else
		p = raylfit(x);
	end
	
	%--
	% evaluate fit on bin centers
	%--
	
	if (nargin > 2)
		y = raylpdf(c,p);
	end
	
case ('Power Law')
	
	%--
	% compute fit
	%--
	
	p = power_fit(x);
	
	% warn about missing confidence intervals
	
	if (nargin > 3)
		disp(' ');
		warning(['Confidence intervals not available for' ...
			' ''Power Law'' distribution.'] ...
		);
		disp(' ');
	end
	
	%--
	% evaluate fit on bin centers
	%--
	
	if (nargin > 2)
		y = power_pdf(c,p);
	end
	
case ('Weibull')

	%--
	% compute fit
	%--
	
	if (nargout > 2)
		[p,ci] = weibfit(x,a);	
	else
		p = weibfit(x)		
	end
	
	%--
	% evaluate fit on bin centers
	%--
	
	if (nargin > 2)
		y = weibpdf(c,p(1),p(2));
	end

case ('Beta')
		
	% this uses a modification of the matlab betafit
	% to protect from negative parameter search and with a smaller
	% convergence tolerance
	
% 	%--
% 	% scale data to unit interval
% 	%--
% 	
% 	b = fast_min_max(x);
% 	
% 	if ((b(1) < 1) | (b(2) > 1))
% 		x = lut_range(x,[0,1]);
% 	end
	
	%--
	% compute fit
	%--
		
	if (nargout > 2)
		[p,ci] = beta_fit(x,a);		
	else
		p = beta_fit(x);
	end
	
	%--
	% evaluate fit on bin centers
	%--
	
	if (nargin > 2)
		y = betapdf(c,p(1),p(2));
	end
	
end
