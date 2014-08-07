function [ax, h] = harray_select(par, varargin)

% harray_select - select elements from an harray array
% ----------------------------------------------------
%
% [ax, h] = harray_select(par, 'field', 'value', ... )
%
% Input:
% ------
%  par - parent figure
%  field - field
%  value - value
%
% Output:
% -------
%  ax - selected axes
%  h - corresponding harray elements

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
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% check handle input
%--

if ~ishandle(par) || ~strcmp(get(par, 'type'), 'figure')
	error('Input must be parent figure handle.');
end

data = harray_data(par);
	
if isempty(data)
	error('Input figure does not seem to contain hierarchical axes.');
end
	
%--
% get harray data from parent figure
%--

h = data.harray;

%--
% get field value pairs
%--

% TODO: add allowed fields

[field, value] = get_field_value(varargin);

%-----------------------------------
% SELECT HARRAY ELEMENTS
%-----------------------------------

%--
% loop over selection fields
%--

for k = 1:length(field) 
	
	%--
	% stop selecting if there is nothing to select from
	%--
	
	if isempty(h)
		break;
	end

	%--
	% perform selection based on field
	%--
	
	switch field{k}
		
		%--
		% select by level or parent
		%--
		
		case {'level', 'parent'}
				
			h = h([h.(field{k})] == value{k});
			
		%--
		% select by row, column, or full position
		%--
		
		% NOTE: currently this supports single index selection
		
		case {'row', 'col', 'position'}
			
			%--
			% get local position from level and index
			%--

			level = [h.level]'; 
			
			index = reshape([h.index]', length(h(1).index), [])';
			
			pos = get_local_position(level, index);
			
			%--
			% select row, column or full index
			%--
			
			switch field{k}
				
				case 'row', h = h(pos(:,1) == value{k});
				
				case 'col', h = h(pos(:,2) == value{k});
					
				case 'position'
					
					ix = ((pos(:, 1) == value{k}(1)) + (pos(:, 2) == value{k}(2))) == 2; h = h(ix);
					
			end
		
		%--
		% select parent of child
		%--
		
		case 'child'
			
			%--
			% get children
			%--
			
			children = {h.children}';
			
			%--
			% match child to parent
			%--
			
			for j = 1:length(children)
				
				if isempty(children{j})
					continue;
				end
				
				% NOTE: a child has a single parent so we can break
				
				if ~isempty(find(value{k} == children{j}, 1))
					h = h(j); break;
				end
				
			end
			
	end
	
end

%--
% output axes with proper shape
%--

if isempty(h)
	ax = [];
else
	ax = reshape([h.axes], size(h));
end


%-----------------------------------
% GET_LOCAL_POSITION
%-----------------------------------

function pos = get_local_position(level, index)

pos = zeros(length(level), 2);

% NOTE: consider special base axes case

start = 1;

if ~index(1)
	pos(1, :) = [0, 0]; start = 2;
end

for k = start:length(level)
	pos(k, :) = index(k, 2 * level(k) - [1, 0]);
end


