function page = get_channel_page(page, k);

%--
% create channel specific page from multiple channel page
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

page.channels = page.channels(k);

page.samples = page.samples(:, k);

% TODO: in the general scan we will also need to pull out channel features

if ~isfield(page, 'filtered')
	page.filtered = [];
end

if ~isempty(page.filtered)
	page.filtered = page.filtered(:, k);
end
