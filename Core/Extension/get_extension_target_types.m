function target_types = get_extension_target_types(types)

% get_extension_target_types - get target objects of extensions
% -------------------------------------------------------------
%
% target_types = get_extension_target_types(types)
%
% Input:
% ------
%  types - list of extension types (def: all extension types)
%
% Output:
% -------
%  target_types - list of target types

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

%------------------------------
% HANDLE INPUT
%------------------------------

%--
% set all available extension types default
%--

if nargin < 1
	types = get_extension_types;
else
	if ~iscellstr(types)
		error('Extension type input must be cell array of strings.');
	end
end

%------------------------------
% GET TARGET TYPES
%------------------------------

target_types = unique(strtok(types, '_'));

% NOTE: consider the one part type 'detector', note the transpose

target_types = setdiff(target_types, 'detector')';
