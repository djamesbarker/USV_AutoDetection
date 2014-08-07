function r = test_savgol(SG)

% Test Savitzky-Golay coefficients
% John Krumm, Microsoft Research, August 2001
% Extract size of filter and number of terms

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

[nSize,nDum,nTerms] = size(SG);

%--
% Compute order of polynomial based on nTerms = (nOrder+1)(nOrder+2)/2
%--

nOrder = -3/2 + sqrt(9/4 - 2*(1-nTerms));

%--
% Make terms of polynomial
%--

syms x y real;
Terms = [];
for j=0:nOrder
    for i=0:nOrder-j
        Terms = [Terms; (x^i)*(y^j)];
    end
end

%--
% Make an image patch using this polynomial with all coefficients being
%--

one (1)
Image = [];
for y = -(nSize-1)/2:(nSize-1)/2 % important to loop through in same scan order as image patch pixels
    for x = -(nSize-1)/2:(nSize-1)/2
        Image = [Image; subs(sum(Terms))];
    end
end
Image = reshape(Image,nSize,nSize);

%--
% Apply filters, all results (coefficients) should be one (1)
%--

Coefs = [];
for i=1:nTerms
    Coefs = [Coefs; sum(sum(SG(:,:,i).*Image))];
end

%--
% Compare, need round() to compensate for roundoff error
%--

% NOTE: perhaps we should look at the errors

if (round(Coefs) == ones(nTerms,1))
    r = 1; % passed test
else
    r = 0; % failed test
end

 

