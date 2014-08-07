function [out, info] = struct_to_matrix(in, opt)

% struct_to_matrix - extract numeric matrix from struct 
% -----------------------------------------------------
%
% [out, info] = struct_to_matrix(in, opt)
%
% Input:
% ------
%  in - struct
%
% Output:
% -------
%  out - matrix
%  info - about extraction

%--
% handle input
%--

if nargin < 2
	opt.flatten = 1;
	
	if ~nargin
		out = opt; return;
	end
end

% NOTE: when we flatten, we put the struct array into a column and flatten fields

if opt.flatten
	in = iterate(@flatten, in(:));
	
	if iscell(in)
		error('Input struct array is not uniform when flattened.');
	end
end

%--
% convert struct to matrix
%--

info.in_fields = fieldnames(in); info.rejected = [];

out = struct2cell(in)';

% NOTE: here we try to convert a cell array into a matrix, on failure we remove non-numeric columns and try again

try
	
	out = cell2mat(out);
	
catch %#ok<CTCH>
	
	% NOTE: we reject non-numeric and empty columns to achieve matrix output
	
	for k = numel(info.in_fields):-1:1
		
		column = [out{:, k}];

		if isnumeric(column) && (numel(column) == numel(in))
			continue;
		end

		info.rejected(end + 1) = k; out(:, k) = [];
	end
	
	out = cell2mat(out);
	
	info.out_fields = info.in_fields; info.out_fields(info.rejected) = [];

end
