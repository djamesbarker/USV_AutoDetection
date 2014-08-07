function g = struct_menu(h, in, opt, skip)

% struct_menu - create menu representation of structure
% -----------------------------------------------------
%
% g = struct_menu(h, in, opt)
%
% Input:
% ------
%  h - parent of menus
%  in - structure input
%  opt - display option (def: 'compact')
%
% Output:
% -------
%  g - handles to menus created

% TODO: extend this idea to produce value menus, use a value structure and a description structure

% NOTE: the first use of this function should be to provide a display for detection values

%---------------------------------------------------------
% HANDLE INPUT
%---------------------------------------------------------

%--
% set default skip
%--

if nargin < 4
	skip = 0;
end

% NOTE: we skip tests on internal calls for speed

if ~skip
	%--
	% set display option
	%--

	% NOTE: this option may not be used often

	if (nargin < 3) || isempty(opt)
		opt = 'compact';
	end

	%--
	% check for proper handle input
	%--

	if ~ishandle(h)
		error('First input must be a handle.');
	end

	%--
	% check that input object handle can be a menu parent
	%--

	type = get(h, 'type');

	if ~(strcmp(type, 'figure') || strcmp(type, 'uimenu') || strcmp(type, 'uicontextmenu'))
		error('First input must be handle to a figure or menu object.');
	end

	%--
	% check for at most matrix structure input
	%--

	if ~isstruct(in)
		db_disp; stack_disp; disp(in)
		
		error('Second input must be structure.');
	end

	if length(in) > 1
		error('Second input must be a scalar.');
	end
end

%--
% initialize handle output
%--

g = [];

%---------------------------------------------------------
% HANDLE SCALAR STRUCTURE
%---------------------------------------------------------

% NOTE: this function does not use recursion to handle struct arrays, only scalar arrays are processed

%--
% create menus for different fields
%--

field = fieldnames(in);

