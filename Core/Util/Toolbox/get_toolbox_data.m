function [toolbox, file] = get_toolbox_data(name)

% get_toolbox_data - get toolbox data from file
% ---------------------------------------------
% 
% toolbox = get_toolbox_data(name)
%
% Input:
% ------
%  name - toolbox name
%
% Output:
% -------
%  toolbox - toolbox data struct

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
% get file and root
%--

[file, root] = toolbox_data_file(name); 

[ignore, name, ignore] = fileparts(file); %#ok<NASGU>

%--
% get toolbox data from file
%-

if exist(file, 'file')
	
	d1 = pwd; cd(root); 
	
	try
		toolbox = feval(name);
	catch
		toolbox = struct; nice_catch(lasterror, 'WARNING: Failed to get toolbox data.');
	end
	
	cd(d1);
	
else
	
	toolbox = struct;
	
end

