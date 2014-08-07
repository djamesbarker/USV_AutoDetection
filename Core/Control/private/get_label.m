function label = get_label(control,opt)

% get_label - compute control label
% ---------------------------------
%
% label = get_label(control,opt)
%
% Input:
% ------
%  control - control
%  opt - palette options 
%
% Output:
% -------
%  label - control label

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

%--
% typically label is either name or alias
%--

if isempty(control.alias)
	label = control.name;
else
	label = control.alias;
end

% NOTE: return if there is no label fun

if isempty(opt.label_fun)
	return;
end

%--
% perform locale replacement if needed
%--

% 	if (opt.get_text)
% 		label = get_text(label);
% 	end

%--
% prepare label for display if needed
%--

% NOTE: the default label function is 'title_caps'

switch (control.style)

	%--
	% separators and tabs are special cases
	%--

	case ('separator')

		control.string = opt.label_fun(control.string);

	case ('tabs')

		% NOTE: store the modified tab names in tab 'alias', the function handles cell arrays

		if (isempty(control.alias))
			control.alias = opt.label_fun(control.tab);
		end

	%--
	% typical controls are labelled with label
	%--

	otherwise

		label = opt.label_fun(label);

end
