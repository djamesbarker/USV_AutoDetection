function [par,type] = prob_to_par(str)

% prob_to_par - get parameter names for probability distribution
% --------------------------------------------------------------
%
% [par,type] = prob_to_par(str)
%
% Input:
% ------
%  str - distribution name
%
% Output:
% -------
%  par - parameter names
%  type - parameter types

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
% create distribution parameter table
%--

T = { ...
	'Gaussian',{'Mu','Sigma'},{'Location','Scale'}; ...
	'Generalized Gaussian',{'Mu','Sigma','Alpha'},{'Location','Scale','Shape'}; ...
	'Log-Gaussian',{'Mu','Sigma'},{'Location','Scale'}; ...
	'Log-Generalized Gaussian',{'Mu','Sigma'},{'Location','Scale'}; ...
	'Exponential', {'Mu'},{'Scale'}; ...
	'Gamma', {'A','B'},{'Shape','Scale'}; ...
	'Power Law',{'Mu','Sigma','Alpha'},{'Location','Scale','Shape'}; ...
	'Rayleigh', {'B'},{'Scale'}; ...
	'Weibull', {'A','B'},{'Scale','Shape'}; ...
	'Beta',{'A','B'},{'Shape','Shape'}; ...		
};
		
%--
% look up parameter names and types if needed
%--

ix = find(strcmp(str,T(:,1)));

if (~isempty(ix))
	
	par = T{ix,2};	
	
	% pad the parameter names to the same length
	
% 	tmp = (strvcat(par));
% 	for k = 1:length(par)
% 		par{k} = tmp(k,:);
% 	end
	
	if (nargout > 1)
		type = T{ix,3};
	end
	
end
