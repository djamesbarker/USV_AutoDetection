function [value, occurs, match] = string_contains(str, pat, sensitive)

% string_contains - indicate if string contains pattern
% -----------------------------------------------------
%
% value = string_contains(str, pat, sensitive)
%
% Input:
% ------
%  str - string or string cell array
%  pat - pattern
%  sensitive - indicator (def: true)
%
% Output:
% -------
%  value - indicator
%
% See also: string_begins, string_ends

%--
% by default we are sensitive
%--

if nargin < 3
	sensitive = true;
end

%--
% handle multiple strings
%--

% NOTE: the test here should be 'iscellstr' however it is relatively
% costly and rarely useful, you might as well through an error. The same is
% true for the multiple pattern test below.

if iscell(str)
	value = false(size(str)); occurs = cell(size(str)); match = cell(size(str));
	
	for k = 1:numel(str)
		[value(k), occurs{k}, match{k}] = string_contains(str{k}, pat, sensitive);
	end
	
	return;
	
% 	[value, occurs, match] = iterate(mfilename, str, pat, sensitive); 
end

%--
% check for occurence of pattern and indicate
%--

% NOTE: this is not efficient when iterating

if ~sensitive
	str = lower(str); pat = lower(pat);
end

% NOTE: the transpose is a trick that fixes the packing of the iteration

if iscell(pat)

	for k = 1:numel(pat)
		occurs = strfind(str, pat{k})'; value = ~isempty(occurs);
		
		if value
			match = k; return;
		end
	end
	
	occurs = 0; value = false; match = 0; 

else
	occurs = strfind(str, pat)'; value = ~isempty(occurs);
	
	if value
		match = 1;
	else 
		match = 0; occurs = 0;
	end
end

