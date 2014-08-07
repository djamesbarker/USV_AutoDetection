function value = str2int(str, sep)

% str2int - complement of 'int2str'
% ---------------------------------
%
% value = str2int(str, sep)
%
% Input:
% ------
%  str - string
%  sep - separator
%
% Output:
% -------
%  value - parsed from string

%--
% try to infer separator without being too smart
%--

if nargin < 2
	
	if ~isempty(find(str == ',', 1))
		sep = ','
	else
		sep = '';
	end
	
end

value = sscanf(str, ['%d', sep]);
