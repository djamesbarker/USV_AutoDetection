function package_xbat(location, destination)

% package_xbat - export and clean up the xbat working copy for distribution
% -------------------------------------------------------------------------
%
% package_xbat(location, revision, destination)
%
% Input:
% ------
%  location - working copy or URL (def: xbat_root)
%  revision - revision number (def: HEAD)
%  destination - where to put the package (def: xbat_root/Package)
%  platform - the platform to package for

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

if nargin < 2 || isempty(destination)
    destination = fullfile(xbat_root, '../xbat_package');
end

if ~nargin || isempty(location)
    location = xbat_root;
end

%--
% clean up current destination directory
%--

if exist(destination, 'dir') == 7
	
	disp('Cleaning up existing package.');
	
	rmdir(destination, 's');
	
end

%--
% export
%--

str = ['"', location, '"', ' "', destination, '"'];

disp('Exporting SVN tree.  This may take some time ...');

[status, result] = svn('export', str);

disp(result);

if status
	return;
end

%--
% get externals
%--

[status, result] = svn('propget', 'svn:externals'); 

for k = 1:size(result, 1)
    
    name = strtok(result(k, :), ' ');
    
    str = ['"', fullfile(location, name), '" "', fullfile(destination, name), '"'];

    disp(['Exporting External tree ''', name, '''. This too may take some time ...']);
    
    [status, result] = svn('export', str);
    
    if status
        disp(result);
    end
    
end

%-------------------------
% CLEAN UP
%-------------------------

disp('Cleaning up.');

%--
% remove not-needed root-level directories
%--

not_needed = { ...
    'Sites' ...
};

for k = 1:length(not_needed) 
    rmdir(fullfile(destination, not_needed{k}), 's');
end

%--
% remove mex-files from core functions
%--

scan_dir(fullfile(destination, 'Core'), @delete_mex); 

disp('Packaging complete.');

% TODO: copy in MEX-files appropriate to platform


%------------------------
% DELETE_MEX
%------------------------

function out = delete_mex(p)

out = [];

ext = {'mexw32', 'mexglx', 'mexmac', 'dll'};

for k = 1:length(ext)
	delete(fullfile(p, '*.', ext{k}));
end



