function [value,ix] = get_browser_history(par,field,opt)

% get_browser_history - get where this browser has been
% -----------------------------------------------------
%
% value = get_browser_history(par,field,opt)
%
% Input:
% ------
%  par - browser handle
%  field - field of history
%  opt - access option, 'last' or 'all' (def: 'last')
%
% Output:
% -------
%  value - history value

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
% $Revision: 4580 $
% $Date: 2006-04-14 17:24:52 -0400 (Fri, 14 Apr 2006) $
%--------------------------------

%-------------------------
% SETUP
%-------------------------

global BROWSER_HISTORY;

% NOTE: return empty when there is no history, regardless of input

if (isempty(BROWSER_HISTORY))
	value = []; ix = []; return;
end

%-------------------------
% HANDLE INPUT
%-------------------------

if (nargin < 3)
	opt = 'last'; 
end

opts = {'last','all'};

if (~ismember(opt,opts))
	error('Unrecognized history access mode.');
end

%-------------------------
% COMPUTE BASED ON INPUT
%-------------------------

%--
% get all history
%--

if (nargin < 1)
	value = BROWSER_HISTORY; ix = []; return;
end

%--
% select browser history
%--

% TODO: add check on tag to determine whether history is stale

ix = find([BROWSER_HISTORY.par] == par);
	
if (isempty(ix))
	value = []; ix = []; return;
end

points = BROWSER_HISTORY(ix).history;

%--
% get browser history
%--

if (nargin < 2)

	switch (opt)
		
		case ('last')
			value = buffer_current(points);
			
		case ('all')
			error('History get mode ''all'' not implemented.');
			
	end
	
	return;

end

%--
% get browser history field
%--

if (~ismember(field,get_history_fields('get')))
	error(['Unrecognized history field ''', field, '''.']);
end

switch (opt)
	
	case ('last')
		value = buffer_current(points); value = value.(field);
		
	case ('all')
		error('History get mode ''all'' not implemented.');

end




