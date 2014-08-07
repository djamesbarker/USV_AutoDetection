function page = filter_sound_page(page, context)

% filter_sound_page - filter a sound page using context
% -----------------------------------------------------
%
% page = filter_sound_page(page, context)
%
% Input:
% ------
%  page - page to filter
%  context - context
%
% Output:
% -------
%  page - filtered page

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
% check if we need to filter
%--

if isempty(context) || isempty(context.active.signal_filter)
	page.filtered = []; return;
end

%--
% filter page
%--

% NOTE: the context page provides channels information

context.page = page;

page.filtered = apply_signal_filter(page.samples, context.active.signal_filter, context);
