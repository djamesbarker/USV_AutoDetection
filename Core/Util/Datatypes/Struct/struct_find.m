function ix = struct_find(X, varargin)

% struct_find - find structures in a struct array
% -----------------------------------------------
% 
% ix = struct_find(X, field, value, ... )
%
% Input:
% ------
%  X - structure array
%  field - name
%  value - or range for field
%
% Output:
% -------
%  ix - indices of selected elements
% 
% See also: struct_filter

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% check for struct input
%--

if ~isstruct(X)
	error('Input type is not structure.');
end

N = numel(X);

%--
% handle varargin
%--

% check length

n = length(varargin);

if mod(n,2)
	error('Incorrect number of field value pairs.');
end

n = n / 2;

% get field value pairs

for k = 1:n
	
	field{k} = varargin{2*k - 1}; value{k} = varargin{2*k};

end

%--
% check fields
%--

for k = 1:n
	
	if ~isfield(X, field{k})
		error('Structure does not contain desired field.');
	end
	
end

%---------------------------
% SETUP
%---------------------------

%--
% get input struct fieldnames, their index, and convert struct to cell
%--

F = fieldnames(X); m = length(F);

for k = 1:n
	
	for j = 1:m
	
		if strcmp(field{k}, F{j})
			field_ix(k) = j;
		end

	end
	
end

X = struct2cell(X);

%---------------------------
% PERFORM FIND
%---------------------------

%--
% select elements that match field value pairs
%--

ix = 1:N;

for k = 1:n
	
	%--
	% select single field
	%--
	
	V = X(field_ix(k), :, :);
	
	%--
	% perform value comparison
	%--
	
	% string valued field
	
	if ischar(V{1})
		
		ix_k = find(strcmp(V(:), value{k}));
	
	% double valued field
	
	else
		
		% interval selection
		
		if ischar(value{k})
			
			% get bounds and type of interval
			
			[b, t] = parse_interval(value{k});
			
			% select based on type of interval and bounds
			
			switch (t)
				
				case (0)
					tmp = cell2mat(V(:));
					ix_k = find((tmp > b(1)) & (tmp < b(2)));

				case (1)
					tmp = cell2mat(V(:));
					ix_k = find((tmp > b(1)) & (tmp <= b(2)));

				case (2)
					tmp = cell2mat(V(:));
					ix_k = find((tmp >= b(1)) & (tmp < b(2)));

				case (3)
					tmp = cell2mat(V(:));
					ix_k = find((tmp >= b(1)) & (tmp <= b(2)));
				
			end
		
		% point selection
		
		else
			
			ix_k = find(cell2mat(V(:)) == value{k});
			
		end
		
	end
	
	%--
	% accumulate selection information
	%--
	
	ix = intersect(ix, ix_k);
	
end
