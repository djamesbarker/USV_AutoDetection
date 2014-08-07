function disp(in, flat)

%--
% no flatten default
%--

if nargin < 2
	flat = 0;
end

%--
% try to get display name from input name
%--

name = inputname(1); 

if isempty(name) 
	name = 'ans'; 
end

%--
% display scalar or empty struct
%--

if numel(in) < 2
	
	disp(' '); disp(['', name, ' = ']); disp(' '); disp2(in, flat);

%--
% display struct array
%--

else

	for k = 1:numel(in)
		disp(' '); disp(['', name, '(', int2str(k), ') = ']); disp(' '); disp2(in(k), flat); 
	end
	
end

disp(' ');


%-----------------------------------
% DISP2
%-----------------------------------

% NOTE: this function displays a single struct

function disp2(in, flat)

%--
% flatten if needed
%--

if flat
	in = flatten(in);
end

%--
% get struct fields and consider their length for display
%--

field = fieldnames(in);

% TODO: improve display of trivial struct

if isempty(field)
	return;
end

len = max(iterate(@numel, field)) + 4;

for k = 1:numel(field)
	
	str = get_value(in.(field{k}), len);
	
	if ischar(str)
		disp([get_prefix(field{k}, len), str]);
	else
		disp(get_prefix(field{k}, len)); iterate(@disp, str);
	end
	
end


%-----------------------------------
% GET_PREFIX
%-----------------------------------

function str = get_prefix(str, len)

str = [char(double(' ') * ones(1, len - numel(str))), str, ':  '];


%-----------------------------------
% GET_VALUE 
%-----------------------------------

function str = get_value(value, len)

str = '';

if ischar(value)
	
	% TODO: expand the display of linked strings to include other viewable files
	
	if numel(value) > 4 && (strcmp(value(1:4), 'http') || strcmp(value(end - 3:end), 'html'))
		str = get_link(value);
	else 
		str = ['''', value, ''''];
	end
	
else
	
	%--
	% numeric arrays
	%--
	
	if isnumeric(value) || isa(value, 'logical')
		
		str = strrep(mat2str(size(value)), ' ', 'x');
			
		str = [str(1:end - 1), ' ', class(value), ']'];
			
		if numel(value) < 16	
			if strcmp(class(value), 'double')
				str = [str, ' ', mat2str(value)];
			else
				str = [str, ' ', mat2str(double(value))];
			end
		end
		
	%--
	% cell arrays
	%--
	
	elseif iscell(value)
	
		if isempty(value)
			
			% EMPTY CELL
			str = '{}';
			
		elseif iscellstr(value)

			% STRING CELL
	
			if 1 % max(iterate(@numel, value)) < 10
				
				str = ['{', str_implode(value, ', ', @get_value), '}'];
				
			else
				
				pad = char(double(' ') * ones(1, len - numel(str)));
				
				str{1} = [pad, '{'];
				
				for k = 1:numel(value)
					str{k + 1} = [pad, '  ''', get_value(value{k}), ''','];
				end
				
				str{end + 1} = [pad, '}'];
				
			end

		elseif all(cellfun(@isnumeric, value))

			% NUMERIC CELL
			
			str = ['{''', str_implode(value, ''', ''', @mat2str), '''}'];

		end

	%--
	% function handles
	%--
	
	elseif isa(value, 'function_handle')
		
		info = functions(value); [ignore, name, ignore] = fileparts(info.file); str = ['@', name, ' (', info.file, ')']; %#ok<ASGLU>
	
	%--
	% struct
	%--
	
	elseif isa(value, 'struct')
		
		n = size(value);
		
		prefix = ['[', str_implode(n, 'x', @int2str)];
		
		fields = fieldnames(value);
		
		if numel(fields)
			str = [prefix, ' struct] with fields {''', str_implode(fieldnames(value), ''', '''), '''}'];
		else
			str = [prefix, ' struct]'];
		end

	%--
	% other
	%--
	
	else
		
		str = upper(class(value));
	end

end


function link = get_link(str)

link = ['<a href="matlab:web(''', str, ''', ''-browser'');">', str, '</a>'];

