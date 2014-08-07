function Y = set_form(X, form, opt)

% set_form - set form of input
% ----------------------------
%
% Y = set_form(X, form, opt)
%
% Input:
% ------
%  X - input object
%  form - form 
%  opt - value copy option (def: 0)
%
% Output:
% -------
%  Y - output object with imposed form

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

% TODO: develop policies, modes for value copy, think 'struct_merge' and 'struct_extract'

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

%--
% return same if no form
%--

% NOTE: consider a warning here

if (nargin < 2) || isempty(form)
	Y = X; return;
end

%--
% set default copy value option
%--

if (nargin < 3) || isempty(opt)
	opt = 0;
end

%------------------------------------------
% SET FORM
%------------------------------------------

%--
% check that input and form skeletons match
%--

skel = get_skel(X);

form_skel = form_to_skel(form);

% NOTE: a more economical way would be to have a custom comparison function

if ~isequal(skel, form_skel)
	error('We can''t set to desired form, skeletons don''t match.');
end

%--
% set form using helper
%--

Y = set_form_helper(X, form, opt);


%------------------------------------------
% SET_FORM_HELPER
%------------------------------------------

function Y = set_form_helper(X, form, opt)

%------------------------------------------
% HANDLE COMPOSITE TYPES RECURSIVELY
%------------------------------------------

%--
% handle cell arrays
%--

if iscell(X)
	
	form = cell(size(X));
	
	for k = 1:numel(X)
		Y{k} = set_form_helper(X{k}, form{k}, opt);
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
		Y.(names{k}) = set_form_helper(X.(names{k}), form.(names{k}), opt);
	end
	
	return;
	
end

%------------------------------------------
% HANDLE SIMPLE TYPES
%------------------------------------------

%--
% cast input if possible
%--

[types, fun] = get_cast_types;

ix = find(strcmp(form.class, types));

if ~isempty(ix)
	Y = fun{ix}(X);
end

%--
% reshape input, this is possible because of skeleton check
%--

Y = reshape(Y, form.size);

