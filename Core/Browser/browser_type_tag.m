function out = browser_type_tag(in,type)

% browser_type_tag - convert tags to types and types to tags
% ----------------------------------------------------------
%
% out = browser_type_tag(in,type)
%
% Input:
% ------
%  in - browser tag or type
%  type - output type 'tag' or 'type'
%
% Output:
% -------
%  out - browser type or tag

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

%--------------------------------
% HANDLE INPUT AND SETUP
%--------------------------------

%--
% set default output to alternate
%--

if ((nargin < 2) || isempty(type))
	type = [];
else
	if (isempty(find(strcmp(type,{'type','tag'}))))
		error('Output type must be ''type'' or ''tag''.');
	end
end

%--
% check for string input
%--

if (~ischar(in))
	error('String input is required.');
end

%--
% get available types and corresponsing tags
%--

types = get_browser_types;

persistent PERSISTENT_BROWSER_TAGS;

if (isempty(PERSISTENT_BROWSER_TAGS))
	PERSISTENT_BROWSER_TAGS = upper(strcat('XBAT_',types,'_BROWSER'));
end

%--------------------------------
% OUTPUT DESIRED STRING
%--------------------------------

out = [];

%--
% check for type string
%--

% TODO: check length and prefix for efficiency

ix = find(strcmp(in,types));

if (~isempty(ix))
	
	if (isequal(in,'type'))
		out = in;
	else
		out = PERSISTENT_BROWSER_TAGS{ix};		
	end
	
	return;
	
end

%--
% check for tag string
%--

ix = find(strcmp(in,PERSISTENT_BROWSER_TAGS));


if (~isempty(ix))

	if (isequal(in,'tag'))
		out = in;
	else
		out = types{ix};
	end

	return;

end
	
	
end
