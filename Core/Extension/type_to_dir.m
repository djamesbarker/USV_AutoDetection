function dir = type_to_dir(type, skip)

% type_to_dir - extension type string to directory string
% -------------------------------------------------------
% 
% dir = type_to_dir(type, skip)
%
% Input:
% ------
%  type - extension type string
%  skip - skip available types check
%
% Output:
% -------
%  dir - partial directory string

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
% $Revision: 6304 $
% $Date: 2006-08-23 17:24:55 -0400 (Wed, 23 Aug 2006) $
%--------------------------------

%--
% set default no skip
%--

if (nargin < 2) || isempty(skip)
	skip = 0; 
end

% NOTE: directory organization inverts general and specific in name

%--
% normalize, check, and pluralize type
%--

type = type_norm(type, skip);

if isempty(type)
	error('Unrecognized extension type.');
end

type = [type, 's'];

%--
% parse types to get root directory for type
%--

% NOTE: split on underscore, reverse, and capitalize words

tok = strread(type, '%s', 'delimiter', '_');

dir = '';

for k = length(tok):-1:1
	tok{k}(1) = upper(tok{k}(1)); dir = [dir, filesep, tok{k}];
end

dir = dir(2:end);
