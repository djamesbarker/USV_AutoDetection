function [in, removed] = remove_fields(in, field)

% remove_fields - remove fields from struct
% -----------------------------------------
%
% [out, removed] = remove_fields(in, field)
%
% Input:
% ------
%  in - input struct
%  field - names to remove
%
% Output:
% -------
%  out - updated struct
%  removed - fields
%
% See also: keep_fields

%--
% put string field in cell
%--

if ischar(field)
	field = {field};
end

%--
% determine fields available for removal and remove
%--

for k = numel(field):-1:1
	if ~isfield(in, field{k}), field(k) = []; end
end

removed = field;

if isempty(removed) % NOTE: if there are no remaining fields to remove we have nothing to do
	return; 
end

in = rmfield(in, removed);
