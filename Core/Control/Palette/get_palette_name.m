function name = get_palette_name(pal)

% get_palette_name - get name of palette
% --------------------------------------
%
% name = get_palette_name(pal)
%
% Input:
% ------
%  pal - palette handle
%
% Output:
% -------
%  name - palette name

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
% $Revision: 4524 $
% $Date: 2006-04-12 17:08:03 -0400 (Wed, 12 Apr 2006) $
%--------------------------------

%--------------------------
% HANDLE INPUT
%--------------------------

if (~is_palette(pal))
	error('Input is not palette handle.');
end

%--------------------------
% GET NAME FROM TAG
%--------------------------

% NOTE: palette's are missing an alias, store the name is in the tag not the figure name

fields = {'type','subtype','name'};

info = parse_tag(get(pal,'tag'),'::',fields);

% NOTE: at the moment palette tags consist of two or three parts

if (isempty(info.name))
	info.name = info.subtype;
end

name = info.name;
