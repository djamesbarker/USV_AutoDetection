function [in, flag, failed] = set_field(in, varargin)

% set_field - set structure field
% -------------------------------
%
% [value, flag, failed] = set_field(in, 'field', value,  ... , 'field', value)
%
% Input:
% ------
%  in - structure to extract from
%  field - field name
%  value - field value
%
% Output:
% -------
%  in - result struct
%  flag - failure indicator
%  failed - failed fields

%--
% get field value pairs
%--

[field, value] = get_field_value(varargin);

%--
% set fields to values
%--

failed = cell(0);

for k = 1:length(field)
	
	[in, flag] = inject_field(in, field{k}, value{k});
	
	if (flag)
		failed{end + 1} = field{k};
	end
	
end

%--
% flag number of failures
%--

flag = length(failed);


%--------------------------------
% INJECT_FIELD
%--------------------------------

function [in, flag] = inject_field(in, field, value)

% inject_field - set value of existing structure field
% ----------------------------------------------------
%
% [in, flag] = inject_field(in, field, value)
%
% Input:
% ------
%  in - input struct
%  field - field set string
%  value - field value to set
%
% Output:
% -------
%  in - possibly modified structure
%  flag - failure indicator

% NOTE: we will not be injecting unavailable fields

%--
% inject field
%--

if any(field == '.')
	
	%--
	% return if there is no field to set
	%--
	
	var = ['in.', field];
	
	try
		eval([var, ';']);
	catch
		flag = 1; return;
	end

	%--
	% inject field
	%--

	eval([var, ' = value;']); flag = 0;
	
%--
% set field
%--

else
	
	%--
	% return if there is no field to set
	%--
	
	if ~isfield(in, field)
		flag = 1; return;
	end

	%--
	% set field
	%--
	
	in.(field) = value; flag = 0;
	
end
