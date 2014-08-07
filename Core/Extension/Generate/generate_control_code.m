function lines = generate_control_code(parameter)

% generate_control_code - generate code to create controls for struct
% -------------------------------------------------------------------
%
% lines = generate_control_code(parameter)
%
% Input:
% ------
%  in - structure to generate controls for
%
% Output:
% -------
%  lines - lines of code to generate controls

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

%--------------------------------------
% HANDLE INPUT
%--------------------------------------

if ~isstruct(in) || (length(in) > 1)
	error('Input must be a scalar structure.');
end

%--------------------------------------
% GENERATE CODE
%--------------------------------------

% TODO: generate minimal simple code, typically we cannot properly declare
% many aspects of the controls, however we can help with the repetitive
% parts.

%--
% flatten struct, this yields canonical names
%--

in = flatten_struct(in);

names = fieldnames(in);

%--
% create control code
%--

lines = cell(0); count = 1;

for k = 1:length(names)

	%--
	% open control declaration
	%--

	lines{end + 1} = ' ';
	
	if (count == 1)
		lines{end + 1} = 'control(1) = control_create( ...';
	else
		lines{end + 1} = 'control(end + 1) = control_create( ...';
	end

	%--
	% infer control properties using value information
	%--

	value = in.(names{k});

	switch class(value)

		%--
		% cell value
		%--
		
		case 'cell'
			
			%--
			% try to generate control for string cell
			%--
			
			if iscellstr(value)
				
				switch length(value)
					
					case 0
						lines(end) = []; continue;
						
					case 1
						style = 'popupmenu'; string = ['{''', value{1}, '''}']; value = '1';
						
					otherwise
						
						style = 'listbox'; 
						
						string = '{';
						for j = 1:length(value) - 1
							string = [string, '''', value{j}, ''','];
						end
						string = [string, '''', value{end}, '''}'];
						
						value = '1';
						
				end
								
			%--
			% it is not clear how to create a control for non string cell
			%--
			
			else
				
				lines(end) = []; continue;
				
			end

		%--
		% string value
		%--
		
		case ('char')
			
			style = 'edit'; string = value;
			
		%--
		% other controls
		%--
		
		otherwise

			if (isnumeric(value) && (length(value) == 1))
				
				style = 'slider';
				
				value_min = num2str(min(0,value)); 
				value_max = num2str(max(1,value)); 
				value = num2str(value);
				
			else
				
				lines(end) = []; continue;
				
			end

	end

	%--
	% increment control counter
	%--
	
	count = count + 1;
	
	%--
	% generate control creation code
	%--

	lines{end + 1} = ['	''name'', ''', names{k}, ''', ...'];
	lines{end + 1} = ['	''style'', ''', style, ''', ...'];

	switch style
		
		case {'listbox', 'popupmenu'}
			
			lines{end + 1} = ['    ''string'', ', string, ', ...'];
			lines{end + 1} = ['	   ''value'', ', value, ' ...'];
			
		case 'slider'
			
			lines{end + 1} = ['	   ''min'', ', value_min, ', ...'];
			lines{end + 1} = ['    ''max'', ', value_max, ', ...'];
			lines{end + 1} = ['    ''value'', ', value, ' ...'];
			
		otherwise
			
			lines{end + 1} = ['	''value'',''', value, ''' ...'];

	end

	lines{end + 1} = ');';

end

% NOTE: output column cell array, readable in command line

lines = lines(:);
