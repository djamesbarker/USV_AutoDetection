function [root, exists] = toolbox_root(name, local, simple)

% toolbox_root - get root directory of toolboxes or named toolbox
% ---------------------------------------------------------------
%
% [root, exists] = toolbox_root(name, local, simple)
%
% Input:
% ------
%  name - toolbox name
%  local - local toolbox indicator
%  simple - top root
%
% Output:
% -------
%  root - computed root directory
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
% set default simple
%--

if nargin < 3
	simple = 1;
end

%--
% set default local
%--

% NOTE: local means within the XBAT root directory structure

if (nargin < 2) || isempty(local)
	local = 1;
end

%--
% build all toolboxes root
%--

if local
	root = fullfile(xbat_root, 'Toolboxes');
else
	root = fullfile(matlabroot, 'toolbox');
end

if ~nargin || isempty(name)

	if nargout > 1
		exists = exist_dir(root); 
	end

	return;

end

%--
% build named toolbox root
%--

if ~ischar(name)
	error('Toolbox name must be string.');
end

root = fullfile(root, name);

if (nargout > 1) || ~simple
	exists = exist_dir(root);
end

%--
% try to get closest root
%--

if ~simple
	
	content = no_dot_dir(root);
	
	while (length(content) == 1) && content.isdir
		
		root = fullfile(root, content.name); content = no_dot_dir(root);
	
	end
	
end


