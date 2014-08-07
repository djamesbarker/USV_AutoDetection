function out = squeeze(in, flat)

% squeeze - remove empty fields from struct

if nargin < 2
	flat = 0;
end

if flat
	in = flatten(in);
end 

field = fieldnames(in);

out = struct;

for k = 1:length(field)
	if ~isempty(in.(field{k}))
		out.(field{k}) = in.(field{k});
	end 
end

if flat
	out = unflatten(out);
end
