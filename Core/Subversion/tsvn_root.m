function root = tsvn_root

% tsvn_root - get 'TortoiseSVN' install root
% ------------------------------------------
%
% root = tsvn_root
%
% Output:
% -------
%  root - 'TortoiseSVN' install path
%
% NOTE: edit this file if 'TortoiseSVN' is installed and this returns empty

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
% set tentative TortoiseSVN install root
%--

% NOTE: this is the default location on english language windows systems

root = 'C:\Program Files\TortoiseSVN';

% root = '';

%--
% test that the directory exist, otherwise return empty
%--

if isempty(root) || ~exist_dir(root)
	root = '';
end
