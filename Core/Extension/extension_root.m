function root = extension_root(ext, type)

% extension_root - root directory of extension
% --------------------------------------------
%
% root = extension_root(ext, type)
%
% Input:
% ------
%  ext - extension
%
% Output:
% -------
%  root - extension root

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

% TODO: extend to consider when we may have more than one extension root

%--
% get base extension root
%--

root = [extensions_root(ext.subtype), filesep, ext.name];

if (nargin < 2) || isempty(type)
	return;
end

%--
% append type 
%--

if ~ismember(type, get_extension_directories)
	error(['Unrecognized extension root directory type ''', type, '''.']);
end

if strcmp(type, 'base')
	return;
end

root = [root, filesep, type];
