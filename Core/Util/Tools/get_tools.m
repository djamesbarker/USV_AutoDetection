function tools = get_tools(source, pat, types, scan)

% get_tools - get tools from directory
% ------------------------------------
%
% tools = get_tools(source, pat, types, scan)
%
% Input:
% ------
%  source - directory
%  pat - name pattern
%  types - tool types to consider
%  scan - scan for help indicator or hint
%
% Output:
% -------
%  tools - tools found

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

if ~exist_dir(source)
	tools = []; return;
end

if nargin < 4
	scan = 1;
end

if nargin < 3
	types = get_tool_types;
end

if nargin < 2
	pat = '';
end

%--
% get tools
%--

tools = [];

content = get_extension_content(source, types, pat);

for k = 1:length(content)
	
	%--
	% check for pattern match
	%--
	
	tool = get_tool(fullfile(source, content(k).name), scan);
	
	if ~isempty(tool)
		if isempty(tools)
			tools = tool;
		else 
			tools(end + 1) = tool;
		end
	end
	
end
