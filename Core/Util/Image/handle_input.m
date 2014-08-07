function [X,N,tag,flag,g,h] = handle_input(X,N)

% handle_input - handle image or handle input situation
% -----------------------------------------------------
%
% [X,N,tag,flag,g,h] = handle_input(X,N)
%
% Input:
% ------
%  X - input image, image stack, or handle to parent figure
%  N - name of image or stack (def: 'X')
%
% Output:
% -------
%  X - image or image stack data
%  N - name of image or stack
%  tag - image tag
%  flag - handle input indicator
%  g - image handle
%  h - figure handle

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
% handle input
%--
	
% the handle check can be very costly

if (length(X) == 1)
% if (ishandle(X))
	
	%--
	% set handle input flag
	%--
	
	flag = 1;
	
	%--
	% set figure handles and get image handles
	%--
	
	h = X;
    [g,tag] = get_image_handles(h);
	
	%--
	% check for single image display in figure
	%--
	
    if (length(g) == 1)
		
		%--
		% get image stack from figure
		%--
		
		if strcmp(tag,'IMAGE_STACK')
			
			%--
			% get image stack and plane names from image userdata
			%--
			
			X = getfield(get(g,'userdata'),'X');
			N = getfield(get(g,'userdata'),'N');
			
			%--
			% check for scalar image stack using image tag
			%--
			
			t = image_tag(X{1});
			t = t(1:9);

			if (~strcmp(t,'IMAGE_GRA'))
				error('Only stacks of scalar images are supported.');
			end
			
		%--
		% get image from figure
		%--
		
		else
			
			%--
			% get image data from image and title from axes
			%--
			
        	X = get(g,'cdata');
			N = title_edit;
			
		end

	%--
	% multiple images in figure error
	%--
	
	else
		
		disp(' ');
        error(['Figure ' num2str(h) ' has more than one image.']);		
		
	end  

%--
% image or image stack input
%--

else
	
	%--
	% set handle input flag
	%--
	
	flag = 0;
	
	%--
	% set empty image and figure handles
	%--
	
	h = [];
	g = [];
	
	%--
	% tag and check provided image data
	%--
	
	tag = image_tag(X);
	
	if (strcmp(tag,'IMAGE_STACK'))
		
		%--
		% check for scalar image stack
		%--
		
		t = image_tag(X{1});
		t = t(1:9);
		
		if (~strcmp(t,'IMAGE_GRA'))
			error('Only stacks of scalar images are supported.');
		end
		
		%--
		% set names of planes
		%--
		
		if ((nargin < 2) | isempty(N))
			N = 'X';
% 			for k = 1:length(X)
% 				N{k} = ['Frame ' num2str(k)];
% 			end
		else
% 			tmp = N;
% 			clear N;
% 			for k = 1:length(X)
% 				N{k} = [tmp '(' num2str(k) ')'];
% 			end
		end

% 		if ((nargin < 2) | isempty(N))
% 			for k = 1:length(X)
% 				N{k} = ['Frame ' num2str(k)];
% 			end
% 		else
% 			tmp = N;
% 			clear N;
% 			for k = 1:length(X)
% 				N{k} = [tmp '(' num2str(k) ')'];
% 			end
% 		end
		
	else
		
		%--
		% set names
		%--
		
		if ((nargin < 2) | isempty(N))
			N = 'X';
		end

	end

end
