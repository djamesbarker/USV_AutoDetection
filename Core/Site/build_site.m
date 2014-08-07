function  [files, updated] = build_site(site, theme, opt)

% BUILD_SITE build site
%
% [files, updated] = build_site(site, theme, opt)

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

% TODO: define 'opt' and implement passing 

start = clock;

disp(' ');

disp(['Starting to build site ''', site, ''' (', datestr(start), ')']);

sites_cache_clear;

%--
% get site model if needed
%--

% NOTE: we consider that input is either site name or model

if ischar(site)
	model = model_site(site);
else
	model = site;
end

%--
% add theme to model
%--

if (nargin < 2)
	model.theme = [];
else
	model.theme = theme;
end

%--
% build pages
%--

N = length(model.pages); files = cell(N, 1); updated = zeros(N, 1);

disp(' ');

for k = 1:N
	
	[files{k}, updated(k)] = build_page(model, model.pages(k));
	
	disp(['Updating <a href="matlab:web(''', files{k}, ''', ''-browser'')">', files{k}, '</a>']);
	
end

disp(' ');

stop = clock;

disp(['Finished building site ''', site, ''' (', datestr(stop), ', ', sec_to_clock(etime(stop, start)), ')']);

disp(' ');

if ~nargout
	clear files;
end 
