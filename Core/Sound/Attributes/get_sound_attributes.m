function attr = get_sound_attributes(context)

%--
% create empty attribute
%--

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

attr.name = ''; attr.value = struct; attr = empty(attr);

%--
% get known attribute filenames
%--

ext = get_extensions('sound_attribute');

if isempty(ext);
	return;
end

files = strcat({ext.name}, attribute_file_ext);

%--
% scan attributes root for attribute files
%--

root = get_attributes_root(context);

contents = dir(root);

if isempty(contents)
	return;
end

for k = 1:length(contents)
	
	%--
	% skip unrecognized files
	%--
	
	ix = find(strcmp(contents(k).name, files));
	
	if isempty(ix)
		continue;
	end
	
	%--
	% add attribute to array
	%--
	
	attr(end + 1).name = ext(ix).name;
	
	file = get_attribute_file(context, ext(ix).name);
	
	attr(end).value = []; 

	try
		attr(end).value = ext(ix).fun.load(file, context);
	catch
		extension_warning(ext(ix), 'Load failed.', lasterror);
	end
	
end
