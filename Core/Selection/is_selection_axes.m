function [value, opt] = is_selection_axes(ax)

% is_selection_axes - test whether axes are selection axes
% --------------------------------------------------------
%
% [value, opt] = is_selection_axes(ax)
%
% Input:
% ------
%  ax - axes handles
%
% Output:
% -------
%  value - result of test
%  opt - axes selection options

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
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%----------------------
% HANDLE INPUT
%----------------------

%--
% handle multiple axes recursively
%--

if numel(ax) > 1
	
	% NOTE: we store options in cell to handle empty options
	
	value = zeros(size(ax)); opt = cell(size(ax));
	
	for k = 1:numel(ax)
		[value(k), opt{k}] = is_selection_axes(ax(k));
	end
	
	return;
	
end

%----------------------
% CHECK AXES
%----------------------

%--
% check selection axes condition
%--

callback = get(ax, 'buttondownfcn');

value = iscell(callback) && isequal(callback{1}, @selection_axes_callback);

%--
% output selection options
%--

if nargout > 1
	if value
		opt = callback{2};
	else
		opt = [];
	end
end
