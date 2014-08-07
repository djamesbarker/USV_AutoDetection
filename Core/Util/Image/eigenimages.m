function [E,C,S] = eigenimages(X)

% eigenimages - compute eigenimages base for a collection of images
% -----------------------------------------------------------------
%
% [E,C,S] = eigenimages(X)
%
% Input:
% ------
%  X - input images (in cell array)
%
% Output:
% -------
%  E - eigenimages
%  C - synthesis coefficients
%  S - singular values

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%-------------------------------------------------
% TEST CODE
%-------------------------------------------------

if (~nargin)
	
% 	%--
% 	% create gaussian filter images
% 	%--
% 	
% 	m = 10; n = 40;							% size of basic filter
% 
% 	p = 30; theta = linspace(-pi/2,pi/2,p);		% sequence of rotation angles
% 	
% 	for k = 1:p
% 		X{k} = filt_gauss([m,n],theta(k));
% 	end
% 	
% 	%--
% 	% compute and display eigenimages
% 	%--
% 	
% 	eigenimages(X);
	
	%--
	% create gabor filter images
	%--
	
	m = 40; n = 10;							% size of basic filter

	p = 30; theta = linspace(-pi/2,pi/2,p);		% sequence of rotation angles
	
	for k = 1:p
		X{k} = filt_gabor([m,n],theta(k),0.25);
	end
	
	%--
	% compute and display eigenimages
	%--
	
	eigenimages(X);
	
	return; 
	
end

%-------------------------------------------------
% PACK IMAGES
%-------------------------------------------------

% NOTE: no registration is performed, we could benefit from that

%--
% get largest image size
%--

D = length(X);

for k = 1:D
	[m(k),n(k)] = size(X{k});
end 

M = max(m);
N = max(n);

%--
% pad images to common size
%--

for k = 1:D
	X{k} = image_pad(X{k},0.5 * [(M - m(k)),(N - n(k))],0);
end

%--
% pack images into matrix
%--

A = zeros((M * N),D);

for k = 1:D
	A(:,k) = X{k}(:);
end

%-------------------------------------------------
% COMPUTE EIGENIMAGES
%-------------------------------------------------

% NOTE: we compute the economy size decomposition

[U,S,V] = svd(A,0);

%-------------------------------------------------
% UNPACK EIGENIMAGES
%-------------------------------------------------

% NOTE: reconsider how we use the scaling

for k = 1:D
	E{k} = reshape(U(:,k),M,N);
end

C = S * V;

%-------------------------------------------------
% DISPLAY OUTPUT
%-------------------------------------------------

% TODO: include display of the coefficients and the singular values

if (~nargout)
	
	%--
	% display padded input images
	%--
	
	h = fig; image_view(X);
	
	set(h,'name','INPUT IMAGES');
	
	%--
	% display eigenimages
	%--
	
	h = fig; image_view(E);
	
	set(h,'name','EIGENIMAGES');
	
	%--
	% display truncated synthesis
	%--
	
	% NOTE: synthesis should be encapsulated into a function
	
	d = 5;
		
	T = diag(S);
	
	T = diag(T(1:d));

	B = U(:,1:d) * T * V(:,1:d)';
	
	for k = 1:D
		Y{k} = reshape(B(:,k),M,N);
	end
	
	h = fig; image_view(Y);
	
	set(h,'name',['SYNTHETIC IMAGES (K = ' int2str(d) ')']);
	
	%--
	% diplay synthesis filters
	%--
	
	% NOTE: this needs another display
	
	h = fig; strips(C);
	
	title('SYNTHESIS FILTERS');
	
	%--
	% display eigenvalues
	%--
	
	h = fig; semilogy(diag(S));
	
	title('SINGULAR VALUES');
	
end
