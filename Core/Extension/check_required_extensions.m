function check_required_extensions(ext)

% check_required_extensions - simple check for required extensions
% ----------------------------------------------------------------
%
% req = check_required_extensions(ext)
%
% Input:
% ------
%  ext - extension we want to check required extensions for

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
% $Revision: 3213 $
% $Date: 2006-01-18 17:53:34 -0500 (Wed, 18 Jan 2006) $
%--------------------------------

% NOTE: at the moment this function is a simple sanity check

% TODO: add toolbox dependencies

% TODO: move required sound metadata to context ??

%--
% check for existence of required extension directories
%--

for k = 1:length(ext.required)
	
	%--
	% parse required string
	%--
	
	[type,name] = strtok(ext.required{k},'::'); name = name(3:end);
		
	%--
	% check for extension directory
	%--
	
	% NOTE: this requires the name to match the extension directory
		
	tmp_info = what(['Extensions', filesep, type_to_dir(type), filesep, name]);
	
	tmp = tmp_info.path;
		
	if (~exist(tmp,'dir'))
		
		% NOTE: eventually check for, download, and install required extensions
		
		disp(' ')
		error(['Extension ''' ext.name ''' requires extension''' ext.required{k} '''.']);
		
	end
	
end
