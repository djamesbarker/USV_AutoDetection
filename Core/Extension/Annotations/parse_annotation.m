function ann = parse_annotation(f)

% parse_annotation - parse annotation description file
% ----------------------------------------------------
%
% ann = parse_annotation(f)
%
% Input:
% ------
%  f - file containing annotation description
%
% Output:
% -------
%  ann - annotations contained in file

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

% NOTE: consider optional use of namespaces for variable fields

% TODO: add author, version, and possibly other metadata parsing

%--
% configure line reading
%--

opt = file_readlines; opt.pre = '%'; opt.skip = 1;

%--
% get trimmed lines from file
%--

buff = file_readlines(f,@strtrim,opt);

if (isempty(buff))
	ann = [];
end

%--
% separate elements into separate lines
%--

line = cell(0);

for k = 1:length(buff)
	
	ix = strfind(buff{k},';');
	
	if (length(ix) < 2)
		
		line{end + 1} = buff{k};
		
	else
		
		ix = [0, ix];
		
		for j = 1:(length(ix) - 1)
			line{end + 1} = strtrim(buff{k}((ix(j) + 1):ix(j + 1)));
		end
		
	end
		
end

%--
% parse file
%--

n = 1; level = 0;

for k = 1:length(line)
	
	%--
	% check for start of annotation
	%--
	
	if (level == 0)
		
		out = start_annotation(line{k});
		
		if (isempty(out))
			continue;
		end
		
		level = 1;
		
		ann(n) = out; 
		
		n = n + 1; group = ''; subgroup = '';
		
	%--
	% add elements to annotation
	%--
	
	else

		%--
		% parse element
		%--
		
		[elem,out,level] = parse_element(line{k},level);

		if (isempty(elem))
			continue;
		end
		
		%--
		% update and copy group and subgroup information
		%--
		
		switch (out)
			
			%--
			% set author
			%--
			
			case ('author')
				ann(end).author = elem{1};
			%--
			% set version
			%--
			
			case ('version')
				ann(end).version = elem{1};
				
			%--
			% set namespacing mode
			%--
			
			case ('namespace')
				ann(end).namespace = elem;
				
			%--
			% add element to annotation
			%--
			
			case ('element')
				
				%--
				% update state based on element type
				%--
				
				switch (elem.elem)

					case ('group')
						group = elem.name;

					case ('subgroup')
						subgroup = elem.name; elem.group = group;

					otherwise
						elem.group = group; elem.subgroup = subgroup;

				end

				%--
				% add element to annotation
				%--

				if (isempty(ann(end).element))
					ann(end).element = elem;
				else
					ann(end).element(end + 1) = elem;
				end
				
		end
		
	end
	
end

%--------------------------------------------------
% START_ANNOTATION
%--------------------------------------------------

function ann = start_annotation(str)

% start_annotation - start parsing of annotation
% ----------------------------------------------

%--
% check for start of annotation
%--

if (~strmatch(str,'annotation'))
	ann = []; return;
end

[ignore,name,alias] = strread(str,'%s %s %q');

%--
% create and output annotation
%--

ann.file = name{1};

if (~isempty(alias))
	ann.name = alias{1};
else
	ann.name = ann.file;
end

ann.author = [];

ann.version = [];

ann.namespace = [];

ann.element = [];


%--------------------------------------------------
% CREATE_ELEMENT
%--------------------------------------------------

function elem = create_element

% NOTE: this should be group, subgroup, or element

elem.elem = '';

elem.group = '';

elem.subgroup = '';

elem.name = '';

elem.alias = '';

elem.type = '';

elem.value = '';

elem.lines = [];

elem.width = [];


%--------------------------------------------------
% PARSE_ELEMENT
%--------------------------------------------------

function [elem,out,level] = parse_element(str,level)

% parse_element - parse annotation element string
% -----------------------------------------------

%--
% check for end line
%--

if (strmatch('end',str))
	elem = []; out = []; level = level - 1; return;
end
	
%--
% check for metadata tags
%--

% NOTE: the author should be in quotes

if (strmatch('author',str))
	[ignore,elem] = strread(str,'%s %q'); out = 'author'; return;
end

% NOTE: the version should have no spaces, or perhaps we should place it in quotes

if (strmatch('version',str))
	[ignore,elem] = strread(str,'%s %s'); out = 'version'; return;
end

% NOTE: we can turn namespace names on and off by setting to 1 or 0

if (strmatch('namespace',str))
	[ignore,elem] = strread(str,'%s %d'); out = 'namespace'; return;
end
	
%--
% create element
%--

elem = create_element;

%--
% get element type
%--

elem_type = '';

if (isempty(elem_type) & strmatch('group',str))
	elem_type = 'group'; level = level + 1;
end

if (isempty(elem_type) & strmatch('subgroup',str))
	elem_type = 'subgroup'; level = level + 1;
end

if (isempty(elem_type))
	elem_type = 'element';
end

elem.elem = elem_type;

out = 'element';

%--
% parse element based on element type
%--

switch (elem_type)
	
	%--
	% group
	%--
	
	% NOTE: a group contains a name and may contain an alias
	
	case ('group')
		
		[ignore,name,alias] = strread(str,'%s %s %q');
		
		if (~isvarname(name{1}))
			error(['Group name ''', name{1}, ''' is not a valid variable name.']);
		end
		
		elem.name = name{1}; 
		
		if (~isempty(alias))
			elem.alias = alias{1};
		end
		
	%--
	% subgroup
	%--
	
	% NOTE: a subgroup contains a name and may contain an alias
	
	case ('subgroup')
		
		[ignore,name,alias] = strread(str,'%s %s %q');
		
		if (~isvarname(name{1}))
			error(['Subgroup name ''', name{1}, ''' is not a valid variable name.']);
		end
		
		elem.name = name{1}; 
		
		if (~isempty(alias))
			elem.alias = alias{1};
		end
		
	%--
	% element
	%--
	
	case ('element')
		
		%--
		% separate element string into name and type parts
		%--

		[name_str,type_str] = strtok(str,'=');

		name_str = strtrim(name_str); type_str = strtrim(type_str(2:end));
		
		%--
		% parse name string
		%--

		[name,alias] = strread(name_str,'%s %q');

		if (~isvarname(name{1}))
			error(['Element name ''', name{1}, ''' is not a valid variable name.']);
		end
		
		elem.name = name{1}; 
		
		if (~isempty(alias))
			elem.alias = alias{1};
		end
		
		%--
		% parse type string
		%--
		
		if (~strcmp(type_str(end),';'))
			error('Missing semicolon at end of line');
		end
		
		%--
		% text type
		%--
		
		% NOTE: we get some layout information from type
		
		if (strcmpi(type_str(1:4),'text'))
			
			[ignore,lines,width] = strread(type_str(1:(end - 1)),'%s %u %f');
			
			elem.type = 'text'; elem.value = '';
				
			if (~isempty(lines))
				elem.lines = lines;
			end
			
			if (~isempty(width))
				elem.width = width;
			end
			
		%--
		% list types
		%--
			
		else
				
			% NOTE: we get list values through evaluation

			str = ['elem.value = ', strrep(type_str,'"','''')]; eval(str);

			%--
			% list (of labels)
			%--

			if (iscellstr(elem.value))
				elem.type = 'list'; 
			end

			%--
			% numeric value
			%--

			if (isnumeric(elem.value) && isreal(elem.value))
				elem.type = 'numeric';
			end 

			if (isempty(elem.type))
				error('List types must be label lists or real number lists.');
			end

		end
		
end
