function form = get_form(X, opt, skel)

% get_form - get shape and class of input
% ---------------------------------------
%
% form = get_form(X, opt)
%
% Input:
% ------
%  X - input object
%  opt - keep value option (def: 0)
%
% Output:
% -------
%  form - object form

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
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1.7 $
% $Date: 2004-06-08 13:54:58-04 $
%--------------------------------

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

%--
% set skeleton default
%--

% NOTE: this functionality is not exposed here, but used in 'get_skel'

if (nargin < 3) || isempty(skel)
	skel = 0;
end

%--
% set value flag
%--

if (nargin < 2) || isempty(opt)
	opt = 0;
end

%------------------------------------------
% HANDLE COMPOSITE TYPES RECURSIVELY
%------------------------------------------

%--
% handle cell arrays
%--

if iscell(X)
	
	form = cell(size(X));
	
	for k = 1:numel(X)
		form{k} = get_form(X{k}, opt);
	end
	
	return;
	
end

%--
% handle structures
%--

if isstruct(X)
	
	% NOTE: we only allow scalar structures
	
	if (length(X) > 1)
		error('Only scalar structures are supported.');
	end
	
	names = fieldnames(X);
	
	for k = 1:length(names)
		form.(names{k}) = get_form(X.(names{k}), opt);
	end
	
	return;
	
end

%------------------------------------------
% HANDLE SIMPLE TYPES
%------------------------------------------

%--
% get class and size and possibly keep value
%--

if (skel)
	
	% NOTE: we call the number of elements the skeleton
	
	form.numel = numel(X);
	
else
	
	form.class = class(X);
	
	form.numel = numel(X);
	
	form.size = size(X);

	if opt
		form.value = X;
	end
	
end
