function out = find_path(pat,type)

% find_path - find a path element matching a pattern
% --------------------------------------------------
%
% out = find_path(pat,type)
%
% Input:
% ------
%  pat - pattern to find
%  type - type of matching (def: 'strcmpi')
%
% Output:
% -------
%  out - path elements that match

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
% $Revision: 3934 $
% $Date: 2006-02-26 18:24:50 -0500 (Sun, 26 Feb 2006) $
%--------------------------------

%----------------------
% HANDLE INPUT
%----------------------

%--
% set default match type
%--

if (nargin < 2)
	type = 'strcmpi';
end

%--
% check match type
%--

types = {'strcmp','strcmpi','regex'};

if (~ismember(type,types))
	error(['Unrecognized match type ''', type, '''.']);
end

%----------------------
% FIND PATH
%----------------------

%--
% get and parse path
%--

out = strread(path,'%s',-1,'delimiter',';');

%--
% consider type in computing match
%--

% NOTE: it seems like this would be a useful function, like 'filter_strings'

switch (type)
	
	case ({'strcmp','strcmpi'})

		% NOTE: be case insensitive if needed
		
		if (type(end) == 'i')
			in = lower(out); pat = lower(pat);
		else
			in = out;
		end
		
		ix = find(~cellfun(@isempty,strfind(in,pat)));

	case ('regex')
		
		error('Regular expression matching not implemented yet.');
		
end
		
%--
% output path elements
%--

if (isempty(ix))
	out = cell(0); return;
end

out = out(ix);

