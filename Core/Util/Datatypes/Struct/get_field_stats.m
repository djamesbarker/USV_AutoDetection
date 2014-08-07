function stats = get_field_stats(value, skip, opt)

% get_field_stats - get stats for struct fields with multiple values
% ------------------------------------------------------------------
%
% stats = get_field_stats(value, skip, opt)
%
% Input:
% ------
%  value - struct with fields containing multiple values
%  skip - fields to skip
%
% Output:
% -------
%  stats - stats packed as input struct

% TODO: determine how this function relates to 'iterate_struct'

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% set default options
%--

if nargin < 3
	
	% TODO: some of these functions depend of the 'statistics toolbox', reconsider
	
	opt.fun = {@mean, @std, @min, @median, @mad, @max};
	
	if ~nargin
		stats = opt; return;
	end
	
end

%--
% set empty skip list
%--

if nargin < 2
	skip = {};
end

%-----------------------
% COMPUTE
%-----------------------

%--
% set statistical functions and get names
%--

fun = opt.fun; name = iterate(@func2str, fun);

%--
% flatten struct and compute field statistics
%--

value = flatten(value); field = fieldnames(value); stats = struct;

for k = 1:numel(field)
	
	%--
	% check field name against skip list
	%--
	
	% TODO: improve 'skip' list handling to consider partial match, this is a little function
	
	% NOTE: skip computation for fields in 'skip' list
	
	if string_is_member(field{k}, skip), continue; end
	
	%--
	% get field content
	%--
	
	content = value.(field{k});
	
	% NOTE: we skip scalar content, not much statistics can illuminate here
	
	% TODO: consider passing as 'value' field
	
	if numel(content) == 1
		continue; 
	end
	
	% TODO: consider the shape of the value field when applying the statistical function, currently we vectorize all values
	
	content = vec(content);
	
	for j = 1:numel(fun)
		stats.(field{k}).(name{j}) = fun{j}(content);
	end
	
end

%--
% collapse output struct to match initial value struct
%--

stats = collapse(stats);