for k = 1:length(field)

	%--
	% copy value for convenience
	%--
	
	value = in.(field{k});

	% NOTE: skip higher dimensional arrays, this is just too ugly
	
	if ndims(value) > 2
		continue;
	end

	%-----------------------------
	% STRUCTURE
	%-----------------------------

	if isstruct(value)

		%-----------------------------
		% SCALAR
		%-----------------------------
		
		if numel(value) == 1		
			%--
			% create field menu
			%--

			str = [title_caps(field{k}, '_') ':  '];

			tmp = uimenu(h, 'label', str); g = [g, tmp];

			%--
			% perform recursive call to generate menus
			%--

			tmp = struct_menu(tmp, value, opt, 1); g = [g, tmp];
		
			continue;
		end
		
		%-----------------------------
		% VECTOR
		%-----------------------------
		
		if min(size(value)) == 1
			%--
			% create field menu
			%--

			field_title = title_caps(field{k}, '_');

			str = [field_title, ':  '];

			par = uimenu(h, 'label', str); g = [g, par];

			%--
			% create field element menus
			%--

			switch opt
				case 'compact'
					
					fields = fieldnames(value(1));
					
					for j = 1:numel(value)

						for i = 1:length(fields)
							
							value_field = value(j).(fields{i});
							
							if isstruct(value_field)

								tmp = struct_menu(par, value_field, opt); g = [g, tmp];

							elseif ischar(value_field)

								tmp = string_menu(par, value_field, opt, fields{i}); g = [g, tmp];
								
							elseif isnumeric(value_field)

								tmp = numeric_menu(par, value_field, opt, fields{i}); g = [g, tmp];

							end
							
							if (i == 1)
								set(tmp, 'separator', 'on');
							end
						end
					end
					
				otherwise
					
					for j = 1:numel(value)

						str = [field_title, ' (' int2str(j) '):  '];

						tmp = uimenu(par, 'label', str); g = [g, tmp];

						%--
						% perform recursive call to generate menus
						%--

						tmp = struct_menu(tmp, value(j), opt, 1); g = [g, tmp];
					end			
			end
			
			continue;
		end

		%-----------------------------
		% MATRIX
		%-----------------------------

		%--
		% create field menu
		%--

		field_title = title_caps(field{k},'_');

		str = [field_title ':  '];

		par = uimenu(h,'label',str); g = [g, par];

		%--
		% create field element menus
		%--

		[m, n] = size(value);
		
		for j = 1:n
			for i = 1:m

				str = [field_title ' (' int2str(j) ',' int2str(j) '):  '];

				tmp = uimenu(par,'label',str); g = [g, tmp];

				%--
				% perform recursive call to generate menus
				%--

				tmp = struct_menu(tmp,value(i,j),opt,1); g = [g, tmp];
			end
		end

	%-----------------------------
	% CELL
	%-----------------------------

	elseif iscell(value)
		
		%-----------------------------
		% SCALAR
		%-----------------------------
		
		if numel(value) == 1
			
			%--
			% create field menu
			%--

			str = [title_caps(field{k},'_') ' {1}:  '];

			tmp = uimenu(h,'label',str); g = [g, tmp];

			%--
			% get contents of cell
			%--

			value = value{1};

			%--
			% call menu function to generate element menus
			%--

			if isstruct(value)

				tmp = struct_menu(tmp,value,opt);
				g = [g, tmp];

			elseif ischar(value)

				tmp = string_menu(tmp,value,'compact',field{k});
				g = [g, tmp];

			elseif isnumeric(value)

				tmp = numeric_menu(tmp,value,opt,field{k});
				g = [g, tmp];

			end
			
			continue;
			
		end

		%-----------------------------
		% VECTOR
		%-----------------------------
			
		if min(size(value)) == 1

			%--
			% create field menu
			%--

			field_title = title_caps(field{k},'_');

			str = [field_title ':  '];

			par = uimenu(h,'label',str); g = [g, par];

			%--
			% create field element menus
			%--

			[m, n] = size(value);
			
			for j = 1:max(m, n)

				str = [field_title ' {' int2str(j) '}:  '];

				tmp = uimenu(par,'label',str); g = [g, tmp];

				%--
				% get contents of cell
				%--

				tmp_value = value{j};

				%--
				% call menu function to generate element menus
				%--

				if isstruct(tmp_value)

					tmp = struct_menu(tmp,tmp_value,opt);
					g = [g, tmp];

				elseif ischar(tmp_value)

					tmp = string_menu(tmp,tmp_value,'compact',field{k});
					g = [g, tmp];

				elseif isnumeric(tmp_value)

					tmp = numeric_menu(tmp,tmp_value,opt,field{k});
					g = [g, tmp];

				end

			end
			
			continue;

		end

		%-----------------------------
		% MATRIX
		%-----------------------------
		
		%--
		% create field menu
		%--

		field_title = title_caps(field{k},'_');

		str = [field_title ':  '];

		par = uimenu(h, 'label', str); g = [g, par];

		%--
		% create field element menus
		%--

		[m, n] = size(value);
		
		for j = 1:n

			for i = 1:m

				str = [field_title, ' (', int2str(j), ',', int2str(j), '):  '];

				tmp = uimenu(gf, 'label', str); g = [g, tmp];

				%--
				% get contents of cell
				%--

				tmp_value = value{i,j};

				%--
				% call menu function to generate element menus
				%--

				if isstruct(tmp_value)

					tmp = struct_menu(tmp, tmp_value, opt); g = [g, tmp];

				elseif ischar(tmp_value)

					tmp = string_menu(tmp, tmp_value, 'compact', field{k}); g = [g, tmp];

				elseif isnumeric(tmp_value)

					tmp = numeric_menu(tmp, tmp_value, opt, field{k}); g = [g, tmp];

				end

			end

		end

	%-----------------------------
	% FUNCTION HANDLE
	%-----------------------------

	elseif isa(value, 'function_handle')

		%--
		% create field menu
		%--

		str = [title_caps(field{k},'_') ':  '];

		tmp = uimenu(h, 'label', str); g = [g, tmp];

		%--
		% convert handle to structure and generate menu
		%--

		value = functions(value);

		tmp = struct_menu(tmp, value, opt); g = [g, tmp];

	%-----------------------------
	% STRING FIELD
	%-----------------------------

	elseif ischar(value)

		tmp = string_menu(h, value, opt, field{k}); g = [g, tmp];

	%-----------------------------
	% NUMERIC FIELD
	%-----------------------------

	elseif isnumeric(value)

		tmp = numeric_menu(h, value, opt, field{k}); g = [g, tmp];

	end

end


%-----------------------------
% PRETTY_NUM2STR
%-----------------------------

function str = pretty_num2str(num, name)

% pretty_num2str - modified num2str for menu display
% --------------------------------------------------
%
% str = pretty_num2str(num)
%
% Input:
% ------
%  num - number to display
%
% Output:
% -------
%  str - number string

% NOTE: add spaces to plus sign used in complex number strings

if nargin < 2
	name = '';
end
	
switch lower(name)

	case {'datetime', 'created', 'modified'}
		try
			str = datestr(num);
		end

	case {'time'}
		try
			str = sec_to_clock(num);
		end

	otherwise
		str = strrep(num2str(num),'+',' + ');
		
end
	

%-----------------------------
% NUMERIC_MENU
%-----------------------------

function g = numeric_menu(h, value, opt, name)

% numeric_menu - create menu representation of numeric arrays
% -----------------------------------------------------------
%
% g = numeric_menu(h, value, opt, name)
%
% Input:
% ------
%  h - parent handle
%  value - numeric array
%  opt - display option
%  name - name of array
%
% Output:
% -------
%  g - handles of created menus

%--
% get size of numeric array
%--

[m,n] = size(value);

%--
% initialize handles
%--

g = [];

name = field_str(name);

%-----------------------------------
% handle scalars and vectors
%-----------------------------------

