function control = generate_description_controls(desc)

% generate_description_controls - create controls from description
% ----------------------------------------------------------------

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
% $Revision: 1380 $
% $Date: 2005-07-27 18:37:56 -0400 (Wed, 27 Jul 2005) $
%--------------------------------

% TODO: rename this function and save this name for a function that generates code

% TODO: develop tests for parser

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

if (~isstruct(desc))
	
	if (~ischar(desc))
		error('Input must be description struct or description file.');
	end
	
	if (~exist(desc,'file'))
		error('Unable to find description file.');
	end
	
	desc = parse_description_file(desc);
	
end

%------------------------------------------
% CREATE HEADER
%------------------------------------------

% NOTE: consider replacement here, when name or alias is preceded by money

control = control_create( ...
	'style','separator', ...
	'type','header', ...
	'string',desc.name, ...
	'space',0.75 ...
);
	
%------------------------------------------
% CREATE TABS
%------------------------------------------

% NOTE: there will only be one set of tabs per annotation

elem = {desc.element.elem}';

ix = find(strcmp(elem,'group'));

for k = 1:length(ix)
	
	elem = desc.element(ix(k));
	
	if (isempty(elem.alias))
		tabs{k} = elem.name;
	else
		tabs{k} = elem.alias;
		desc.element(ix(k)).name = elem.alias; % NOTE: this is done for convenience
	end
	
end

if (exist('tabs','var'))
	
	% NOTE: update the header spacing when adding tabs
	
	control(end).space = 0.1;
	
	control(end + 1) = control_create( ...
		'style','tabs', ...
		'name','', ...
		'label',0, ... 
		'lines',1.25, ...
		'tab',tabs ...
	);

end

%------------------------------------------
% CREATE ELEMENT CONTROLS
%------------------------------------------

group = '';

for k = 1:length(desc.element)
	
	elem = desc.element(k);
	
	switch (elem.elem)
		
		%-----------------------
		% GROUP
		%-----------------------
		
		% NOTE: the group only updates the group value
		
		case ('group')
			
			% NOTE: update spacing of predecessor, last element of previous group
			
			control(end).space = 1.5;
			
			group = elem.name;
			
		%-----------------------
		% SUBGROUP
		%-----------------------

		case ('subgroup')
			
			% NOTE: update spacing of predecessor
			
			control(end).space = 1.5;
			
			if (isempty(elem.alias))
				str = elem.name;
			else
				str = elem.alias;
			end
			
			% NOTE: the default alignment for labels is right
			
			control(end + 1) = control_create( ...
				'name',str, ...
				'string',str, ...
				'tab',group, ...
				'align','right', ...
				'space',0.75, ...
				'style','separator' ...
			);

		%-----------------------
		% ELEMENT
		%-----------------------
		
		case ('element')
			
			%--
			% update element to consider namespace option
			%--
			
			if (desc.namespace)
				elem = namespace_update(elem);
			end
			
			%--
			% create element control
			%--
			
			switch (elem.type)
				
				%--
				% TEXT
				%--
				
				% TODO: create separate 'edit' control
				
				case ('text')
					
					control(end + 1) = control_create( ...
						'name',elem.name, ...
						'alias',elem.alias, ...
						'tab',group, ...
						'space',0.75, ...
						'style','edit' ...
					);
				
					if (~isempty(elem.lines))
						control(end).lines = elem.lines;
					end
		
				%--
				% LIST OF VALUES
				%--
				
				case ('list')
					
					control(end + 1) = control_create( ...
						'name',elem.name, ...
						'alias',elem.alias, ...
						'value',1, ...
						'string',elem.value, ...
						'tab',group, ...
						'width',0.75, ...
						'style','popup' ...
					);
				
				%--
				% NUMERIC SEQUENCE
				%--
				
				case ('numeric')
					
					% NOTE: we first convert numeric array to string list
					
					value = cell(size(elem.value));
					
					for i = 1:length(elem.value)
						value{i} = num2str(elem.value(i));
					end
					
					control(end + 1) = control_create( ...
						'name',elem.name, ...
						'alias',elem.alias, ...
						'value',1, ...
						'string',value, ...
						'tab',group, ...
						'width',0.25, ...
						'style','popup' ...
					);
					
			end
			
	end

end

% NOTE: this has a similar effect as the update in the 'group' case

control(end).space = 1.5;

%--
% render controls if no output
%--

% NOTE: this is for testing purposes

if (~nargout)
	
	%--
	% configure palette
	%--
	
	opt = control_group; opt.top = 0; opt.bottom = 0; opt.width = 14;
	
	%--
	% create palette and add text menu
	%--
	
	h = control_group([],'',desc.name,control,opt);

	text_menu(h);

end


%---------------------------------------------------
% NAMESPACE_UPDATE
%---------------------------------------------------

function elem = namespace_update(elem)

% TODO: implement check that a subgroup is within a group in the parser

%--
% compute namespaced name
%--

name = elem.name;

if (~isempty(elem.group))

	if (~isempty(elem.subgroup))
		name = [elem.subgroup, '__', name];
	end 

	name = [elem.group, '__', name];

end

%--
% update element
%--

elem.alias = elem.name;

elem.name = name;


