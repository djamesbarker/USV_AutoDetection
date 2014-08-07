function [value, ext] = is_extension_palette(pal, opt)

% is_extension_palette - test whether palette belongs to extension
% ----------------------------------------------------------------
%
% [value, ext] = is_extension_palette(pal, opt)
%
% Input:
% ------
%  pal - palette handle
%  opt - palette options
%
% Output:
% -------
%  value - result of test
%  ext - palette extension

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

%-------------------
% HANDLE INPUT
%-------------------

%--
% check palette handle
%--

if ~is_palette(pal) 
	error('Input handle is not palette handle.');
end

%--
% get options from palete
%--

if nargin < 2
	data = get(pal, 'userdata'); opt = data.opt;
end

%-------------------
% SETUP
%-------------------

%--
% get extension type and name from palette
%--
	
% NOTE: extension is part of palette options

if isfield(opt, 'ext')
	
	type = opt.ext.subtype; name = opt.ext.name;

% NOTE: palette is named as extension and is uniquely named among all extensions

else
	
	% NOTE: this is deprecated and will be removed
	
	type = ''; name = get(pal, 'name');

end
	
%-------------------
% GET EXTENSION
%-------------------

%--
% get extension and create extension developer menus
%--

ext = get_extensions(type, 'name', name);

% NOTE: this has problems with multiple selected extensions

value = (length(ext) == 1);

if ~value
	ext = [];
end

%--
% ensure proper palette tag if possible
%--

% NOTE: we are dealing with more than 'palettes'

if ~isempty(ext)
	set(pal, 'tag', get_extension_tag(ext));
end
