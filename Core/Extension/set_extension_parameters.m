function ext = set_extension_parameters(ext, varargin)

% set_extension_parameters - set extension parameters
% ---------------------------------------------------
%
% ext = set_extension_parameters(ext, 'field', 'value')
%
% Input:
% ------
%  ext - the extension
%  varargin - a list of field, value pairs
%
% Output:
% -------
%  ext - the extension with modified parameters

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
% handle input
%--

if mod(numel(varargin), 2)
	error('field, value pairs only');
end

%--
% parse pairs
%--

[field, value] = get_field_value(varargin, fieldnames(ext.parameter));

%--
% convert to a struct and merge
%--

new_params = cell2struct(value, field, 2);

ext.parameter = struct_update(ext.parameter, new_params);

% NOTE: this is currently violating MVC since there is no 'M' (palette)

