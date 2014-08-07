function file = preset_file(ext, name, type)

% preset_file - get extension preset file name
% --------------------------------------------
%
% file = preset_file(ext, name, type)
%
% Input:
% ------
%  ext - extension
%  name - preset name
%  type - preset type
%
% Output:
% -------
%  file - preset file

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

if nargin < 3
	type = '';
end

if ~proper_filename(name)
	error('Preset name must be a proper filename.');
end

%--
% get preset directory and full filename
%--

root = preset_dir(ext, type);

file = [root, filesep, name, '.mat'];
