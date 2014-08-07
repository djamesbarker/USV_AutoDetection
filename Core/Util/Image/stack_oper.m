function Y = stack_oper(X1,X2,t)

% stack_oper - unary and binary operations on stacks
% --------------------------------------------------
%
% Y = stack_oper(X1,X2,t)
%   = stack_oper(X,t)
%
% Input:
% ------
%  X1,X2 - image stacks or stack and image
%  X - image stack
%  t - type of operation
%
% Output:
% -------
%  X - image stack or image

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

%--
% check size of stacks
%--

switch (nargin)

	%--
	% single stack
	%--
	
	case (2)
	
		t = X2;
		if (~isstr(t))
			error('Operator must be provided as string.');
		end
	
	%--
	% two stacks
	%--
	
	case (3)
	
		if (~isstr(t))
			error('Operator must be provided as string.');
		end
		
		f1 = is_stack(X1);
		f2 = is_stack(X2);
		
		switch (f1 + f2)
		
		%--
		% stack and image
		%--
		
		case (1)
			
			if (f1)
				if (any(size(X1{1}) ~= size(X2)))
					error('Image and image stack are not of compatible sizes.');
				else
					X2 = arg_to_cell(X2,size(X1));
				end
			else
				if (any(size(X2{1}) ~= size(X1)))
					error('Image and image stack are not of compatible sizes.');
				else
					X1 = arg_to_cell(X1,size(X2));
				end
			end
			
		%--
		% two stacks
		%--
		
		case (2)
			
			if (length(X1) ~= length(X2))
				error('Image stacks are not of the same length.');
			end
			
		%--
		% no stacks
		%--
		
		otherwise
			
			error('At least one of the inputs should be an image stack.');
			
		end
		
end

n = length(X1);

%--
% compute stack operations
%--

switch (nargin)

%--
% unary stack operators
%--

case (2)

	switch (t)
	
	% addition, binary reduction
	
	case {'+'}
		
		Y = zeros(size(X1{1}));
		for k = 1:n
			Y = Y + X1{k};
		end
	
	% pointwise product, binary reduction
	
	case {'.*'}
		
		Y = zeros(size(X1{1}));
		for k = 1:n
			Y = Y .* X1{k};
		end
		
	% minus, unary
	
	case {'-'}
		
		Y = cell(size(X1));
		for k = 1:n
			Y{k} = -X1{k};
		end
		
	% pointwise division, unary
	
	case {'./'}
		Y = cell(size(X1));
		for k = 1:n
			Y{k} = 1./X1{k};
		end
		
	% pointwise min, binary reduction
	
	case ('min')
		
		Y = X1{1};
		for k = 2:n
			Y = min(Y,X1{k});
		end
		
	% pointwise max, binary reduction
	
	case ('max')
		
		Y = X1{1};
		for k = 2:n
			Y = max(Y,X1{k});
		end
		
	% attempt unary
	
	otherwise
		
		Y = cell(size(X1));
		for k = 1:n
			Y{k} = eval([t '(X1{k})']);
		end
		
	end
						
%--
% two stack operations
%--

case (3)
	
	switch (t)

	% addition, binary
	
	case {'+'}
		
		Y = cell(size(X1));
		for k = 1:n
			Y{k} = X1{k} + X2{k};
		end
	
	% pointwise product, binary
	
	case {'.*'}
		
		Y = cell(size(X1));
		for k = 1:n
			Y{k} = X1{k} .* X2{k};
		end
		
	% minus, binary
	
	case {'-'}
		
		Y = cell(size(X1));
		for k = 1:n
			Y{k} = X1{k} - X2{k};
		end
		
	% pointwise division, binary
	
	case {'./'}
		
		Y = cell(size(X1));
		for k = 1:n
			Y{k} = X1{k} ./ X2{k};
		end
		
	% pointwise min, binary
	
	case ('min')
		
		Y = cell(size(X1));
		for k = 1:n
			Y{k} = min(X1{k},X2{k});
		end
		
	% pointwise max, binary
	
	case ('max')
		
		Y = cell(size(X1));
		for k = 1:n
			Y{k} = max(X1{k},X2{k});
		end
		
	% attempt binary (works for relational operators)
	
	otherwise
		
		Y = cell(size(X1));
		for k = 1:n
			Y{k} = eval(['X1{k}' 't' 'X2{k}']);
		end
			
	end
			
end



