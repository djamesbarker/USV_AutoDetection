function result = eval_callback(callback, varargin)

% eval_callback - evaluate callback
% ---------------------------------
%
% result = eval_callback(callback, varargin)
%
% Input:
% ------
%  callback - callback
%  varargin - call arguments
%
% Output:
% -------
%  result - callback result

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

% TODO: consider result structure and add some profiling

%--
% check for empty callback
%--

result = [];

if isempty(callback)
	return;
end

%--
% check callback input
%--

[value, type] = is_callback(callback);

if ~value
	error('Callback input is not callback.');
end

%--
% evaluate callback based on type
%--

switch (type)
	
	case 'string'
		
		eval(callback); return;
		
	case 'chain'

		for k = 1:length(callback)
			result(k) = eval_callback(callback{k}, varargin{:});
		end
		
		return;
		
	case 'simple'
		
		fun = callback; args = varargin;
		
	case 'parametrized'
		
		fun = callback{1}; parameters = callback(2:end); args = {varargin{:}, parameters{:}};
	
end

% NOTE: this section evaluates 'simple' and 'parametrized' callbacks

switch nargout(fun)
	
	case 0
		result = []; fun(args{:});

	case 1
		result = fun(args{:});
		
	otherwise
		error('Callback functions must have at most a single output.');
		
end

