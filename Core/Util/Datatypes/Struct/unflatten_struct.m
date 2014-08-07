function out = unflatten_struct(in, sep) %#ok<STOUT>

% unflatten_struct - unflatten struture
% -------------------------------------
%
% out = unflatten_struct(in, sep)
%
% Input:
% ------
%  in - flattened struct
%  sep - field separator (def: '__', double underscore)
%
% Output:
% -------
%  out - unflattened struct
%
% See also: flatten_struct, collapse

%--
% handle input
%--

if nargin < 2
	sep = '__';
end

if ~isstruct(in)
	error('Struct input is required.');
end

if length(in) ~= 1
	error('Scalar struct input is required.');
end

%--
% collapse struct
%--

out = collapse(in, sep);

