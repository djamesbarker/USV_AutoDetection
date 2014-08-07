function pal = get_splash

% get_splash - get splash figure handle
% -------------------------------------
%
% pal = get_splash
%
% Output:
% -------
%  pal - handle to splash

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
% get open waitbars
%--

pals = get_xbat_figs('type', 'waitbar'); pal = [];

if isempty(pals)
	return;
end

%--
% find one named as splash
%--

% NOTE: the tag should be more structured

info = parse_tag(get(pals, 'tag'), '::', {'type', 'name'});

for k = 1:length(info)
	
	if strcmpi(info(k).name, 'splash')
		pal = pals(k); return;
	end
	
end
