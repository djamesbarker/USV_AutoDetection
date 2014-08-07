function ext = get_able_extensions(in)

% get_able_extensions - get enabled extensions that compute
% ---------------------------------------------------------
%
% ext = get_able_extensions(type)
%
% Input:
% ------
%  type - extension type (def: '', get all extension types)
%  ext - extension array
%
% Output:
% -------
%  ext - able extensions

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
% $Revision: 1380 $
% $Date: 2005-07-27 18:37:56 -0400 (Wed, 27 Jul 2005) $
%--------------------------------

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set default to check all extensions
%--

if (nargin < 1)
	in = '';
end

%--
% get or rename extensions
%--

% NOTE: 'get_extensions' will check the extension type string

if isstr(in)
	ext = get_extensions(in);
else
	ext = in;
end

%--
% get developer level
%--

level = xbat_developer;

%--------------------------------------------
% SELECT ABLE EXTENSIONS
%--------------------------------------------

for k = length(ext):-1:1
	
	%--
	% remove disabled and non-computing extensions
	%--
	
	% NOTE: the non-computing test is deprecated
	
	if ~ext(k).enable || isempty(ext(k).fun.compute)
		ext(k) = [];
	end

	%--
	% remove base extensions if we are not developers
	%--
	
	% NOTE: base extensions have uppercase names by convention
	
	if (level < 1) && isequal(ext(k).name, upper(ext(k).name))
		ext(k) = [];
	end
	
end
