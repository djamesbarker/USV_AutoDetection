function control = filter_controls(ext,presets)

% filter_controls - get filter controls
% -------------------------------------
%
% control = filter_controls(ext,presets)
%
% Input:
% ------
%  ext - filter extension
%  presets - preset names
%
% Output:
% -------
%  control - control array

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

% TODO: produce common type controls as well as specific type controls

%-----------------------------------
% PRESET
%-----------------------------------

%--
% header
%--

control(1) = control_create( ...
	'string','Presets', ...
	'style','separator', ...
	'type','header', ...
	'space',0.5 ...
);

%--
% preset
%--

L = {'(Manual)'};

if (~isempty(presets))
	L = {L{:}, presets{:}};
end

value = 1;

control(end + 1) = control_create( ...
	'name','preset', ...
	'style','popup', ...
	'space',0.75, ... 
	'lines',1, ... 
	'string',L, ...
	'value',value ...
);

%--
% new preset
%--

control(end + 1) = control_create( ...
	'name','new_preset', ...
	'style','buttongroup', ...
	'space',0.75, ...
	'align','left', ...
	'width',0.5, ...
	'lines',1.75 ...
);

%-----------------------------------
% FILTER
%-----------------------------------

%--
% header
%--

control(end + 1) = control_create( ...
	'string','Filter', ...
	'style','separator', ...
	'type','header' ...
);

%--
% opacity
%--

% TODO: generalize this to other operations

switch (ext.subtype)
	
	case ('signal_filter')
		
	case ('image_filter')
		
		control(end + 1) = control_create( ...
			'name','opacity', ...
			'style','slider', ...
			'min',0, ...
			'max',1, ...
			'value',1 ...
		);

end

%--
% active
%--

value = 0;

control(end + 1) = control_create( ...
	'name','active', ...
	'style','checkbox', ...
	'value',value ...
);
