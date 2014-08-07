function root = extensions_root(type)

% extensions_root - extensions root directory
% ------------------------------------------
%
% root = extensions_root(type)
%
% Input:
% ------
%  type - extension type (def: '', get root of all extensions)
% 
% Output:
% -------
%  root - root directory for extensions

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

% TODO: develop 'set' and 'get', and allow multiple roots

%--
% all extensions root
%--

root = [xbat_root, filesep, 'Extensions'];

%--
% specific extension type root
%--

if nargin
	
	if ~ischar(type) || ~is_extension_type(type)
		error('Unrecognized extension type.');
	end
	
	root = [root, filesep, type_to_dir(type)];
	
end

