function migrate_xbat(type, source)

% migrate_xbat - migrate older version files to current version
% -------------------------------------------------------------
%
% migrate_xbat(type, source)
%
% Input:
% ------
%  type - migration type
%  source - origin of migration

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

% NOTE: migration works as concept, since we are working only with XBAT files

%------------------
% HANDLE INPUT
%------------------

if nargin < 1
	
	result = migrate_dialog; 
	
	if ~strcmp(result.action, 'ok')
		return;
	end
	
	type = result.values.type{1};
	
	source = result.values.source;
	
end

if strcmpi(type, 'log')
	type = 'logs';
end

%------------------
% MIGRATE
%------------------

%--
% set up waitbar
%--

migrate_wait(type);

%--
% migrate
%--

migrate_fun = ['migrate_', lower(type)];

if ~isempty(which(migrate_fun))
	
	migrate_fun = str2func(migrate_fun); 

	result = migrate_fun(source);
	
end

%--
% clean up waitbar
%--

migrate_wait('finish');

%--
% handle result
%--

if isempty(result)
	warn_dialog(['No ', type, ' found in specified location.'], 'Invalid Migration Source'); return;
end

%--
% update xbat palette state
%--

xbat_palette('User');






