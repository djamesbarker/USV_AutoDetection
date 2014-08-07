function page = get_browser_page(par, data)

% get_browser_page - get standard page struct from browser
% --------------------------------------------------------
%  
% page = get_browser_page(par, data)
%
% Input:
% ------
%  par - browser handle
%  data - browser data
%
% Output:
% -------
%  page - the page

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
% handle input
%--

if ~nargin || isempty(par)
	par = get_active_browser;
end

if nargin < 2 || isempty(data)
	data = get_browser(par);
end

%--
% populate page from browser
%--

slider = get_time_slider(par);

page.start = slider.value;

page.duration = get_browser(par, 'page__duration', data);

