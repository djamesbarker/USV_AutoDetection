function obj = cellfree(obj)

% cellfree - extract scalar something from a cell container
% ---------------------------------------------------------
%
% obj = cellfree(obj)
%
% Input:
% ------
%  obj - to free
%
% Output:
% -------
%  obj - freed from cell

if iscell(obj) && numel(obj) == 1
	obj = obj{1};
end
