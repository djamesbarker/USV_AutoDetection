function out = toolbox_which(varargin)

% toolbox_which - which in toolboxes
% ----------------------------------
%
% NOTE: this is meant to return which results from the local toolboxes

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
% note get all which
%--

% NOTE: typically we want to get all versions of something, then select the toolbox one

try
	out = which(varargin{:}, '-all');
catch
	out = which(varargin{:});
end

%--
% filter results considering toolbox root
%--

out = out(strmatch(toolbox_root, out));
