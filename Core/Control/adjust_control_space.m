function control = adjust_control_space(control, next)

%--
% handle input
%--

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

if nargin < 2
	return;
end 

% NOTE: this is the ugliest duckling ever, why even bother

if ~isfield(control, 'space')
	error('Control must have space field to adjust.');
end

if ~isfield(next, 'style')
	error('Next control does not have style field.');
end

%--
% adjust control
%--

switch next.style

	case {'axes', 'slider'}
		control.space = 1.5;

	case {'buttongroup'}
		control.space = 1;

	case {'edit', 'popup', 'checkbox'}
		control.space = 0.75;

	case 'separator'
		control.space = 1.5;

	case 'tabs'
		control.space = 0.12;

end


% FEATURE MENU

% switch (ext_controls(1).style)
% 	
% 	case ('separator')
% 
% 		if (~isempty(ext_controls(1).string))
% 			control(end).space = 1.25;
% 		end
% 
% 	case ('tabs'), control(end).space = 0.10;
% 
% 	case ('popup'), control(end).space = 0.75;
% 
% end

