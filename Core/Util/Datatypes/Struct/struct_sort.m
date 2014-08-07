function [in, ix] = struct_sort(in, fields, modes)

% struct_sort - sort struct in various fields
% -------------------------------------------
%
% [out, ix] = struct_sort(in, fields, modes)
%
% Input:
% ------
%  in - input struct array
%  fields - fields to sort by
%  modes - sort modes
%
% Output:
% -------
%  out - sorted struct
%  ix - permutation indices

%---------------------
% HANDLE INPUT
%---------------------

%--
% check fields input
%--

if ischar(fields)
	fields = {fields};
end

if ~iscellstr(fields)
	error('Fields input must be a string o string cell array.');
end

for k = 1:length(fields)
	
	if ~isfield(in, fields{k})
		error(['Sort field ''', fields{k}, ''' is not available.']);
	end
	
end

%--
% set and check order
%--

if nargin < 3
	modes = ones(size(fields));
else
	if numel(fields) ~= numel(modes)
		error('Mismatch between fields and modes.');
	end 
end

%---------------------
% SORT
%---------------------

%--
% loop over sort fields
%--

for k = 1:length(fields)
	
	%--
	% get permutation indices for field sort
	%--
	
	% TODO: there should be a reasonable message when we can't sort a field
	
	try
		ix = sort_helper({in.(fields{k})}, modes(k));
	catch
		xml_disp(lasterror); continue;	
	end
	
	%--
	% sort struct
	%--
	
	in = in(ix);
	
end


%---------------------
% SORT_HELPER
%---------------------

function [ix, values] = sort_helper(values, mode)

%--
% align values 
%--

% NOTE: this also strings out dimensions

values = values(:);

%--
% sort strings
%--

if iscellstr(values)
			
	[values, ix] = sort(values);

	if mode <= 0
		ix = flipud(ix);
	end

%--
% sort others
%--

else

	if mode > 0
		mode = 'ascend';
	else
		mode = 'descend';
	end

	[values, ix] = sort(values, 1, mode);

end
