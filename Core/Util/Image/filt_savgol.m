function [NamesCoefs, NamesTerms, XPow, YPow, SG] = filt_savgol(nOrder,nSize)

% Compute Savitzky-Golay coefficients
% John Krumm, Microsoft Research, August 2001
% Requires MatLabSymbolic Math Toolbox
% On return:
% NamesCoefs(i,:) gives the name of coefficient i, e.g. a23
% NamesTerms(i,:) gives the name of the polynomial term i, e.g. (x^2)(y^3)
% XPow(i) and YPow(i) give exponents on x and y for coefficient i
% SG(:,:,i) gives the nSize x nSize filter for computing coefficient i

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
% set up polynomial for a given order
%--

Terms = [];
NamesCoefs = [];
NamesTerms = [];
XPow = [];
YPow = [];
syms x y real;

for j=0:nOrder
	for i=0:nOrder-j

		% NOTE: NamesTerms and NamesCoefs each must have strings all the
		% same length. Each string in NamesCoefs is 3 characters long. Each 
		% string in NamesTerms is 10 characters long. There will be a problem 
		% if nOrder >= 10

		NamesCoefs = [NamesCoefs; sprintf('a%1d%1d',i,j)]; % must all be
		same length

		if (i>0 & j>0)
			NamesTerms = [NamesTerms; sprintf('(x^%d)(y^%d)',i,j)];
		end

		if (i>0 & j==0)
			NamesTerms = [NamesTerms; sprintf('(x^%d) ',i)];
		end

		if (i==0 & j>0)
			NamesTerms = [NamesTerms; sprintf('(y^%d) ',j)];
		end

		if (i==0 & j==0)
			NamesTerms = [NamesTerms; sprintf('1 ')];
		end

		Terms = [Terms; (x^i)*(y^j)];
		
		XPow = [XPow; i];
		YPow = [YPow; j];

	end
end

%--
% compute A matrix for a nSize x nSize window
%--

% NOTE: it is important to loop through in same scan order as image patch pixels

A = [];
for y = -(nSize-1)/2:(nSize-1)/2 
	for x = -(nSize-1)/2:(nSize-1)/2
		A = [A; subs(Terms')];
	end
end

%--
% compute coefficient matrix
%--

% NOTE: this is the heart of this code

C = inv(A'*A)*A';

%--
% extract coefficients
%--

SG = [];
[nTerms, nDum] = size(Terms);
for i=1:nTerms
	SG(:,:,i) = reshape(C(i,:),[nSize,nSize]);
end


