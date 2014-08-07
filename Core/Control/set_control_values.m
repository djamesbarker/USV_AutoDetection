function failure = set_control_values(pal, values)

% set_control_values - set control values
% ---------------------------------------
% 
% failure = set_control_values(pal,values)
%
% Input:
% ------
%  pal - parent figure handle
%  values - values to update
%
% Output:
% -------
%  failure - controls that failed to update

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
% $Revision: 5180 $
% $Date: 2006-06-07 12:39:25 -0400 (Wed, 07 Jun 2006) $
%--------------------------------

% TODO: make this function robust in the style of the 'get_control_values'

% TODO: update to handle hierarchical structures

% TODO: perform onload callbacks

%--
% fieldnames are control names
%---

field = fieldnames(values);

j = 0;

for k = 1:length(field)
	
	%--
	% try to update control with given name
	%--
	
	g = control_update([], pal, field{k}, values.(field{k}));
	 
	%--
	% try to update axes
	%--
	
	% NOTE: this is not very efficient
	
	tmp1 = findobj(pal, 'type', 'uicontrol', 'tag', field{k});
	
	if ((length(tmp1) == 1) && strcmp(get(tmp1, 'style'), 'text'))
		tmp1 = [];
	end
	
	tmp2 = findobj(pal, 'type', 'axes', 'tag', field{k});
	
	if isempty(tmp1) && ~isempty(tmp2)	
		set(tmp2,'userdata',values.(field{k})); continue;	
	end
		
	%--
	% keep track of failures
	%--
	
	if isempty(g)
		
		%--
		% report failure
		%--
		
		j = j + 1;
		failure{j} = field{k};
		
	end
	
end

%--
% return failure in case of no failure
%--

if (j == 0) 
	failure = [];
end
