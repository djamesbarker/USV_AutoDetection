function [fun,S,T] = colormap_to_fun(str)

% colormap_to_fun - get function for named colormap
% -------------------------------------------------
%
% [fun,S,T] = colormap_to_fun(str)
%
% Input:
% ------
%  str - colormap name
%
% Output:
% -------
%  fun - function name or list of available colormaps
%  S - menu separators
%  T - tooltip strings

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
% $Revision: 5169 $
% $Date: 2006-06-06 17:29:13 -0400 (Tue, 06 Jun 2006) $
%--------------------------------

%--
% create colormap function table
%--

% FIXME: there should be no space in 'Gray'

T = { ...
	'Gray ', 'gray'; ...
	'Bone', 'bone'; ...
	'Copper','copper'; ...
	'Pink','pink'; ...
	'Hot', 'hot'; ...
	'Sunset','cmap_pseudo'; ...
	'HSV', 'hsv'; ...
	'Jet', 'jet'; ...
	'Label', 'cmap_label'; ...
};
		

%--
% look up function name
%--

if (nargin)
	
	ix = find(strcmpi(str,T(:,1)));
	
	if (~isempty(ix))
		fun = T{ix,2};
	else
		fun = [];
	end

%--
% output available colormaps
%--

else
	
	fun = T(:,1);
	
	%--
	% output menu separators
	%--
	
	if (nargout > 1)
		
		n = length(fun);
		S = bin2str(zeros(1,n));
		S{2} = 'on';
		S{5} = 'on';
		
	end
	
	%--
	% output tooltips
	%--
	
	if (nargout > 2)
		
		T = cell(1,n); 
		for k = 1:n
			T{k} = '';
		end
		
		T = { ...
			'Linear gray-scale colormap (Shift + G)'; ...
			'Gray-scale with a tinge of blue colormap (Shift + B)'; ...
			'Linear copper-tone colormap'; ...
			'Pastel shades of pink colormap'; ...
			'Black-red-yellow-white colormap (Shift + H)'; ...
			'Hue-saturation-value colormap'; ...
			'Variant of HSV colormap (Shift + J)'; ...
			'Permuted HSV colormap'; ...
		};
	
	end
			
end

