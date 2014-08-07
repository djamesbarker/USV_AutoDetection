function tip = get_computed_tooltip(control, callback)

% get_computed_tooltip - compute control tooltip
% ----------------------------------------------
%
% tip = get_computed_tooltip(control, callback)
%
% Input:
% ------
%  control - control
%  callback - control callback
%
% Output:
% -------
%  tip - computed tooltip

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
% $Revision: 3397 $
% $Date: 2006-02-03 19:55:30 -0500 (Fri, 03 Feb 2006) $
%--------------------------------

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% handle grouped controls
%--

if iscell(control.name)
	
	%--
	% replace empty string cells for empty tip
	%--
	
	if isempty(control.tooltip)
		
		control.tip = cell(size(control.name)); 
		
		for k = 1:numel(control.tip)
			control.tip{k} = '';
		end
		
	%--
	% check for cell tip of matching size
	%--
	
	else

		if ~iscell(control.tooltip)
			error('Tooltip must be cell for grouped control.');
		end

		if ~isequal(size(control.name), size(control.tooltip))
			error('Tooltip and name cell arrays must match.');
		end
		
	end
	
end

%---------------------------
% TOOLTIP
%---------------------------

tip = control.tooltip;

%---------------------------
% DEVELOPER TIP
%---------------------------

return;

% NOTE: check developer state and return quickly if not

if ~xbat_developer
	return;
end

if ischar(tip)
	tip = compute_developer_tooltip(tip, control.name, callback);
else
	for k = 1:numel(tip)
		tip{k} = compute_developer_tooltip(tip{k}, control.name{k}, callback{k});
	end
end


%----------------------------------------------------------
% COMPUTE_DEVELOPER_TIP
%----------------------------------------------------------

function tip = compute_developer_tooltip(tip, name, callback)

% compute_developer_tooltip - compute developer tooltip
% -----------------------------------------------------
%
% tip = compute_developer_tooltip(tip, name, callback)
%
% Input:
% ------
%  tip - control tip
%  name - control name
%  callback - control callback
%
% Output:
% -------
%  tip - tip 

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3397 $
% $Date: 2006-02-03 19:55:30 -0500 (Fri, 03 Feb 2006) $
%--------------------------------

% NOTE: this function depends on 'to_xml' and 'html_escape'

%--
% get callback type and info
%--

type = class(callback);

switch type

	% TODO: include info about cell length

	case 'cell'
		info = ['\n', to_xml(callback{1})];

	case 'char'
		info = callback;

	case 'function_handle'
		info = ['\n', to_xml(callback)];

	% NOTE: the empty callback should have class 'double'

	otherwise
		info = ''; type = '(EMPTY)';

end
	
%--
% put together tip
%--

% TODO: update to use 'nice_catch' with more informative message

try
	tip = [ ...
		'\n %% NAME %% \n', name, ...
		'\n %% TOOLTIP %% \n', tip, ...
		'\n %% CALLBACK %%', ...
		'\n TYPE: ', type, ...
		'\n FUN: ', info ...
	];
catch
	tip = 'FAILED TO COMPILE TIP';
end

try
	tip = html_escape(sprintf(tip));
catch
	tip = 'FAILED TO ESCAPE TIP';
end
