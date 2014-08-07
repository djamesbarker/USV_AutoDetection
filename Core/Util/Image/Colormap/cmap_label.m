function C = cmap_label(n)

% cmap_label - colormap for label images
% --------------------------------------
%
% C = cmap_label(n)
%
% Input:
% ------
%  n - number of levels
%
% Output:
% -------
%  C - colormap

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
% $Date: 2004-12-21 19:10:44 -0500 (Tue, 21 Dec 2004) $
% $Revision: 335 $
%--------------------------------

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% get number of levels from image
%--

if ~nargin
		
	par = gcf; 
	
	%--
	% get image
	%--
	
	handles = findobj(par, 'type', 'image');

	for k = length(handles):-1:1
		
		if strcmp(get(handles(k), 'tag'), 'TMW_COLORBAR')
			handles(k) = [];
		end
		
	end
	
	if isempty(handles)
		error('Current figure does not contain images.');
	end

	%--
	% get extreme values of image data
	%--
	
	for k = 1:length(handles)
		b(k,:) = fast_min_max(get(handles(k),'CData'));
	end

	b = [min(b(:,1)), max(b(:,2))];
	
	%--
	% set number of levels
	%--
	
	if (b(1) < 0)
		n = 256;
	else
		n = b(2); n = floor(n / 2);
	end
	
end

%--
% set colormap of current figure
%--

if ~nargout
	colormap(cmap_label(n));
end

%----------------------------
% CREATE COLORMAP
%----------------------------

% NOTE: maybe use seed input to function to produce consistent results

p = randperm(n);

C = hsv(n);

% NOTE: we add zero for the background to the colormap

C = [0 0 0; C(p,:)];


