function [in, ix] = filter_struct(in, varargin)

% filter_struct - array based on field value conditions
% -----------------------------------------------------
% 
% [out, ix] = filter_struct(in, field, value, ... )
%
% Input:
% ------
%  in - input struct array
%  field - name
%  value - to match field or indicator callback
%
% Output:
% -------
%  out - filtered struct array
%  ix - selected indices
%
% NOTE: the output is always a struct vector array
%
% See also: find_struct

%--
% find matching struct elements, filter if needed
%--

ix = find_struct(in, varargin{:});

if numel(ix) < numel(in)
	in = in(ix);
end
