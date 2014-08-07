function out = aggregate(in, collapse)

% aggregate - collect the elements of a cell array of cell arrays
% ---------------------------------------------------------------
%
% out = aggregate(in, collapse)
%
% Input:
% ------
%  in - cell array of cell arrays
%  collapse - through unique
%
% Output:
% -------
%  out - elements of cells from initial cell array, perhaps unique

%--
% set no collapse default
%--

if nargin < 2
	collapse = 0;
end

%--
% check for empty or cell of cell condition
%--

if isempty(in)
	out = in; return; 
end

if any(~iterate(@iscell, in))
	error('We can only aggregate cell arrays of cell arrays.');
end

%--
% aggregate
%--

out = in{1};

for k = 2:numel(in)
	out = {out{:}, in{k}{:}};
end

%--
% collapse aggregate
%--

if collapse
	out = unique(out); 
end
