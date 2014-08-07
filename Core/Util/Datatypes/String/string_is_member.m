function [value, ix] = string_is_member(str, member, insensitive)

% string_is_member - check whether string inputs are members of string set
% ------------------------------------------------------------------------
%
% [value, ix] = string_is_member(str, member, insensitive)
%
% Input:
% ------
%  str - candidates
%  member - strings
%  insensitive - to case indicator
%
% Output:
% -------
%  value - membership indicator
%  ix - index of first occurence in strings set array

% TODO: the index must be zero when we don't find something so that we can 'iterate' over the function

%--
% set case default
%--

if nargin < 3
	insensitive = 0;
end

%--
% handle multiple inputs recursively
%--

% NOTE: we assume that cell input is a string cell array for speed

if iscell(str)
	% NOTE: this handles the common special case of an empty cell input
	
	if isempty(str)
		value = []; ix = []; return;
	end
	
	[value, ix] = iterate(mfilename, str, member, insensitive); return;
end

%--
% check set is not empty
%--

% TODO: consider using zero index to indicate the non-member position rather than empty

if isempty(member)
	value = false; ix = nan; return;
end

%--
% check membership of string
%--

if insensitive
	ix = find(strcmpi(str, member), 1);
else
	ix = find(strcmp(str, member), 1);
end

if isempty(ix)
	value = false; ix = 0;
else
	value = true; ix = ix(1);
end


