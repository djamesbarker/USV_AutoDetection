function p = struct_edit(p,str)

% struct_edit - edit simple flat structure values
% -----------------------------------------------
%
% p = struct_edit(p,str)
%
% Input:
% ------
%  p - input structure
%  str - title string
%
% Output:
% -------
%  p - output structure

%--
% set title string
%--

if ((nargin < 2) & ~isempty(inputname(1)))
	str = ['Edit ' inputname(1) ' ...'];
elseif (isempty(inputname(1)))
	str = 'Struct Edit ...';
end

%--
% get field named and create prompts
%--

field = fieldnames(p);

for k = 1:length(field)
	prompt{k} = string_title(field{k},'_');
end 

%--
% create default answers
%--

for k = 1:length(field)
	tmp = getfield(p,field{k});
	if (isstr(tmp))
		def{k} = tmp;
	elseif (length(tmp) == 1)
		def{k} = num2str(tmp);
	else
		def{k} = mat2str(tmp);
	end 
end

%--
% create input dialog and get answers
%--

ans = input_dialog( ...
	prompt, ...
	str, ...
	[1,32], ...
	def ...
);

%--
% update structure if needed
%--

if (~isempty(ans))
	for k = 1:length(field)
		p = setfield(p,field{k},eval(ans{k}));
	end
else
	p = [];
end
