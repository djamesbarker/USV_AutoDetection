function [phat, pci] = betafit(x,alpha)
%BETAFIT Parameter estimates and confidence intervals for beta distributed data.
%   BETAFIT(X) Returns the maximum likelihood estimates of the  
%   parameters of the beta distribution given the data in the vector, X.  
%
%   [PHAT, PCI] = BETAFIT(X,ALPHA) gives MLEs and 100(1-ALPHA) 
%   percent confidence intervals given the data. By default, the
%   optional parameter ALPHA = 0.05 corresponding to 95% confidence intervals.
%
%   This function requires all X values to be greater than 0 and
%   less than 1.  You can restrict the fit to valid values by typing
%
%        BETAFIT(X(X>0 & X<1))
%
%   If values are equal to 0 or 1 up to a precision of 1e-6, you
%   can round the X values away from 0 and 1 by typing
%
%        BETAFIT(MAX(1e-6, MIN(1-1e-6,X)))
%
%   See also BETACDF, BETAINV, BETAPDF, BETARND, BETASTAT, MLE. 

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

%   Reference:
%      [1]  Hahn, Gerald J., & Shapiro, Samuel, S.
%      "Statistical Models in Engineering", Wiley Classics Library
%      John Wiley & Sons, New York. 1994 p. 95.

%   ZP. You, 3-13-99, B.A. Jones 1-27-95
%   Copyright 1993-2000 The MathWorks, Inc. 
% $Revision: 1.0 $  $Date: 2003-09-16 01:32:08-04 $

if nargin < 2 
    alpha = 0.05;
end
p_int = [alpha/2; 1-alpha/2];

if min(size(x)) > 1
  error('The first input must be a vector.');
end
x = x(~isnan(x));

if ((min(x) <= 0) | (max(x) >= 1))
  error('All values must be larger than 0 and smaller than 1.');
end

n = length(x);

if (min(x) == max(x))
   error('Cannot fit a beta distribution if all values are the same.');
end

% Initial Estimates.
tmp1 = prod((1-x) .^ (1/n));
tmp2 = prod(x .^ (1/n));
tmp3 = (1 - tmp1 - tmp2);
ahat = 0.5*(1-tmp1) / tmp3;
bhat = 0.5*(1-tmp2) / tmp3;

phat = [ahat bhat];

pstart = [ahat bhat];
ld = sum(log(x));
l1d = sum(log(1-x));
phat = fminsearch('beta_likelihood',pstart,optimset('display','none','tolx',10^-8),ld,l1d,n);

if nargout == 2
  [logL,info]=betalike(phat,x);
  sigma = sqrt(diag(info));
  pci = norminv([p_int p_int],[phat; phat],[sigma';sigma']);
end
