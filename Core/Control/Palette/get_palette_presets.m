function [presets,f] = get_palette_presets(varargin)

% get_palette_presets
% -------------------
%
% presets = get_palette_presets
%
% Output:
% -------
%  presets - palette presets array
%  N - number of valid presets (mostly used when equal to zero)

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
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

%--
% set (possibly create) palette preset directory
%--

par = [xbat_root, filesep, 'Presets'];

p = [par, filesep, 'Palettes'];

if (~exist(p,'dir'))
	mkdir(par, 'Palettes');
end

%--
% load presets from matfiles in directory
%--

f = what_ext(p,'mat'); 

f = f.mat(:);

% NOTE: return if there are no preset files

if (~length(f))
	presets = []; return;
end
	
j = 0;

for k = length(f):-1:1
	
	% NOTE: failure does not increment counter and removes file from list
	
	try
		tmp = load([p, filesep, f{k}],'state');
	catch
		f(k) = [];
		continue;
	end
		
	j = j + 1;
	presets(j) = tmp.state;
	
end

presets = flipud(presets(:));
