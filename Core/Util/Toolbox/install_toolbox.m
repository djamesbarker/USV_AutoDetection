function value = install_toolbox(name, url)

% install_toolbox - download toolbox and add to path and patch
% ------------------------------------------------------------
%
% value = install_toolbox(name, url)
%
% Input:
% ------
%  name - tool name
%  url - download url
%
% Output:
% -------
%  value - success indicator

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

%--------------------
% HANDLE INPUT
%--------------------

%--
% get data if needed
%--

toolbox = get_toolbox_data(name); 

if nargin < 2
	
	try
		url = urlread(['http://xbat.org/downloads/info/', name, '.txt']);
	catch
		url = toolbox.url;
	end
	
end

%--------------------
% INSTALL TOOLBOX
%--------------------

%--
% download, unzip, and add to path
%--

try
	
	%--
	% get destination directory
	%--

	root = create_dir(toolbox_root(name));

	if isempty(root)
		error(['Failed to create toolbox root directory for ''', name, '''.']);
	end

	%--
	% download tool
	%--
	
	disp(['Downloading and installing ''', name, ''', this may take some time ...']);
	
	start = clock;
		
	file = fullfile(root, 'temp.zip');

	% NOTE: this provides download progress indicators

	curl_get(url, file, ['Downloading ''', name, '''']);

	while curl_wait(file)
		pause(0.25);
	end

	unzip(file, root); delete(file);
	
	%--
	% add to path
	%--
	
	% TODO: consider private directories and factor, also used in 'install_tool'
	
	append_path(root);
	 
	elapsed = etime(clock, start);
	
	% TODO: this must be moved after the install script runs
	
	disp(['Done. (', num2str(elapsed), ' sec)']);
	disp(' ');
	
	value = 1;
	
catch
	
	value = 0; nice_catch(lasterror, ['Failed to get ''', name, '''.']);
	
end

%--
% execute install script if available
%--

if ~isempty(toolbox) && isfield(toolbox, 'install') && ~isempty(toolbox.install)
	toolbox.install();
end


