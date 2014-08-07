function tools = miktex_tools(pat, types)

% miktex_tools - get miktex tools
% -------------------------------
%
% tools = miktex_tools(pat, types)
%
% Input:
% ------
%  pat - name pattern
%  types - tool types
%
% Output:
% -------
%  tools - tools

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

%--------------
% SETUP
%--------------

%--
% get miktex tool source directory
%--

source = miktex_root;

if isempty(source)
	tools = []; return;
end

hint = miktex_root('doc');

%--------------
% HANDLE INPUT
%--------------

%--
% set types
%--

if nargin < 2
	types = get_tool_types;
end

%--
% set name pattern
%--

if nargin < 1
	pat = '';
end

% NOTE: consider specific tool name input, this will ignore types input

if ~isempty(pat) && ~any(pat == '*')
	
	[p1, p2, p3] = fileparts(pat);
	
	if ~isempty(p3)
		pat = p2; types = p3;
	end

end

%--------------
% GET TOOLS
%--------------

tools = get_tools(source, pat, types, hint);
