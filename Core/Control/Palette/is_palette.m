function [value, name] = is_palette(pal)

% is_palette - determine whether figure is palette
% ------------------------------------------------
%
% [value, name] = is_palette(pal)
%
% Input:
% ------
%  pal - figure handle
%
% Output:
% -------
%  value - result of palette test
%  name - name of palette figure

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
% check for figure handles
%--

if ~is_handles(pal, 'figure')
	error('Input must be figure handles.');
end

%--
% test for palette tag
%--

% NOTE: uses convention of using 'DIALOG, 'PALETTE', 'WAITBAR', or 'WIDGET' in tag

tag = {'DIALOG', 'PALETTE', 'WAITBAR', 'WIDGET'}; value = 0;

for k = 1:length(tag)
	
	if ~isempty(findstr(get(pal, 'tag'), tag{k}))
		value = 1; break;
	end
	
end

%--
% return name for convenience
%--

if nargout > 1
	name = get(pal, 'name');
end
