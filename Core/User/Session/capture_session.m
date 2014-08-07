function content = capture_session

% capture_session - capture session contents
% ------------------------------------------
%
% content = capture_session
%
% Output:
% -------
%  content - session content

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

% NOTE: the tags contain user, library, and sound name information

figs = get_xbat_figs('type', 'sound');

if isempty(figs)
	content = []; return;
end

content = get(figs, 'tag');

if ischar(content)
	content = {content};
end 
