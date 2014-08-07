function [value, field] = struct_pop(in)

% struct_pop - pop a single field struct
% --------------------------------------
%
% [value, field] = struct_pop(in)
%
% Input:
% ------
%  in - scalar single field struct
%
% Output:
% -------
%  value - field value
%  field - field name

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2196 $
% $Date: 2005-12-02 18:16:46 -0500 (Fri, 02 Dec 2005) $
%--------------------------------

%-------------------
% HANDLE INPUT
%-------------------

%--
% check for scalar struct
%--

if ~isstruct(in)
	error('Input must be struct.');
end

if length(in) > 1
	error('Input must be scalar struct.');
end

%--
% check for single field
%--

field = fieldnames(in);

if length(field) > 1
	error('Struct to pop must have a single field.');
end

%-------------------
% POP STRUCT FIELD
%-------------------

field = field{1}; value = in.(field);

