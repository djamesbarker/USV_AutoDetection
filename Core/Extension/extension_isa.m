function value = extension_isa(ext, type)

% extension_isa - test whether extension is of a type
% ---------------------------------------------------
%
% value = extension_isa(ext, type)
%
% Input:
% ------
%  ext - extension
%  type - type
%
% Output:
% -------
%  value - type indicator

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
% handle input
%--

if nargin < 2
	error('Extension type input is required.');
end

if ~is_extension_type(type)
	error('Unrecognized extension type.');
end

%--
% handle multiple extensions recursively
%--

if numel(ext) > 1
	
	value = zeros(size(ext));
	
	for k = 1:numel(ext)
		value(k) = extension_isa(ext(k));
	end
	
	return;
	
end

%--
% check extension is of type 
%--

% NOTE: there is a thin check for being an extension here

value = isstruct(ext) && isfield(ext, 'subtype') && strcmp(ext.subtype, type);
