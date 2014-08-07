function [lines, header] = struct_to_csv(in, fun)

% struct_to_csv - convert struct to CSV lines of text
% ---------------------------------------------------
%
% [lines, header] = struct_to_csv(in, fun)
%
% Input:
% ------
%  in - struct
%  fun - text conversion helper (def: @to_str)
%
% Output:
% -------
%  lines - struct field value lines
%  header - header line
% 
% NOTE: we cannot handle a struct field that contains a struct array

%-------------------
% HANDLE INPUT
%-------------------

%--
% set no conversion helper default
%--

% NOTE: move this helper to the 'Util' directory and write some tests

if nargin < 2
	fun = @escaped_str;
end

%--
% check for struct input and vectorize
%--

if ~isstruct(in)
	error('Input must be struct.'); 
end

in = in(:)';

%-------------------
% CONVERT STRUCT
%-------------------

%--
% build a value line for each element of the struct array
%--

values = struct2cell(in);

lines = cell(size(values, 3), 1);

for k = 1:length(lines)
	lines{k} = str_implode(values(:, :, k), ', ', fun);
end

%--
% compute the header from fieldnames if needed
%--

if (nargout > 1) || ~nargout
	header = str_implode(fieldnames(in), ', ');
end

%-------------------
% DISPLAY TEMP
%-------------------

if ~nargout
	
	out = [tempname, '.csv'];
	
	file_writelines(out, {header, lines{:}});
	
    if (ispc)
        winopen(out);
    end
    if (ismac)
        system(['open ', out]);
    end
	
end


function str = escaped_str(value)

% TODO: consider using another separator, perhaps semi-colon

str = to_str(value);

str = strrep(str, ',', ' -');
