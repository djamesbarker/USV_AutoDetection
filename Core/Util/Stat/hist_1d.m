function [h,c,v] = hist_1d(X,n,b,Z,fast)

% hist_1d - 1 dimensional histogram
% ---------------------------------
%
% [h,c,v] = hist_1d(X,n,b,Z)
%
% Input:
% ------
%  X - input image, image stack, or handle to parent figure
%  n - number of bins (def: 128)
%  b - bounds for values (def: min and max of X)
%  Z - computation mask (def: [])
%
% Output:
% -------
%  h - bin counts
%  c - bin centers
%  v - bin breaks

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
% $Date: 2005-12-15 13:52:40 -0500 (Thu, 15 Dec 2005) $
% $Revision: 2304 $
%--------------------------------

%--
% set fast
%--

if (nargin < 5)
	fast = 0;
end
	
%--
% image or handle
%--

if (fast)
	flag = 0;
else
	[X,N,tag,flag] = handle_input(X,inputname(1));
end

%--
% set mask
%--

if (nargin < 4)
	Z = [];
end

%--
% set bounds, handle image stacks and color images
%--

if ((nargin < 3) | isempty(b))

	%--
	% image stack
	%--
	
	if (iscell(X))
		
		for k = 1:length(X)
			b{k} = fast_min_max(X{k},Z);
		end
	
	%--
	% multiple plane image
	%--
	
	elseif (ndims(X) > 2)
		
		s = size(X,3);
		
		for k = 1:s
			b{k} = fast_min_max(X(:,:,k),Z);
		end
	
	%--
	% scalar image
	%--
	
	else
		
		b = fast_min_max(X,Z);
		
	end

end

%--
% set number of bins
%--

if ((nargin < 2) | isempty(n))
	n = 128;
end

%--
% handle image stacks and multiple plane images
%--

%--
% image stacks
%--

if (iscell(X))

	%--
	% compute histograms
	%--
	
	clear h;
	
	for k = 1:length(X)
		[h{k},c{k},v{k}] = hist_1d_(X{k},n,b{k},uint8(Z));	
	end

	%--
	% display output
	%--
	
	if (flag & view_output)
		fig;
		hist_1d_view(h,c,v,N);
	end
	
	return;
	
%--
% multiple plane images
%--

elseif (ndims(X) > 2)

	%--
	% compute histograms
	%--
	
	X = nd_to_stack(X);

	clear h;
	
	for k = 1:length(X)
		[h{k},c{k},v{k}] = hist_1d_(X{k},n,b{k},uint8(Z));	
	end
	
	%--
	% update variable names and display output
	%--
	
	for k = 1:length(X)
		tmp{k} = [N '(:,:,' num2str(k) ')'];
	end
	N = tmp;
	
	if (flag & view_output)
		fig;
		hist_1d_view(h,c,v,N);
	end
	
	return;
	
end

%--
% compute histogram using mex file
%--

[h,c,v] = hist_1d_(X,n,b,uint8(Z));	

%--
% display output
%--

if (flag & view_output)
	fig;
	hist_1d_view(h,c,v,N);
end
