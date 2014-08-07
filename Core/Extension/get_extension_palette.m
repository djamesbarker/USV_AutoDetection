function pal = get_extension_palette(ext, par)

% get_extension_palette - get extension palette of parent
% -------------------------------------------------------
% 
% pal = get_extension_palette(ext, par)
%
% Input:
% ------
%  ext - extension
%  par - parent (def: active browser)
%
% Output:
% -------
%  pal - palette handle

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
% initialize for convenience
%--

pal = [];

%--
% get parent
%--

% NOTE: we try to get the parent from the context input

if (nargin < 2) || isempty(par)
	par = get_active_browser;
end

% NOTE: return if we have no parent

if isempty(par)
	return;
end

%--
% try to get extension palette
%--

pals = get_xbat_figs('type', 'palette', 'parent', par);

if isempty(pals)
	return;
end

pal = findobj(pals, 'tag', get_extension_tag(ext));
