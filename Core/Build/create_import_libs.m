function create_import_libs

%--
% get tools
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

nm = get_tool('nm.exe');

dlltool = get_tool('dlltool.exe');

%--
% process libraries to get 'def' files
%--

root = fullfile(matlabroot, 'bin', 'win32');

libs = {'libmat', 'libmex', 'libmx'};

for k = 1:length(libs)
	
	% NOTE: this is failing because the 'dll' files contain no symbols
	
	str = ['"', nm.file, '" -D "', root, filesep, libs{k}, '.dll"']; disp(str);
	
	[status, result] = system(str);
	
end 

%--
% build export libraries
%--
