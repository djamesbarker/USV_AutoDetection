function [Y,N] = stack_images(varargin)

% stack_images - collect images into stack
% ----------------------------------------
%
% [Y,N] = stack_images(X1,...,Xn)
%       = stack_images(h)
%
% Input:
% ------
%  X1, ... , Xn - input images
%  h - vector of handles to parent figures or axes
%
% Output:
% -------
%  Y - stack of images
%  N - names for images in stack

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
% handle input
%--

if (nargin == 1)

	%--
	% get images from handles
	%--
	
	h = varargin{1};
	
	if (any(~ishandle(h)))
		error('Input must be set of images or handles.');
	end
		
	n = length(h);
	
	Y = cell(1,n);
	
	if (nargout > 1)
		N = cell(1,n);
	end
	
	for k = 1:n
	
		% get images
		
		Y{k} = get_image_data(h(k));
		
		% try to get names
		
		if (nargout > 1)
			
			switch (get(h(k),'type'))
			
				case ('axes')
				
					t = get_axes_title(h(k));
					if (~isempty(t))
						N{k} = t;
					else
						N{k} = ['Frame ' num2str(k)];
					end
					
				case ('figure')
				
					figure(h(k));
					
					t = title_edit;
					if (~isempty(t))
						N{k} = t;
					else
						t = get(h(k),'name');
						if (~isempty(t))
							N{k} = t;
						else
							N{k} = ['Frame ' num2str(k)];
						end
					end
					
			end
				
		end
		
	end
		
	%--
	% get and check sizes
	%--
		
	s = zeros(n,2);
	d = zeros(n,1);
	
	for k = 1:n
		s(k,:) = [size(Y{k},1), size(Y{k},2)];
		d(k) = ndims(Y{k});
	end
		
	if (any(diff(s,1,1)))
		error('Images in stack must be of the same size.');
	end
	
	if (any(d > 3))
		error('Input must consist of images.');
	end
	
	%--
	% set names for images in stack
	%--
	
	if (nargout > 1)
		for k = 1:n
			if (isempty(N{k}))		
				N{k} = ['Frame ' num2str(k)];	
			end
		end
	end
		
%--
% image input
%--

else

	%--
	% set output
	%--
	
	Y = varargin;
	
	%--
	% get and check sizes
	%--
	
	n = nargin;
	
	s = zeros(n,2);
	d = zeros(n,1);
	
	for k = 1:n
		s(k,:) = [size(Y{k},1), size(Y{k},2)];
		d(k) = ndims(Y{k});
	end
		
	if (any(diff(s,1,1)))
		error('Images in stack must be of the same size.');
	end
	
	if (any(d > 3))
		error('Input must consist of images.');
	end
	
	%--
	% set names for images in stack
	%--
	
	if (nargout > 1)
		for k = 1:n
			if (~isempty(inputname(k)))		
				N{k} = inputname(k);	
			else	
				N{k} = ['Frame ' num2str(k)];	
			end
		end
	end
	
end
