function skel = form_to_skel(form)

% form_to_skel - get form skeleton
% --------------------------------
%
% skel = form_to_skel(form)
%
% Input:
% ------
%  form - form 
%
% Output:
% -------
%  skel - skeleton

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
% HANDLE COMPOSITE TYPES RECURSIVELY
%------------------------------------------

%--
% handle cell arrays
%--

if (iscell(form))
	
	skel = cell(size(form));
	
	for k = 1:numel(form)
		skel{k} = form_to_skel(form{k});
	end
	
	return;
	
end

%--
% handle structures
%--

if (isstruct(form))
	
	% NOTE: we only allow scalar structures
	
	if (length(form) > 1)
		error('Only scalar structures are supported.');
	end
	
	names = fieldnames(form);
	
	if (isempty(find(strcmp(names,'numel'))))
		for k = 1:length(names)
			skel.(names{k}) = form_to_skel(form.(names{k}));
		end
	else
		skel.numel = form.numel;
	end
	
	return;
	
end
