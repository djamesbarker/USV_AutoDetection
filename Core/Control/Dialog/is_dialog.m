function [value,name] = is_dialog(h)

% is_dialog - determine whether figure is dialog
% ----------------------------------------------
%
% [value,name] = is_dialog(h)
%
% Input:
% ------
%  h - figure handle
%
% Output:
% -------
%  value - result of dialog test
%  name - name of dialog figure

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
% $Revision: 550 $
% $Date: 2005-02-17 23:49:03 -0500 (Thu, 17 Feb 2005) $
%--------------------------------

%--
% test for dialog
%--

% NOTE: this function assumes a convention of using 'DIALOG' in tag

value = ~isempty(findstr(get(h,'tag'),'DIALOG'));

%--
% return name for convenience
%--

if (nargout > 1)
	name = get(h,'name');
end
