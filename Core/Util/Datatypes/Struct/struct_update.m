function X = struct_update(X, Y, opt)

% struct_update - update a structure using another
% ------------------------------------------------
%
% opt = struct_update
%
%   X = struct_update(X, Y, opt)
%
% Input:
% ------
%  X - structure to update
%  Y - source structure
%  opt - update options structure
%
% Output:
% -------
%  opt - default update options structure
%  X - updated structure

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% set and possibly return default options
%--

if (nargin < 3) || isempty(opt)
	
	%--
	% set default options
	%--
	
	opt.equal = 0; % NOTE: require structures to be equal
	
	opt.flatten = 1; % NOTE: flatten structures to perform update
	
	opt.level = -1;
	
	%--
	% output options if needed
	%--
	
	if ~nargin
		X = opt; return;
	end 
	
end 

if ~isfield(opt, 'level')
	opt.level = -1;
end

%--
% return if the update source is empty
%--

% NOTE: this really happens

if isempty(Y)
	return;
end 

%---------------------------
% UPDATE STRUCT
%---------------------------

%--
% flatten structures if needed
%--

if opt.flatten	
	X = flatten_struct(X, opt.level); Y = flatten_struct(Y, opt.level);
end

%--
% get fieldnames
%--

X_field = fieldnames(X); Y_field = fieldnames(Y);

%--
% check for equal structures if needed
%--

if opt.equal
	
	% NOTE: equality is a check on contents and order, not a set operation
	
	% TODO: consider allowing order to be omitted
	
	if ~isequal(X_field, Y_field)
		
		if opt.flatten
			error('Flattened input structures have different forms.');
		else
			error('Input structures have different forms.');
		end
		
	end 
	
end

%--
% update structure fields
%--

% TODO: develop struct merge, and various modes for update

% NOTE: loop over shorter set of fields

% update = intersect(X_field, Y_field);
% 
% if isempty(update)
%     return; 
% end
% 
% for k = 1:numel(update)
%     X.(update{k}) = Y.(update{k});
% end

if length(X_field) < length(Y_field)
	
	for k = 1:length(X_field)

		match = find(strcmp(Y_field, X_field{k}), 1);
		
		if ~isempty(match)
			X.(X_field{k}) = Y.(X_field{k});
		end

	end
	
else
	
	for k = 1:length(Y_field)

		match = find(strcmp(X_field, Y_field{k}), 1);
		
		if ~isempty(match)
			X.(Y_field{k}) = Y.(Y_field{k});
		end

	end
	
end

%--
% unflatten structures if needed
%--

if opt.flatten
	X = unflatten_struct(X);
end
