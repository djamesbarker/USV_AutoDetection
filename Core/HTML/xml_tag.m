function tag = xml_tag(name, class, id, eol)

% xml_tag - create open and close tag strings
% -------------------------------------------
%
% tag = xml_tag(name, class, id, eol)
%
% Input:
% ------
%  name - tag name
%  class - tag class
%  id - tag id
%  eol - end of line to tag indicator
%
% Output:
% -------
%  tag - tag struct

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
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% set default end of line
%--

if (nargin < 4) || isempty(eol)
	eol = 1;
end

%--
% set and expand class and id strings
%--
	
% NOTE: we compute a tag state to help in open tag construction

state = 0;

if (nargin > 1) && ~isempty(class)
	class = ['class = "', class, '"']; state = state + 1;
end

if (nargin > 2) && ~isempty(id)
	id = ['id = "', id, '"']; state = state + 2;
end

%---------------------------
% CREATE STRINGS
%---------------------------

%--
% create open tag string
%--

% NOTE: the state approach does not scale to many attributes

switch state
	
	case 0, tag.open = ['<', name, '>'];
		
	case 1, tag.open = ['<', name, ' ', class, '>'];
		
	case 2, tag.open = ['<', name, ' ', id, '>']; 
		
	case 3, tag.open = ['<', name, ' ', class, ' ', id, '>'];
		
end

%--
% create close string
%--

tag.close = ['</', name, '>'];

%--
% add end of line if needed
%--

if eol
	tag.open = [tag.open, '\n']; tag.close = [tag.close, '\n'];
end
