function [control, ix] = get_control_by_name(pal, name, controls)

% get_control_by_name - get control by name
% -----------------------------------------
%
% [control, ix] = get_control_by_name(pal, name, controls)
%
% Input:
% ------
%  pal - palette handle
%  name - control name
%  controls - palette controls
%
% Output:
% -------
%  control - control
%  ix - index

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
% $Revision: 3408 $
% $Date: 2006-02-06 15:40:18 -0500 (Mon, 06 Feb 2006) $
%--------------------------------

% TODO: consider check for non-unique control names

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% get palette controls if needed
%--

% NOTE: palette input is required if we omit controls input

if nargin < 3
	controls = get_palette_controls(pal);
end

%----------------------------
% FIND CONTROL
%----------------------------

%--
% find control by name, get index
%--

% NOTE: consider simple and grouped controls

for ix = 1:length(controls)
	
	%--
	% select control
	%--
	
	control = controls(ix);
	
	%--
	% check for matching name
	%--
	
	switch class(control.name)
		
		case 'char'
			if strcmp(control.name, name)
				return;
			end
			
		case 'cell'
			if ~isempty(find(strcmp(name, control.name), 1))
				return;
			end
			
	end
	
end

%--
% return empty
%--

control = []; ix = [];
