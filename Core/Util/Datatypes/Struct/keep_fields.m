function [out, missing] = keep_fields(in, field)

% keep_fields - complement of removing fields
% -------------------------------------------
%
% [out, missing] = keep_fields(in, fields)
%
% Input:
% ------
%  in - struct
%  keep - field names
%
% Output:
% -------
%  out - result
%  missing - field names
%
% See also: remove_fields

%--
% check for missing fields
%--

if nargout > 1
	missing = setdiff(field, fieldnames(in));
end

%--
% remove other fields
%--

out = rmfield(in, setdiff(fieldnames(in), field));
