function [value, failure] = get_control_values(pal, mode)

% get_control_values - get values from controls
% ---------------------------------------------
%
% [value, failure] = get_control_values(pal)
%
% Input:
% ------
%  pal - parent figure handle
%
% Output:
% -------
%  value - control value structure or cell array
%  failure - names of controls which we failed to get values from

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

% TODO: update help

% TODO: handle names with multiple words more gracefully, trying to get values
% from the 'Log' palette has problems

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6017 $
% $Date: 2006-08-08 18:35:56 -0400 (Tue, 08 Aug 2006) $
%--------------------------------

%---------------------
% HANDLE INPUT
%---------------------

% TODO: update to handle hierarchical structures

value = [];

%--
% create persistent modes table
%--

persistent MODES;

if isempty(MODES)
	MODES = {'values', 'names'};
end

%--
% set and check mode
%--

if (nargin < 2) || isempty(mode)
	mode = 'values';
else
	if isempty(find(strcmp(MODES, mode)))
		error(['Unrecognized get mode ''', mode, '''.']);
	end
end

%---------------------
% GET CONTROLS
%---------------------

%--
% get palette userdata containing control information
%--

control = get_palette_controls(pal);

%--
% get control names as value fields
%--

% NOTE: we do not get values from controls that are not really controls

j = 1;

for k = 1:length(control)
	
	name = control(k).name; style = control(k).style;
	
	if ( ...
		~iscell(name) && ...
		~isempty(name) && ...
		~strcmp(style,'buttongroup') && ...
		~strcmp(style,'separator') && ...
		~strcmp(style,'tabs') ...
	)

		field{j} = name; j = j + 1;
		
	end
	
end

%--
% output control names only
%--

% TODO: consider output of all controls with names, or non-empty callbacks instead of only value controls

if strcmp(mode, 'names')
	
	value = field; failure = []; return;
	
end

%--
% create value structure or cell array
%--

% NOTE: the alternative output of values and the exception here should be reconsidered

try
	
	%--
	% value structure output
	%--
	
	%--
	% set parameters fields based on control values
	%--
	
	flag = 0; % failure flag
	
	i = 1; % failure counter
	
	for k = 1:length(field)
		
		try
			
			%--
			% get value from control
			%--
						
			[ignore,tmp] = control_update([],pal,field{k});
			
			value.(field{k}) = tmp;
			
		catch
			
			%--
			% try to get value from axes (userdata)
			%--
			
			% could this be handled in control update ??? better not
			
			tmp1 = findobj(pal,'type','uicontrol','tag',field{k});
			
			if (length(tmp1) && strcmp(get(tmp1,'style'),'text'))
				tmp1 = [];
			end
			
			tmp2 = findobj(pal,'type','axes','tag',field{k});
			
			if (isempty(tmp1) && ~isempty(tmp2))
				
				value.(field{k}) = get(tmp2,'userdata');
				
			%--
			% record failure to get control value
			%--
			
			else

				failure{i} = field{k};
				i = i + 1;
				
				flag = 1;
				
			end
			
		end
		
	end
	
end
	
if (flag)
	
	%--
	% clear partial structure created
	%--
	
	clear value;
	
	%--
	% set parameters fields based on control values
	%--
	
	i = 1; % failure counter
	
	j = 1; % success counter
	
	for k = 1:length(field)
		
		try
			
			%--
			% get value from control
			%--
			
			[ignore,tmp] = control_update([],pal,field{k});
						
			value.field{j} = field{k};
			value.value{j} = tmp;
			
			j = j + 1;
			
		catch
			
			%--
			% record failure to get control value
			%--
			
			failure{i} = field{k};
			i =  i + 1;
			
		end
		
	end
	
	%--
	% put fields and values into columns (easier display if needed)
	%--
	
	value.field = value.field';
	
	value.value = value.value';
	
end
	
%--
% put failures into column vector (easier display if needed)
%--

if (i > 1)
	failure = failure';
else
	failure = cell(0);
end
