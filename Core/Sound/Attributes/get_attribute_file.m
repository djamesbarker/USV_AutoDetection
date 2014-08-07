function [file, exists] = get_attribute_file(context, name)

% get_attribute_file - get file for a sound and attribute type
% ------------------------------------------------------------
%
% [file, exists] = get_attribute_file(context, name)
%
% Input:
% ------
%  context - context
%  name - attribute name
%
% Output:
% -------
%  file - file
%  exists - indicator

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
% build canonical filename and ensure that attributes directory exists
%--
		
root = get_attributes_root(context);

%--
% ensure that root exists
%--

if ~exist_dir(root)
	
	result = mkdir(root);
	
	if ~result
		error('Can''t create attributes root directory.');
	end
	
end

file = fullfile(root, [name, attribute_file_ext]);

%--
% check file exists
%--

% NOTE: this should work properly for full filenames, 'exist' is a bit quirky

if nargout > 1
	exists = exist(file, 'file');
end
