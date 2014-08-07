function preset = preset_create(ext, varargin)

% preset_create - create preset structure
% ---------------------------------------
% 
% preset = preset_create(ext, 'field', value, ...)
%
% Input:
% ------
%  ext - extension to create preset for
%  field - preset field name
%  value - preset field value
%
% Output:
% -------
%  preset - preset structure

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

% TODO: this does not seem to be the right signature

%--------------------------------
% CREATE PRESET
%--------------------------------

%--
% PRIMITIVE
%--

% NOTE: this is a volatile field, we set it on load

preset.name = '';

% NOTE: this is the content of the preset

preset.ext = [];

if nargin
	preset.ext = ext;
end

% NOTE: tags and notes support simple annotation

preset.tags = {};

preset.notes = {};

%--
% CONTEXT
%--

preset.context = [];

% TODO: consider adding this to context!

preset.active = []; % active extensions

%--
% ADMINISTRATIVE
%--

preset.author = '';

preset.created = now;

preset.modified = [];

preset.userdata = [];

%--------------------------------
% SET PROVIDED FIELDS
%--------------------------------

if length(varargin)
	preset = parse_inputs(preset, varargin{:});
end


