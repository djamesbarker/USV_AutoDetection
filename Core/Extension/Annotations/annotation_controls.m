function control = annotation_controls(ann)

% annotation_controls - create controls from annotation
% -----------------------------------------------------
%
% NOTE: this is a testbed for what annotations may be

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

% TODO: develop tests for parser

%------------------------------------------
% CREATE HEADER
%------------------------------------------

j = 1;

control(j) = control_create( ...
	'style','separator', ...
	'type','header', ...
	'string',ann.name, ...
	'space',0.75 ...
);
	
%------------------------------------------
% CREATE TABS
%------------------------------------------

% NOTE: there will only be one set of tabs per annotation

elem = {ann.element.elem}';

ix = find(strcmp(elem,'group'));

for k = 1:length(ix)
	
	elem = ann.element(ix(k));
	
	if (isempty(elem.alias))
		tabs{k} = elem.name;
	else
		tabs{k} = elem.alias;
		ann.element(ix(k)).name = elem.alias; % NOTE: this is done for convenience
	end
	
end

if (exist('tabs','var'))
	
	% NOTE: update the header spacing when adding tabs
	
	control(j).space = 0.1;
	
	j = j + 1;
	control(j) = control_create( ...
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

for k = 1:length(ann.element)
	
	elem = ann.element(k);
	
	switch (elem.elem)
		
		%-----------------------
		% GROUP
		%-----------------------
		
		% NOTE: the group only updates the group value
		
		case ('group')
			
			% NOTE: update spacing of predecessor, last element of previous group
			
			control(j).space = 1.5;
			
			group = elem.name;
			
		%-----------------------
		% SUBGROUP
		%-----------------------

		case ('subgroup')
			
			% NOTE: update spacing of predecessor
			
			control(j).space = 1.5;
			
			if (isempty(elem.alias))
				str = elem.name;
			else
				str = elem.alias;
			end
			
			% NOTE: the default alignment for labels is right
			
			j = j + 1;
			control(j) = control_create( ...
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
			
			switch (elem.type)
				
				case ('text')
					
					j = j + 1;
					
					control(j) = control_create( ...
						'name',get_element_name(elem,ann.namespace), ...
						'alias',elem.alias, ...
						'tab',group, ...
						'space',0.75, ...
						'style','edit' ...
					);
				
					if (~isempty(elem.lines))
						control(j).lines = elem.lines;
					end
		
				case ('list')
					
					j = j + 1;
					
					control(j) = control_create( ...
						'name',get_element_name(elem,ann.namespace), ...
						'alias',elem.alias, ...
						'value',1, ...
						'string',elem.value, ...
						'tab',group, ...
						'width',0.75, ...
						'style','popup' ...
					);
				
				case ('numeric')
					
					% NOTE: we first convert numeric array to string list
					
					value = cell(size(elem.value));
					
					for i = 1:length(elem.value)
						value{i} = num2str(elem.value(i));
					end
					
					j = j + 1;
					
					control(j) = control_create( ...
						'name',get_element_name(elem,ann.namespace), ...
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
	% configure and create control group
	%--
	
	opt = control_group;
	
	opt.top = 0; opt.bottom = 0; opt.width = 16;
	
	h = control_group([],'',ann.name,control,opt); set(h,'dockcontrols','off');
	
	%--
	% add text menu to control palette
	%--
	
	text_menu(h);

end


%---------------------------------------------------
% GET_ELEMENT_NAME
%---------------------------------------------------

function name = get_element_name(elem,namespace)

%--
% compute name
%--

% NOTE: we simply compute name considering namespace state

if (namespace)
	
	name = elem.name;
	
	% TODO: implement check that a subgroup is within a group in the parser
	
	if (~isempty(elem.group))
		
		if (~isempty(elem.subgroup))
			name = [elem.subgroup, '__', name];
		end 
		
		name = [elem.group, '__', name];
		
	end
	
	
else
	
	name = elem.name;
	
end
