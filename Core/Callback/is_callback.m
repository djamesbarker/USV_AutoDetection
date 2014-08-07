function [value, type] = is_callback(callback)

% is_callback - test input is callback and if so get type
% -------------------------------------------------------
%
% [value, type] = is_callback(callback)
%
% Input:
% ------
%  callback - proposed callback
%
% Output:
% -------
%  value - callback indicator
%  type - callback type

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
% set failure default values
%--

value = 0; type = '';

%--
% evaluate callback input
%--

switch class(callback)
	
	%--
	% string callback
	%--
	
	case 'char', value = 1; type = 'string';
		
	%--
	% simple callback
	%--
	
	case 'function_handle', value = 1; type = 'simple';
		
	%--
	% complex callbacks
	%--
	
	case 'cell'
		
		%--
		% parametrized callback
		%--
		
		value = is_parametrized_callback(callback);
		
		if value
			
			type = 'parametrized';
		
		else
			
			%--
			% callback chain
			%--
			
			for k = 1:length(callback)
				value(k) = is_callback(callback{k});
			end

			value = all(value);
			
			if value
				type = 'chain';
			end
		
		end
		
end


%---------------------------------------
% IS_PARAMETRIZED_CALLBACK
%---------------------------------------

function value = is_parametrized_callback(callback)

% NOTE: a paremetrized callback contains a function handle and arguments

if length(callback) < 2
	value = 0; return;
end

if ~isa(callback{1}, 'function_handle')
	value = 0; return;
end

value = 1;