if (min(m,n) == 1)

	%-----------------------------------
	% scalar case
	%-----------------------------------

	if (max(m,n) == 1)

		%--
		% create single field and value menu
		%--

		str = [title_caps(name,'_') ':  ' pretty_num2str(value, name)];

		tmp = uimenu(h,'label',str);
		g = [g, tmp];

		%-----------------------------------
		% vector case
		%-----------------------------------

	else

		%--
		% create field menu
		%--

		field_title = title_caps(name,'_');

		str = [field_title ':  '];

		gf = uimenu(h,'label',str);
		g = [g, gf];

		%--
		% create header menu for compact display
		%--

		if strcmp(opt,'compact')

			if (m > 1)
				str = ['Column  (' int2str(m) ' x 1)'];
			else
				str = ['Row  (1 x ' int2str(n) ')'];
			end

			tmp = uimenu(gf,'label',str,'enable','off');
			g = [g, tmp];

		end

		%--
		% create entry menus
		%--

		for j = 1:max(m,n)

			% the non-compact display has alignment problems since the menu
			% font cannot be guaranteed (and will likely not be)
			% monospcaced

			if strcmp(opt, 'compact')
				str = pretty_num2str(value(j), name);
			else
				str = [field_title, ' (', int2str(j), '):  ', pretty_num2str(value(j), name)];
			end

			tmp = uimenu(gf, 'label', str); g = [g, tmp];

			%--
			% separate header
			%--

			if (j == 1)
				set(tmp, 'separator', 'on');
			end

		end

	end

	%-----------------------------------
	% handle matrices
	%-----------------------------------

else

	%--
	% create field menu
	%--

	field_title = title_caps(name, '_');

	str = [field_title, ':  '];

	gf = uimenu(h,'label',str); g = [g, gf];

	%-----------------------------------
	% sparse case
	%-----------------------------------

	if issparse(value)

		%--
		% create header menu for compact display
		%--

		if strcmp(opt, 'compact')

			str = ['Sparse  (', int2str(m), ' x ', int2str(n), ')  (', int2str(nnz(value)), ')'];

			tmp = uimenu(gf,'label',str,'enable','off');
			g = [g, tmp];

			str = ['(Column Order)'];

			tmp = uimenu(gf,'label',str,'enable','off');
			g = [g, tmp];

		end

		%--
		% get nonzero entries
		%--

		[i,j,s] = find(value);

		%--
		% create entry menus
		%--

		for l = 1:length(s)

			%--
			% create field and value display menu
			%--

			if strcmp(opt, 'compact')
				str = ['(', int2str(i(l)), ',', int2str(j(l)), ')  ', pretty_num2str(s(l), name)];
			else
				str = [field_title, ' (', int2str(i(l)), ',', int2str(j(l)), '):  ', pretty_num2str(s(l), name)];
			end

			tmp = uimenu(gf,'label',str); g = [g, tmp];

			%--
			% add header separator
			%--

			if (l == 1)

				set(tmp,'separator','on');

				%--
				% add column separators
				%--

			elseif (j(l) > j(l - 1))

				set(tmp,'separator','on');

			end

		end

		%-----------------------------------
		% dense case
		%-----------------------------------

	else

		%--
		% create header menu for compact display
		%--

		if strcmp(opt,'compact')

			str = ['Matrix  (' int2str(m) ' x ' int2str(n) ')'];

			tmp = uimenu(gf,'label',str,'enable','off');
			g = [g, tmp];

			str = ['(Column Order)'];

			tmp = uimenu(gf,'label',str,'enable','off');
			g = [g, tmp];

		end

		%--
		% create entry menus
		%--

		%--
		% loop over columns
		%--

		for j = 1:n

			%--
			% loop over rows
			%--

			for i = 1:m

				if strcmp(opt,'compact')
					str = pretty_num2str(value(i,j));
				else
					str = [field_title ' (' int2str(i) ',' int2str(j) '):  ' pretty_num2str(value(i,j))];
				end

				tmp = uimenu(gf,'label',str);
				g = [g, tmp];

				if (i == 1)
					set(tmp,'separator','on');
				end

			end

		end

	end

end


%-----------------------------
% STRING_MENU
%-----------------------------

function g = string_menu(h, value, opt, name)

% string_menu - create menu representation of string arrays
% ---------------------------------------------------------
%
% g = string_menu(h, value, opt, name)
%
% Input:
% ------
%  h - parent handle
%  value - string array
%  opt - display option
%  name - name of array
%
% Output:
% -------
%  g - handles of created menus

% NOTE: currently this function is not using the 'compact' option

% NOTE: the short string length should be an option

g = []; name = field_str(name);

if (length(value) < 32)

	% NOTE: for short strings we create single menu with field and value

% 	str = [title_caps(name,'_') ':  ''' value ''''];

	% NOTE: these may not be strings always, clock strings are common and we don't want quotes
	
	str = [title_caps(name,'_') ':  ' value];
	
	g(end + 1) = uimenu(h, 'label', str);
else
	% NOTE: for long strings we create separate fieldname and value menus

	str = [title_caps(name,'_') ':  '];

	g(end + 1) = uimenu(h, 'label', str);

	str = ['''' value ''''];

	g(end + 1) = uimenu(g(end), 'label', str);
end


%-----------------------------
% FIELD_STR
%-----------------------------

function out = field_str(in)

% NOTE: at the moment we perform some custom replacements and uncamel fieldnames

in = strrep(in, 'Num', '');

out = str_uncamel(in, ' ');
