function out = struct_empty(in)

% struct_empty - empty fields of scalar struct
% --------------------------------------------
%
% out = struct_empty(in)
%
% Input:
% ------
%  in - scalar struct
%
% Output:
% -------
%  out - scalar struct with empty fields

fields = fieldnames(flatten_struct(in));

args = cell(2, length(fields)); args(1,:) = fields;

out = unflatten_struct(struct(args{:}));
