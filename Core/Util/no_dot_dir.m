function content = no_dot_dir(root)

% no_dot_dir - get children directories that do not start with dot
% ----------------------------------------------------------------
%
% content = no_dot_dir(root)
%
% Input:
% ------
%  root - root
%
% Output:
% -------
%  child - children

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
% set current directory default
%--

if ~nargin
	root = pwd;
end

%--
% get children directories without dots
%--

content = dir(root);

for k = length(content):-1:1
    
	if content(k).isdir && (content(k).name(1) == '.' || content(k).name(1) == '_')
		content(k) = [];
	end
    
end
