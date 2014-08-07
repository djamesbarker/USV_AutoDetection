function Z = struct_merge(X, Y, opt)

% struct_merge - merge scalar structs
% -----------------------------------
%
%   Z = struct_merge(X, Y, opt)
%
% opt = struct_merge
%
% Input:
% ------
%  X - source struct
%  Y - source struct
%  opt - merge options
%
% Output:
% -------
%  Z - merged struct
%  opt - default merge options

% TODO: extend to merge any number of structures, the current function will be recursively called

%------------------
% HANDLE INPUT
%------------------

%--
% set default options and possibly output
%--

if nargin < 3
	opt.flatten = 1; opt.level = -1; opt.sort = 0; opt.unique = 1;
end

if ~nargin
	Z = opt; return;
end

%--
% check for struct input
%--

if ~is_scalar_struct(X) || ~is_scalar_struct(Y)
	error('Scalar struct inputs are required for merge.'); 
end

%------------------
% MERGE STRUCTS
%------------------

%--
% flatten if needed
%--

if opt.flatten
	X = flatten_struct(X, opt.level); Y = flatten_struct(Y, opt.level);
end

%--
% get and sort fields if needed
%--

Xf = fieldnames(X); Yf = fieldnames(Y); 

if opt.unique && ~isempty(intersect(Xf, Yf))
	error('Fields from structs to merge must be unique.');
end 

% NOTE: 'fieldnames' outputs a column vector, hence the columnar concatenation

field = {Xf{:}, Yf{:}}; source = [ones(size(Xf)); zeros(size(Yf))];

% NOTE: if we sort the the 'field' array, we sort the 'source' array along with it

if opt.sort
	[field, p] = sort(field); source = source(p);
end

%--
% create merged struct
%--

Z = struct;

% TODO: there should be a nicer way of doing this

for k = 1:length(field)
	
	if source(k)
		Z.(field{k}) = X.(field{k});
	else
		Z.(field{k}) = Y.(field{k});
	end
	
end

%--
% collapse if needed
%--

if opt.flatten
	Z = unflatten_struct(Z);
end
