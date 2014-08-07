function [value, tag] = valid_tag(tag, rep)

% valid_tag - check tag validity and enforce it
% ---------------------------------------------
%
% [value, tag] = valid_tag(tag, opt)
%
% Input:
% ------
%  tag - candidate tag
%  rep - space replacement (def: '-')
%
% Output:
% -------
%  value - tag validity test result
%  tag - derived valid tag

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

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% check for string input
%--

if ~ischar(tag)
	error('Tags are strings.');
end

%--
% set replace any spaces to get valid tag
%--

if any(isspace(tag))
	
	% NOTE: we set 'hyphen' as default space replacement

	if (nargin < 2)
		rep = '-';
	end
	
	value = 0; tag = strrep(strtrim(tag), ' ', rep); return;

else

	value = 1; % NOTE: string with no spaces, we have a tag
	 
end

