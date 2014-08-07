function [left,right] = set_browser_status_text(h,left,right)

% set_browser_status_text - get and set status text
% -------------------------------------------------
%
% [left,right] = set_browser_status_text(h,left,right)
%
% Input:
% ------
%  h - parent figure handle
%  left - left status text
%  right - right status text
%
% Output:
% -------
%  left - left status text
%  right - right status text
 
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
% $Revision: 1000 $
% $Date: 2005-05-03 19:36:26 -0400 (Tue, 03 May 2005) $
%--------------------------------

%--
% get object handles
%--

h_left = findobj(h,'tag','Status_Text_Left');

% NOTE: we only perform 'findobj' when needed, the empty handle skips other code

if ((nargin > 2) || (nargout > 1))
	h_right = findobj(h,'tag','Status_Text_Right');
else
	h_right = [];
end

%--
% set or get text if needed and possible
%--

% left status text

if (~isempty(h_left) && (nargin > 1) && ~isempty(left))
	
	set(h_left,'string',left);
	
elseif (~isempty(h_left) && (nargout))
		
	left = get(h_left,'string'); 
	
end

% right status text

if (~isempty(h_right) && (nargin > 2) && ~isempty(right))
	
	set(h_right,'string',right);
	
elseif (~isempty(h_right) && (nargout > 1))
		
	right = get(h_right,'string'); 
	
end
