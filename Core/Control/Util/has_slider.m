function value = has_slider(handles)

% has_slider - test handles array for sliders
% -------------------------------------------
%
% value = has_slider(handles)
%
% Input:
% ------
%  handles - handles array
%
% Output:
% -------
%  value - result of test

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
% $Revision: 1482 $
% $Date: 2005-08-08 16:39:37 -0400 (Mon, 08 Aug 2005) $
%--------------------------------

% TODO: generalize this function to test other styles and perhaps types

%--
% check for handles array
%--

if (any(~ishandle(handles)))
	error('Input array is not a handles array.');
end

%--
% select controls
%--

handles = handles(strcmp('uicontrol',get(handles,'type')));

% NOTE: there are no controls, hence no sliders 

if (isempty(handles))
	value = 0;
end

%--
% find slider
%--

styles = get(handles,'style');

% NOTE: string must be put in cell for 'ismember' to work properly

if (ischar(styles))
	styles = {styles};
end

if (~ismember('slider',styles))
	value = 0; return;
end 

value = 1;
