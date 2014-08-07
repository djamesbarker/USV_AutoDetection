function value = install_tool(name, url)

% install_tool - download tool and add to path
% --------------------------------------------
%
% value = install_tool(name, url)
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

%--
% set list of application we should get natively
%--

persistent BOOT;

if isempty(BOOT)
	BOOT = {'NirCmd', 'cURL'};
end

%--
% try to get url if needed
%--

if nargin < 2
	
	% NOTE: the expected failure here happens when the file does not exist
	
	try
		
		url = urlread(['http://xbat.org/downloads/info/', name, '.txt']);
		
	catch
		
		nice_catch( ...
			lasterror, ['''', name, ''' URL is not available, it must be provided as input.'] ...
		); 
	
		value = 0; return;
		
	end
	
end

%--
% install tool
%--

try
	
	%--
	% get destination directory
	%--

	root = create_dir(fullfile(tools_root, name));

	if isempty(root)
		error(['Failed to create root directory for ''', name, ''' tool.']);
	end

	%--
	% download tool
	%--
	
	% TODO: inspect 'url' in case 'unzip' is not the required action!
	
	disp(['Downloading and installing ''', name, ''', this may take some time ...']);
	
	start = clock;
	
	file = fullfile(root, 'temp.zip');
	
	if ismember(name, BOOT)
		
		urlwrite(url, file);
		
	else

		% NOTE: this provides download progress indicators

		curl_get(url, file, ['Downloading ''', name, '''']);

		while curl_wait(file)
			pause(0.25);
		end
		
	end
	
	unzip(file, root); delete(file);
	
	%--
	% add to path
	%--
	
	append_path(root);
	 
	elapsed = etime(clock, start);
	
	disp(['Done. (', num2str(elapsed), ' sec)']);
	disp(' ');
	
	value = 1;
	
catch
	
	value = 0; nice_catch(lasterror, ['Failed to get ''', name, '''.']);
	
end


