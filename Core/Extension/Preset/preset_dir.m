function root = preset_dir(ext, type)

% preset_dir - compute presets directory for an extension
% -------------------------------------------------------
%
% root = preset_dir(ext, type)
%
% Input:
% ------
%  ext - extension
%  type - preset type
%
% Output:
% -------
%  root - presets directory

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

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% set and check preset type
%--

if (nargin < 2)
	type = '';
end

if ~ismember(type, get_preset_types(ext))
	error(['Unrecognized preset type ''', type, '''.']);
end

%---------------------------
% COMPUTE PRESET ROOT
%---------------------------

%--
% get root presets directory
%--

% NOTE: get type based parameter create function handle

if isempty(type)
	create = ext.fun.parameter.create;
else
	create = ext.fun.(type).parameter.create;
end

% NOTE: preset root is based on create function or main function

if ~isempty(create)
	fun = functions(create); root = [path_parts(path_parts(fun.file)), filesep, 'Presets'];
else
	fun = functions(ext.fun.main); root = [path_parts(fun.file), filesep, 'Presets'];
end

%--
% append type to root if needed
%--

% NOTE: this leads to special presets being contained in a specially named directory

if ~isempty(type)
	root = [root, filesep, '__', upper(type)];
end

%--
% make sure presets directory exists
%--

root = create_dir(root);

if isempty(root)
	error(['Failed to create preset directory for extension ''', ext.name, '''.']);
end

