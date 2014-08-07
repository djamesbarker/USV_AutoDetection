function [in, select] = struct_select(in, field, value) 

% struct_select - select elements of struct array by field value
% --------------------------------------------------------------
%
% [out, select] = struct_select(in, field, value)
%
% Input:
% ------
%  in - struct array
%  field - field to select on
%  value - value to select
%
% Output:
% -------
%  out - selected elements of array
%  select - selection indicator

% TODO: update to have a variable list of field-value pairs as input

%----------------------
% HANDLE INPUT
%----------------------

%--
% check struct and field
%--

if ~isstruct(in)
	error('Selection target must be struct.');
end

if ~isfield(in, field)
	error('Selection field is not page field.');
end 

% NOTE: there is nothing to select, this is odd!

if isempty(in)
	select = []; return;
end

%--
% get relevant field values from in
%--

% NOTE: we assume that the field contents are uniform, this is not known

if ischar(in(1).(field))
	values = {in.(field)};
else
	try
		values = [in.(field)];
	catch
		values = {in.(field)};
	end
end 

%--
% compare values to input field value to select
%--

if isnumeric(values)
	select = (values == value);
end

if iscellstr(values)
	select = strcmp(values, value);
end 

if exist('select', 'var')
	in = in(select); return;
end

select = zeros(size(values));

for k = length(values):-1:1
	
	if ~isequal(values{k}, value)
		in(k) = [];
	else
		select(k) = 1;
	end 
	
end 

