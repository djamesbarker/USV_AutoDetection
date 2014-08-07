function field_menu(h,str,flag)

% field_menu - field viewing tools menu
% -------------------------------------
%
% field_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - enable flag (def: '')

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
% $Date: 2003-07-06 13:36:52-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% enable flag option
%--

if (nargin == 3)	
	if (get_menu(h,'Field'))
		set(get_menu(h,str),'enable',flag);
	end			
	return;			
end

%--
% set command string
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% perform command sequence
%--

if (iscell(str))
	for k = 1:length(str)
		try
			field_menu(h,str{k}); 
		end
	end
	return;
end
		
%--
% set handle
%--

if (nargin < 1)
	h = gcf;
end

%--
% create parameter tables
%--

[COLOR,COLOR_SEP] = color_to_rgb;

[LINESTYLE,LINESTYLE_SEP] = linestyle_to_str;

%--
% main switch
%--

switch (str)

%--
% Initialize
%--

case ('Initialize')
	
	%--
	% check for existing menu
	%--
	
	if (get_menu(h,'Field'))
		return;
	end

	%--
	% check for existing userdata
	%--
	
	if (~isempty(get(h,'userdata')))
		data = get(h,'userdata');
	end
	
	%--
	% Image
	%--
	
	L = { ...
		'Field', ...
		'Histogram', ...
		'Histogram Options', ...
		'Kernel Estimate', ...		
		'Kernel Options', ...		
		'Fit Model', ...	
		'Fit Options', ... 				
		'Linear', ... 		
		'Semi-Log Y', ... 			
		'Semi-Log X', ...		
		'Log-Log', ...
		'Grid', ...
		'Grid Options' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	S{6} = 'on';
	S{8} = 'on';
	S{12} = 'on';
	
	A = cell(1,n);
	
	tmp = menu_group(h,'field_menu',L,S,A);
	data.field_menu.histogram = tmp;
	
	if (data.field_menu.hist.view)
		set(get_menu(tmp,'Histogram'),'check','on');
	end
	
	if (data.field_menu.grid.on)
		set(get_menu(tmp,'Grid'),'check','on');
	end
	
	set(get_menu(tmp,'Linear'),'check','on');
	
end
