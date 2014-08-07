function h = rle_hist(X,r,d,T)

% rle_hist - distribution of run-lengths in binary image
% ------------------------------------------------------
%
% h = rle_hist(X,r,d,T)
%
% Input:
% ------
%  X - input binary image
%  r - maximum run length to consider (def: 50)
%  d - dimension to scan (def: [], scan in both directions)
%  T - binarization threshold (def: [], assume binary image input)
%
% Output:
% -------
%  h - run-length histogram

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--
% set binarization threshold
%--

if (nargin < 4)
	T = [];
end

%--
% set scan dimension
%--

if (nargin < 3)
	d = [];
end

%--
% set maximum run-length
%--

if ((nargin < 2) | isempty(r))
	r = 50;
end 

%--
% make sure input image is double
%--

% NOTE: this should not be needed when the mex can handle needed types

if (~strcmp(class(X),'double'))
	X = double(X);
end

%--
% compute run-length distribution
%--

if (isempty(d))
	
	%--
	% compute run-length code in both directions
	%--

	if (isempty(T))
		R1 = rle_encode(X); R2 = rle_encode(X');
	else
		R1 = rle_encode(X,T); R2 = rle_encode(X',T);
	end
	
	% discard size and initial state, and concatenate

	R = [R1(4:end), R2(4:end)];
	
else
	
	%--
	% compute run-length code along specified direction
	%--
	
	switch (d)

		case (1)
			if (isempty(T))
				R = rle_encode(X);
			else
				R = rle_encode(X,T);
			end
		
		case (2)
			if (isempty(T))
				R = rle_encode(X');
			else
				R = rle_encode(X',T);
			end
					
		otherwise
			disp(' ');
			error('Dimension must be 1 or 2.');
			
	end
	
	% discard size and initial state
	
	R = R(4:end);
	
end

%--
% select run-lengths below maximum length
%--

R = R(R < r);

%--
% compute run-length histogram
%--

% NOTE: the last argument makes the computation skip steps for speed

h = hist_1d(R,r,[1,r],[],1);
	
