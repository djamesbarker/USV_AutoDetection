function [name, args, sig, out] = extension_signatures(type, main)

% extension_signatures - generate extension function declarations
% ---------------------------------------------------------------
%
% [name, args, sig, out] = extension_signatures(type)
%
% Input:
% ------
%  type - extension types
%
% Output:
% -------
%  name - function names
%  args - function arguments
%  sig - function declarations
%  out - statements to produce trivial output

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

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% normalize and check extension type
%--

type = type_norm(type);

%--------------------------------
% GET EXTENSION SIGNATURES
%--------------------------------

%--
% get function names and argument descriptions
%--

% NOTE: function names are computed from the structure of the type fun

% NOTE: input and output names are the type fun content

fun = flatten_struct(feval(type));

name = fieldnames(fun);

if (nargout < 2)
	return;
end

args = struct2cell(fun);

if (nargout < 3)
	return;
end

%--
% build function declarations using names and argument descriptions
%--
	
sig = cell(size(name));

for k = 1:length(name)

	if isempty(args{k})
		sig{k} = name{k}; continue;
	end

	% NOTE: if argument information is available it must contain output

	if isempty(args{k}{1})
		sig{k} = name{k};
	else
		sig{k} = [args_to_str(args{k}{1}, 'out'), ' = ', name{k}];
	end
	
	if (length(args{k}) > 1)
		sig{k} = [sig{k}, args_to_str(args{k}{2}, 'in')];
	end

	%--
	% generate trivial body for function
	%--

	out{k} = args_to_out(args{k});
	
end



%----------------------------------------------------------
% ARGS_TO_STR
%----------------------------------------------------------

function str = args_to_str(args, type)

%--
% return empty on empty
%--

str = '';

if isempty(args)
	return;
end

%--
% put arguments names into comma separated list
%--

for k = 1:(length(args) - 1)
	str = [str, args{k}, ', '];
end

str = [str, args{end}];

%--
% add brackets based on type of arguments
%--

switch type
	
	case 'out'
		if (length(args) > 1)
			str = ['[', str, ']'];
		end
		
	case 'in'
		str = ['(', str, ')'];
		
end


%----------------------------------------------------------
% ARGS_TO_OUT
%----------------------------------------------------------

function out = args_to_out(args)

%--
% get input and output
%--

input = args{2}; output = args{1};

%--
% return empty on empty output
%--

out = '';

if isempty(output)
	return;
end

%--
% state something for each output
%--

for k = 1:length(output)
	
	%--
	% pass through inputs that appear as outputs
	%--
	
	% NOTE: these should not be emptied without provocation
	
	if ismember(output{k}, input)
		continue;
	end
	
	%--
	% handle known output arguments
	%--
	
	switch output{k}
		
		%--
		% recognized objects
		%--
		
		% NOTE: this should develop as basic objects develop
		
		case 'event'
			
			part = 'event = empty(event_create)';
			
		case 'control'
			
			part = 'control = empty(control_create)';
			
		case {'opt', 'parameter', 'attribute', 'result', 'feature'}
			
			% NOTE: options and parameters are structs so they can be merged
			
			part = [output{k}, ' = struct'];
			
		%--
		% generic outputs
		%--
		
		otherwise

			% NOTE: the generic empty is the empty array
			
			part = [output{k}, ' = []'];

	end
	
	out = [out, part, '; '];
	
end

% NOTE: remove trailing space

if ~isempty(out)
	out(end) = []; 
end
