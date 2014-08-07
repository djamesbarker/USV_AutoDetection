function root = xbat_root

% xbat_root - get XBAT root directory
% -----------------------------------
%
% root = xbat_root
%
% Output:
% -------
%  root - XBAT root directory

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6472 $
% $Date: 2006-09-11 18:11:43 -0400 (Mon, 11 Sep 2006) $
%--------------------------------

%--
% try to get environment variable
%--

root = get_env('xbat_root');

%--
% set environment variable if needed
%--

if isempty(root)

	%--
	% get root by parsing path for this file
	%--
	
	% NOTE: the logical root may change as directory organization changes
	
	root = mfilename('fullpath'); 
	
	ix = findstr(root, filesep); 
	
	root = root(1:ix(end - 1) - 1);

	%--
	% set environment variable
	%--
	
	set_env('xbat_root', root);
	
end
