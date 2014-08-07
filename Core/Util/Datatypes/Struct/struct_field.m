function Y = struct_field(X, varargin)

% struct_field - get field array from structure array
% ---------------------------------------------------
%
% Y = struct_field(X, field_1, ..., field_n);
%
% Input:
% ------
%  X - structure array
%  field_k - field to extract
% 
% Output:
% -------
%  Y - field array or structure containing field arrays

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 946 $
% $Date: 2005-04-19 15:05:48 -0400 (Tue, 19 Apr 2005) $
%--------------------------------

% TODO: take advantage of comma-separated lists to handle field extraction

% NOTE: the above todo is particularly relevant for fields containing cells

%--
% check for non-empty struct input
%--

if ~isstruct(X)
	error('Input type is not structure.');
end

if isempty(X)
	Y = []; return;
end

%--
% set fields
%--

if isempty(varargin)
	
	%--
	% extract all fields if no field input is provided
	%--
	
	field = fieldnames(X);
	
else
	
	%--
	% check fields exis
	%--
	
	field = varargin;
	
	for k = 1:length(field)
		
		if ~isfield(X, field{k})
			field(k) = [];
		end
		
	end

	%--
	% return if there are no remaining fields requested
	%--
	
	if isempty(field)
		Y = []; return;
	end
	
end

%--
% check for scalar structures
%--

% TODO: the following code has not been tested

% NOTE: this function is used extensively, updates are dangerous

% if (length(X) == 1)
% 
% 	% NOTE: for consistency strings are output as cell arrays
% 	
% 	if (length(field) > 1)
% 
% 		for k = 1:length(field)
% 			
% 			if (isstr(X.(field{k})))
% 				Y.(field{k}) = {X.(field{k})};
% 			else
% 				Y.(field{k}) = X.(field{k});
% 			end
% 			
% 		end
% 		
% 	else
% 
% 		%--
% 		% single fields are output as arrays not structures
% 		%--
% 		
% 		if (isstr(X.(field{1})))
% 			Y = {X.(field{1})};
% 		else
% 			Y = X.(field{1});
% 		end
% 		
% 	end
% 
% 	return;
% 	
% end

%--
% mex extraction of structure fields
%--

% if (1)
	
	%--
	% get index of field to extract
	%--
	
	names = fieldnames(X);
	
	ix = zeros(1, length(field));
	
	for k = 1:length(field)
		ix(k) = find(strcmp(names, field{k}));
	end

	%--
	% extract fields
	%--
	
	Y = struct_field_(X, ix);
	
	%--
	% output simple array rather than structure when only one field was
	% requested
	%--
	
	if (length(field) == 1)
		Y = Y.(field{1});
	end
	
	%--
	% convert cell array of structures into structure array if possible
	%--
	
	% this behavior leads to different results when extracting structure
	% fields maybe all such fields should simply be output as a cell array
	
% 	if (iscell(Y) & isstruct(Y{1}))
% 		
% 		tmp = Y;
% 		clear Y;
% 		
% 		% check that all structures are scalar
% 		
% 		flag = 0;
% 		
% 		for k = 1:length(tmp)
% 			if (length(tmp{k}) ~= 1)
% 				flag = 1;
% 				break;
% 			end
% 		end
% 		
% 		% if all structures are scalar then put into structure array
% 		
% 		if (~flag)
% 			for k = 1:length(tmp)
% 				Y(k, 1) = tmp{k};
% 			end
% 		else
% 			Y = tmp;
% 		end
% 		
% 	end
			
% %--
% % matlab extraction of structure fields
% %--
% 
% else
% 	
% 	%--
% 	% extract string field from array
% 	%--
% 
% 	if (isstr(get_field(X(1), field)))
% 		
% 		if (length(X) > 1)
% 			
% 			Y = cell(size(X));
% 			
% 			for k = 1:prod(size(X))
% 				Y{k} = get_field(X, {k}, field);
% 			end
% 			
% 		else
% 			
% 			Y{1} = get_field(X, field);
% 			
% 		end
% 		
% 	%--
% 	% extract double or complex field
% 	%--
% 	
% 	else
% 			
% 		%--
% 		% handle rows and columns
% 		%--
% 		
% 		[m, n] = size(get_field(X, {1}, field));
% 		
% 		if (min(m, n) > 1)
% 			
% 			% this is not a restriction in the mex version, it should be
% 			% removed here as well
% 			
% 			disp(' ');
% 			error('Double field data is neither rows or columns.');
% 			
% 		else
% 			
% 			Y = zeros(prod(size(X)), n);
% 			
% 			if (m == 1)
% 				for k = 1:prod(size(X))
% 					Y(k, :) = get_field(X, {k}, field);
% 				end			
% 			else
% 				for k = 1:prod(size(X))
% 					Y(k, :) = get_field(X, {k}, field).'; % note the non-conjugate transpose
% 				end
% 			end
% 			
% 		end
% 		
% 	end
% 	
% end
