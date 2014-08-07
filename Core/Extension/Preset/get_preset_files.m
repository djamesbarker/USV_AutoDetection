function [files, root] = get_preset_files(ext, type)

% get_preset_files - get preset files and root
% --------------------------------------------
%
% [files, root] = get_preset_files(ext, type)
%
% Input:
% ------
%  ext - extension
%  type - preset type
%
% Output:
% -------
%  files - preset filenames
%  root - presets root

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

if nargin < 2
	type = '';
end

%--
% get preset directory
%--

root = preset_dir(ext, type);

if isempty(root)
	files = cell(0); return;
end

%--
% get preset files
%--

files = get_field(what_ext(root, 'mat'), 'mat');
	
if isempty(files)
	return;
end

files = sort(files);
