function [value, flag] = get_field(in, field, default)

% get_field - get field from structure
% ------------------------------------
%
% [value, flag] = get_field(in, field, default)
%
% Input:
% ------
%  in - structure to extract from
%  field - field extraction string
%  default - default if extraction fails
%
% Output:
% -------
%  value - result value
%  flag - default indicator

%--
% handle input
%--

if ~isstruct(in) || numel(in) ~= 1
	error('Input must be scalar struct.');
end 
	
%--
% get field
%--

% NOTE: we allow a small amount of duplication to allow skipping try

if nargin < 3

	value = extract_field(in, field); flag = 0;

else

	% get field with default
	
	try
		value = extract_field(in, field); flag = 0;
	catch
		value = default; flag = 1;
	end

end


%--------------------------------
% EXTRACT_FIELD
%--------------------------------

function value = extract_field(in, field)

% NOTE: we do this to handle typical flattened struct names gracefully

if any(field == '_')
	field = strrep(field, '__', '.');
end

% NOTE: we extract composite field using eval, and simple fields directly

if any(field == '.')
	value = eval(['in.', field]);
else
	value = in.(field);
end
