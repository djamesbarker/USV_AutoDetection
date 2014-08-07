function update_parent_display(pal)

% update_parent_display - update parent display on filter state change
% --------------------------------------------------------------------
%
% par = update_parent_display(pal)
%
% Input:
% ------
%  pal - filter extension palette
%
% Output:
% -------
%  par - updated parent

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
% $Revision: 1474 $
% $Date: 2005-08-05 20:29:15 -0400 (Fri, 05 Aug 2005) $
%--------------------------------

% TODO: update this to include active detection update

% NOTE: previously this was achieved with the 'Scrollbar' callback

%--
% set default palette handle
%--

% NOTE: since this is usually called after updating a palette control it makes sense

if (nargin < 1)
	pal = gcf;
end

%--
% check for parent
%--

par = get_xbat_figs('child',pal);

if (isempty(par))
	return;
end

%--
% get parent userdata
%--

data = get(par,'userdata');

%--
% get relevant filter state information
%--

% NOTE: get palette filter from name

filter_name = get(pal,'name'); 

% NOTE: get active filters from parent

signal_filter = data.browser.signal_filter.active;

image_filter = data.browser.image_filter.active;

%--
% update parent if needed
%--

if (strcmp(signal_filter,filter_name) || strcmp(image_filter,filter_name))
		
	% NOTE: this does not clear the browser selection
	
	browser_display(par,'update',data);

end

