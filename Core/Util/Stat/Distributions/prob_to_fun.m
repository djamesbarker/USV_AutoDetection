function [fun,S] = prob_to_fun(str,type)

% prob_to_fun - get functions for named probability distribution
% --------------------------------------------------------------
%
% [fun,S] = prob_to_fun(str,type)
%
% Input:
% ------
%  str - distribution name
%  type - function type 'pdf', 'fit', or 'rnd' (def: 'pdf') 
%
% Output:
% -------
%  fun - function name or list of available distribution names
%  S - suggested menu separators

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
% set type
%--

if (nargin < 2)
	type = 'pdf';
end

%--
% create distribution function table
%--

T = { ...
	'Gaussian', 'normpdf', 'normfit', 'normrnd'; ...
	'Generalized Gaussian', 'gauss_pdf', 'gauss_fit', 'gauss_rnd'; ...
	'Log-Gaussian','lognormal_pdf','lognormal_fot',''; ...
	'Exponential', 'exppdf', 'expfit', 'exprnd'; ...
	'Exponential (Two Sided)','dexp_pdf','dexp_fit','dexp_rnd'; ...
	'Gamma', 'gampdf', 'gamfit', 'gamrnd'; ...
	'Rayleigh', 'raylpdf', 'raylfit', 'raylrnd'; ...
	'Power Law', 'power_pdf','power_fit',''; ...
	'Weibull', 'weibpdf', 'weib_fit', 'weibrnd'; ...
	'Beta', 'betapdf', 'betafit', 'betarnd'; ...		
};
		
%--
% look up function name
%--

if (nargin)
	
	ix = find(strcmp(str,T(:,1)));
	
	if (~isempty(ix))
		switch (type)	
		case ('pdf')
			fun = T{ix,2};		
		case ('fit')
			fun = T{ix,3};	
		case ('rnd')
			fun = T{ix,4};
		end
	else
		fun = [];
		disp(' ');
		warning(['Unrecognized distribution function ''' str '''.']);
		disp(' ');
	end

%--
% output available windows
%--

else
	
	%--
	% output list of available windows
	%--
	
	fun = T(:,1);
	
	%--
	% output suggested menu separators
	%--
	
	if (nargout > 1)
		n = length(fun);
		S = bin2str(zeros(1,n));
		S{4} = 'on';
		S{end} = 'on';
	end
		
end

